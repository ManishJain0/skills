# PHP 8.5 incompatible

Source: https://www.php.net/manual/en/migration85.incompatible.php

P0. These throw, warn as a behavior change, or change a return value on 8.5. Code that only ran on 8.3 never saw them.

| ID | What changes | Search | After |
| --- | --- | --- | --- |
| 85i-class-alias | `class_alias(..., "array")` and `class_alias(..., "callable")` are rejected | `class_alias(` | Use a real class name. `"array"` and `"callable"` are not allowed alias names |
| 85i-object-bool | Loose compare of enums, `CurlHandle`, and other internal objects to a boolean follows `(bool)$object` in every case. Previously `$obj == $true` was always `false` when `$true` was not a literal | `== true`, `== false`, `!= true`, `!= false` on those objects | Compare with `===` or an explicit `(bool)` cast so the branch does not flip |
| 85i-gc-return | `gc_collect_cycles()` no longer counts strings and resources collected indirectly | `gc_collect_cycles(` | Do not assert on the old count |
| 85i-disable-classes | `disable_classes` ini is removed | `disable_classes` | Remove the ini setting |
| 85i-destructure | `[]` or `list()` on a non-array other than `null` warns | `list(` | Destructure only arrays. `null` is still allowed |
| 85i-float-int | Casting a float, or a float string, to `int` warns when it is not representable as an int (`NAN`, `INF`, outside ±`PHP_INT_MAX`). `(int)1.5` still truncates silently | not a grep | Range-check floats from external input before the cast |
| 85i-nan | Casting `NAN` to another type warns | not a grep | Guard with `is_nan()` before the cast |
| 85i-attribute-target | `#[Attribute]` on an abstract class, enum, interface, or trait is a compile error. It used to fail later in `ReflectionAttribute::newInstance()` | `#[Attribute]` | Put the attribute on a concrete class, or add `#[\DelayedTargetValidation]` to keep the check at runtime |
| 85i-bz | `bzcompress()` throws `ValueError` when `block_size` is outside 1–9 or `work_factor` is outside 0–250 | `bzcompress(` | Clamp the arguments |
| 85i-dom-clone | Cloning `DOMNamedNodeMap`, `DOMNodeList`, `Dom\NamedNodeMap`, `Dom\NodeList`, `Dom\HTMLCollection`, `Dom\DtdNamedNodeMap` fails | `clone` on those | Do not clone them. They never produced a working object |
| 85i-finfo-nul | `finfo_file()` / `finfo::file()` throws `ValueError` (was `TypeError`) when `filename` contains NUL | `finfo_file(`, `->file(` | Strip NUL before the call. Catch `ValueError` |
| 85i-intl | Locale methods throw `ValueError` on NUL in the locale. `setTimeZone()` on an uninitialised formatter throws `IntlException`. `Collator::SORT_REGULAR` matches `SORT_REGULAR` for numeric strings | `Locale::`, `Collator::` | Validate locales. Do not depend on the old numeric-string order |
| 85i-ldap-option | `ldap_get_option()` / `ldap_set_option()` throw `ValueError` on an invalid option | `ldap_set_option(`, `ldap_get_option(` | Pass a real option constant |
| 85i-mysqli-ctor | Calling the mysqli constructor on an already-constructed object throws `Error` | `parent::__construct` inside a `mysqli` subclass | Construct once |
| 85i-opcache-ini | Opcache is always compiled in. `zend_extension=opcache.so` or `php_opcache.dll` warns. `opcache.enable` and `opcache.enable_cli` still work | `opcache.so`, `php_opcache.dll` | Delete those `zend_extension` lines |
| 85i-pcntl-exec | `pcntl_exec()` throws `ValueError` when `args` or `env_vars` keys/values contain NUL | `pcntl_exec(` | Strip NUL |
| 85i-pdo-ctor-args | With `PDO::FETCH_CLASS`, constructor args follow `call_user_func_array` rules. String keys are named args. By-ref wrapping is gone and warns | `PDO::FETCH_CLASS` | For a by-ref constructor param: `$ctorArgs = [&$val]` |
| 85i-pdo-set-fetch-mode | `PDOStatement::setFetchMode()` during `fetch`, `fetchObject`, or `fetchAll` throws `Error` | `setFetchMode(` | Set the mode before fetching, not from the constructed object |
| 85i-pdo-fetch-values | Integer values of `PDO::FETCH_GROUP`, `FETCH_UNIQUE`, `FETCH_CLASSTYPE`, `FETCH_PROPS_LATE`, `FETCH_SERIALIZE` changed | those constants compared to a raw int | Compare to the constant, never to a stored integer |
| 85i-pdo-props-late | `PDO::FETCH_PROPS_LATE` with a mode other than `PDO::FETCH_CLASS` throws `ValueError` | `PDO::FETCH_PROPS_LATE` | Combine it only with `PDO::FETCH_CLASS` |
| 85i-pdo-fetch-into | `PDO::FETCH_INTO` passed to `fetchAll()` throws `ValueError` | `FETCH_INTO` | Use `fetch()`, or `FETCH_CLASS` |
| 85i-pdo-sqlite-nul | SQLite `PDO::quote()` warns or throws, per error mode, if the string contains NUL | `->quote(` | Reject NUL in values before quote |
| 85i-session-pipe | A `$_SESSION` key containing `\|` warns on write instead of failing silently | `$_SESSION[` | Do not use `\|` in session keys |
| 85i-session-start | `session_start($options)` throws `ValueError` if the array is a list, `TypeError` if `read_and_close` is not int-compatible | `session_start(` | Pass a string-keyed array. `read_and_close` must be int-compatible |
| 85i-simplexml-xpath | `SimpleXMLElement::xpath()` warns and returns `false` when the expression is not a node-set. It used to return `[]` | `->xpath(` | Check for `false`, not only for an empty array |
| 85i-arrayobject-enum | `ArrayObject` does not accept an enum | `new ArrayObject` | Pass an array |
| 85i-spl-fwrite | `SplFileObject::fwrite()` `$length` defaults to `null`, was `0` | `->fwrite(` | Pass `null` to write the whole string. `0` writes nothing |
| 85i-printf-precision | A printf formatter that omitted precision used to reset precision. It is now precision 0 | `printf(`, `sprintf(`, `fprintf(` | Write `%.0f` or an explicit precision. `%.f` no longer means "reset" |
| 85i-setlocale-zero | Integer `0` as the locales argument throws `TypeError` | `setlocale(` | Pass a locale string. To read the current locale, pass the string `"0"`, not the integer `0` |
| 85i-tidy | `tidy` construct, `parseFile`, `parseString` throw `ValueError` on invalid or read-only config, `TypeError` if a key is not a string | `new tidy`, `parseFile(`, `parseString(` | Fix the config array |

Also fatal or narrower, still P0, grep only if the extension is used:

| ID | Search | After |
| --- | --- | --- |
| 85i-posix | `posix_kill(`, `posix_setpgid(`, `posix_setrlimit(` | Out-of-range pid or rlimit throws `ValueError` |
| 85i-snmp | `snmpget(`, `snmpset(`, `snmp2_`, `snmp3_`, `new SNMP` | Bad host, NUL, or port outside 0–65535 throws `ValueError` |
| 85i-sockets | `socket_create_listen(`, `socket_bind(`, `socket_sendto(`, `socket_addrinfo_lookup(`, `socket_set_option(` | Port must be 0–65535. Hints must be string keys. Multicast options require a valid array or object and an inet family |
| 85i-firebird-cursor | Firebird PDO cursor name too long | Throws `ValueError`. Shorten the name |
| 85i-sqlite-collation | `PDO::sqliteCreateCollation()` callback return type | Throw path now matches `Pdo\Sqlite::createCollation()`. Return int |

These are behavior changes with no call-site rewrite. Mention them in **Needs a runtime pass** only:

- Traits bind before the parent class.
- Tick handlers are removed after shutdown, destructors, and output-handler cleanup.
- Compile and class-link errors are delayed until that phase finishes. A fatal during that phase handles delayed errors without the user error handler.
- An exception from a user error handler during class linking no longer becomes a fatal and no longer stops linking.
- `static` may be replaced by `self` or the class name in a final subclass (this one is wider, not a break).
