---
name: php-83-to-85
description: >-
  Scans a PHP 8.3 codebase for PHP 8.4 and 8.5 incompatible changes and
  deprecations, gives the official rewrite for each hit, and writes a
  compatibility report. Use when upgrading or porting from PHP 8.3 to PHP 8.5,
  fixing PHP 8.4 or 8.5 deprecations, or checking whether PHP 8.3 code will
  warn or break on PHP 8.5.
---

# PHP 8.3 → 8.5

Baseline is PHP 8.3. Target is PHP 8.5. Skip PHP 8.0–8.2-only issues. Do not adopt new 8.4/8.5 syntax.

Source of truth, in this order:

1. [PHP 8.4 incompatible](https://www.php.net/manual/en/migration84.incompatible.php) → [incompatible-84.md](incompatible-84.md)
2. [PHP 8.4 deprecated](https://www.php.net/manual/en/migration84.deprecated.php) → [deprecated-84.md](deprecated-84.md)
3. [PHP 8.5 incompatible](https://www.php.net/manual/en/migration85.incompatible.php) → [incompatible-85.md](incompatible-85.md)
4. [PHP 8.5 deprecated](https://www.php.net/manual/en/migration85.deprecated.php) → [deprecated-85.md](deprecated-85.md)

A hit that is not in those four files is out of scope. Same change listed twice: report it once, under the page that owns it.

## Do not

- Mask `E_DEPRECATED` / `E_USER_DEPRECATED` with `error_reporting`.
- Edit `vendor/`, `node_modules/`, or `storage/`.
- Edit `composer.json`. If `require.php` does not allow 8.5, or `config.platform.php` is below 8.5, suggest the bump in the report and leave the file alone.
- Run the full Rector `PHP_84` / `PHP_85` sets unskipped. They also rewrite working code into new syntax (`array_find`, `array_first`, `new Foo()->bar()`, `RoundingMode`, `#[\Override]`) and rename `FILTER_DEFAULT`, which the manual does not deprecate. See **Rector config**.
- Apply `SleepToSerializeRector` or `WakeupToUnserializeRector` without reading the method. `__serialize()` returns an array of values; `__sleep()` returns property names.

## Scan

Read all four reference files, then search. Exclude `vendor/`, `node_modules/`, `storage/`. Include `*.php` and `*.blade.php`.

1. Read each `composer.json` (not inside `vendor/`). Record `require.php` and `config.platform.php`. Below 8.5: add a bump suggestion to the report and continue.
2. Platform: read the installed framework version (`laravel/framework`, `symfony/*`) from `vendor/composer/installed.json` and look up its supported PHP range on the framework's release page. Not supporting 8.5 is a **P0 platform blocker**; cite the URL.
3. Run the tools in **Tools** from each project root that has them. Map each hit to a reference ID; a hit with no ID is out of scope and only counted.
4. Grep every **Search** cell. Skip a reference section whose extension is unused (no `ldap_`, `odbc_`, `snmp_`, `soap`, `pcntl_`, `gmp_`, `dba_`, `tidy_`, `xslt_`, `bzcompress`, `oci_`).
5. Read each hit. Drop false positives (already `?Type $a = null`, comments, the word "binary" that is not a cast).
6. Priority: **P0** = incompatible file (throws, fatal, or behavior change). **P2** = deprecated file (warns, still runs). There is no "removed in 8.5" bucket beyond what the incompatible pages already list.

Present the report. Do not edit code until the user confirms which IDs to fix.

## Report

```
# PHP 8.3 → 8.5 compatibility report

Scope: <roots scanned>
PHP constraint: <require.php and config.platform.php per composer.json>
Suggested bump: <composer.json files below 8.5, or "none">
Tools: <phpstan / rector dry-run: ran, not installed, or failed with the error>

## Platform blockers
| Package | Installed | Supports PHP | Source |
| --- | --- | --- | --- |
| laravel/framework | vN | 8.x – 8.y | <release page URL> |

## Summary
| Priority | Meaning | Count |
| --- | --- | --- |
| P0 | Incompatible on 8.4 or 8.5 | N |
| P2 | Deprecated on 8.4 or 8.5; still runs | N |

## Findings
| File:line | ID | Priority | Source | Match | Rewrite |
| --- | --- | --- | --- | --- | --- |
| path:line | 84d-nullable | P2 | grep, phpstan, rector | `function f(User $u = null)` | `function f(?User $u = null)` |

## Needs a runtime pass
<IDs marked "not a grep" that this app can still hit, each with the behavior change>

## Extensions skipped
<unused extension sections>

## Out of scope tool hits
<count per tool of hits with no reference ID, e.g. library `@deprecated` symbols>

## Not changed
composer.json: left as-is
```

One row per hit. Quote the match. The Rewrite cell is the **After** text from the reference, filled in for this call site. If the reference says to read the body first, say so in that cell.

## Fix

After confirmation, change only confirmed rows, using that row's Rewrite: by hand, or `vendor/bin/rector process --only=<Rule>` when the reference names that rule for the ID. Never run `rector process` without `--dry-run` or `--only`. Then re-grep those IDs, re-run the tools, and add:

```
## Recheck
| ID | Remaining hits |
| --- | --- |
| 84d-nullable | 0 |
```

A remaining hit stays in the report. Do not mark it fixed.

## Tools

Run on the host from each project root, never in a container. Need `php -v` ≥ 8.5; otherwise skip and say so under **Tools**. Tools are scanners: the reference files still decide ID, priority and rewrite. A clean tool run does not clear a grep hit.

- PHPStan: `vendor/bin/phpstan analyse --no-progress --error-format=json`. Needs `phpVersion: 80500` (or higher) in `phpstan.neon` and `phpstan/phpstan-deprecation-rules` included; if either is missing, suggest it in the report. It catches deprecated built-ins and implicit nullable params. Library `@deprecated` hits are out of scope. In a package scanned without its host app, `class.notFound` / `function.notFound` for app classes are noise: count them, do not report them.
- Rector: `vendor/bin/rector process --dry-run --output-format=json`. Uses the project `rector.php`. If its sets or skips differ from **Rector config**, suggest the change in the report instead of running it.

## Rector config

Sets are not cumulative: `SetList::PHP_85` does not load the 8.4 rules. Use both, and skip the rules that only adopt new syntax or change working code:

```php
$rectorConfig->sets([SetList::PHP_84, SetList::PHP_85]);
$rectorConfig->skip([
    \Rector\Php84\Rector\MethodCall\NewMethodCallWithoutParenthesesRector::class,
    \Rector\Php84\Rector\Foreach_\ForeachToArrayFindRector::class,
    \Rector\Php84\Rector\Foreach_\ForeachToArrayFindKeyRector::class,
    \Rector\Php84\Rector\Foreach_\ForeachToArrayAllRector::class,
    \Rector\Php84\Rector\Foreach_\ForeachToArrayAnyRector::class,
    \Rector\Php84\Rector\FuncCall\RoundingModeEnumRector::class,
    \Rector\Php85\Rector\ArrayDimFetch\ArrayFirstLastRector::class,
    \Rector\Php85\Rector\Property\AddOverrideAttributeToOverriddenPropertiesRector::class,
    \Rector\Php85\Rector\Class_\SleepToSerializeRector::class,
    \Rector\Php85\Rector\Class_\WakeupToUnserializeRector::class,
    \Rector\Renaming\Rector\ConstFetch\RenameConstantRector::class, // FILTER_DEFAULT only
]);
```

## References

- [Rector PHP 8.4 set](https://getrector.com/find-rule?activeRectorSetGroup=php&rectorSet=php-php-84), [PHP 8.5 set](https://getrector.com/find-rule?activeRectorSetGroup=php&rectorSet=php-php-85).
- [PHP 8.4 UPGRADING](https://github.com/php/php-src/blob/PHP-8.4/UPGRADING), [PHP 8.5 UPGRADING](https://github.com/php/php-src/blob/PHP-8.5/UPGRADING). They duplicate the manuals.
- [PHPCompatibility 10.0.0-alpha2](https://github.com/PHPCompatibility/PHPCompatibility/releases/tag/10.0.0-alpha2): alpha, incomplete. Run only if the user asks.
