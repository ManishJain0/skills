# PHP 8.4 incompatible

Source: https://www.php.net/manual/en/migration84.incompatible.php

P0. Every new function, class, interface, enum, or constant can throw a redeclaration `Error` if the app already declared that name.

| ID | What changes | Search | After |
| --- | --- | --- | --- |
| 84i-exit | `exit()` / `die()` follow `strict_types` and throw `TypeError` on invalid types instead of casting non-integers to string | `exit(`, `die(` | Pass an `int` status, or a `string` only when not under strict types. A non-integer status is now a `TypeError` |
| 84i-compare-recursion | Recursion while comparing throws `Error` instead of `E_ERROR` | not a grep | Catch `Error` if comparison of cyclic structures was handled as a fatal |
| 84i-readonly-clone | Inside `__clone()`, `$ref = &$this->readonlyProp` is forbidden | `__clone` | Do not take a reference to a readonly property while cloning |
| 84i-php-debug-zts | `PHP_DEBUG` and `PHP_ZTS` are `bool`, previously `int` | `PHP_DEBUG`, `PHP_ZTS` | Compare with `true` / `false`, not `1` / `0` |
| 84i-tempnam | `tempnam()` and uploaded-file names are 13 bytes longer | `tempnam(` | Paths that assumed the old length need a larger buffer or column |
| 84i-e-strict-level | `E_STRICT` error level is removed. The constant remains, deprecated (see `84d-e-strict`) | `E_STRICT` | Drop `E_STRICT` from `error_reporting` masks |

## Typed constants

Date, Intl, PDO, Reflection, SPL, Sqlite, XMLReader class constants are now typed. A subclass that redeclares one with a mismatched type fatals.

Search: subclasses of those extension classes that redeclare constants. Not a single token.

## Resource to object

`is_resource()` on these is wrong. Check `false`, or `null` where noted.

| ID | What changes | Search | After |
| --- | --- | --- | --- |
| 84i-dba | DBA uses `Dba\Connection` | `dba_` | `is_resource($conn)` → `$conn !== false` |
| 84i-odbc | ODBC uses `Odbc\Connection` and `Odbc\Result` | `odbc_` | same |
| 84i-soap-props | `SoapClient::$httpurl` is `Soap\Url` or `null`; `$sdl` is `Soap\Sdl` or `null`; `$typemap` is `array` or `null` | `->httpurl`, `->sdl`, `->typemap` | `!== null`, not `is_resource()` |

## New ValueError / TypeError (invalid arguments that used to warn or coerce)

| ID | Search | After |
| --- | --- | --- |
| 84i-curl-multi-select | `curl_multi_select(` | `timeout` must be `>= 0` and `<= PHP_INT_MAX` |
| 84i-gd | `imagejpeg(`, `imagewebp(`, `imagepng(`, `imageavif(`, `imagescale(`, `imagefilter(` | Invalid quality, speed, dimensions, mode, or scatter args throw `ValueError` |
| 84i-gettext | `bind_textdomain_codeset(`, `textdomain(` | Empty `domain` throws `ValueError` |
| 84i-intl | `ResourceBundle`, `IntlDateFormatter`, `NumberFormatter` | Bad offset or locale throws `TypeError` / `ValueError` |
| 84i-mbstring | `mb_encode_numericentity(`, `mb_decode_numericentity(`, `mb_http_input(`, `mb_http_output(` | `map` must be ints; invalid type or NUL in encoding throws `ValueError` |
| 84i-odbc-fetch | `odbc_fetch_row(` | `row <= 0` returns `false` and warns |
| 84i-pcntl | `pcntl_sigprocmask(`, `pcntl_sigwaitinfo(`, `pcntl_sigtimedwait(` | Empty signals, bad signal, bad mode, or bad timeout throws. Failure returns `false`, not `-1` |
| 84i-session-gc | `session.gc_divisor`, `session.gc_probability` | Non-positive divisor or negative probability warns |
| 84i-simplexml-import | `simplexml_import_dom(` | Non-XML object throws `TypeError` |
| 84i-round | `round(` | Invalid `mode` throws `ValueError`. It used to act like `PHP_ROUND_HALF_UP` |
| 84i-str-getcsv | `str_getcsv(` | `separator` and `enclosure` must be one byte; `escape` must be one byte or `""` |
| 84i-php-uname | `php_uname(` | Invalid `mode` throws `ValueError` |
| 84i-unserialize-allowed | `unserialize(` | `allowed_classes` must be `bool` or a list of class names |
| 84i-xmlreader | `XMLReader::open`, `XMLReader::XML` | Bad encoding or NUL throws `ValueError` |
| 84i-xmlwriter | `XMLWriter` | NUL in a string throws `ValueError` |
| 84i-xsl | `setParameter(`, `importStyleSheet(` | NUL throws `ValueError`. Non-XML stylesheet throws `TypeError`. A failing PHP callback throws |

## Other behavior

| ID | What changes | Search | After |
| --- | --- | --- | --- |
| 84i-dom-alloc | DOM node allocation throws `DOMException` `DOM_INVALID_STATE_ERR` instead of `false` / `DOM_PHP_ERR` | `DOMImplementation::createDocument` | Do not check for `false`. `getFeature()` is removed: delete the call |
| 84i-domxpath-clone | Cloning `DOMXPath` throws `Error` | `clone $xpath` | Build a new `DOMXPath` |
| 84i-gmp-final | `GMP` is final | `extends GMP` | Stop extending `GMP` |
| 84i-mysqli-const | Removed: `MYSQLI_SET_CHARSET_DIR`, `MYSQLI_STMT_ATTR_PREFETCH_ROWS`, `MYSQLI_CURSOR_TYPE_FOR_UPDATE`, `MYSQLI_CURSOR_TYPE_SCROLLABLE`, `MYSQLI_TYPE_INTERVAL` | those names | Delete the use. Cursor types were never implemented |
| 84i-mysqlnd-timeout | Wait timeout error is `4031` on MySQL ≥ 8.0.24, was `2006` | `2006` | Treat `4031` as server-has-gone-away for those servers |
| 84i-jit | Default JIT is `opcache.jit=disable` and `opcache.jit_buffer_size=64M`. Enabling via buffer size alone no longer turns JIT on. Failed JIT init is fatal | `opcache.jit` | Set `opcache.jit` explicitly to enable. `opcache.interned_strings_buffer` max on 64-bit is `32767` |
| 84i-pcre | Bundled PCRE2 10.44: `{,3}` is a quantifier, not literal text. UCP character classes changed | `preg_` | Recheck patterns that contain `{,` |
| 84i-pdo-bool-attr | Dblib stringify/datetime, Firebird autocommit, MySQL autocommit / emulate prepares / direct query are bool attributes, not int | `PDO::ATTR_AUTOCOMMIT`, `PDO::ATTR_EMULATE_PREPARES`, `PDO::MYSQL_ATTR_DIRECT_QUERY`, `ATTR_STRINGIFY_UNIQUEIDENTIFIER`, `ATTR_DATETIME_CONVERT` | Pass and expect `true` / `false` |
| 84i-pdo-pgsql-dsn | DSN credentials beat constructor user/password | `pgsql:` | Put the intended user and password in one place |
| 84i-simplexml-iter | `SimpleXMLElement` no longer rewinds its iterator when cast to string or when calling `asXML()` / `getName()` | `asXML(`, `->asXml(` inside a SimpleXML loop | The old infinite loop is gone. Do not rely on the rewind |
| 84i-strcspn | `strcspn($s, "")` returns the length, not the first NUL | `strcspn(` | Empty character mask means "no stop characters" |
| 84i-http-build-query | `http_build_query()` encodes backed enums | `http_build_query(` | Enum values are now included. Confirm query strings |
| 84i-stream-bucket | `stream_bucket_make_writeable()` and `stream_bucket_new()` return `StreamBucket`, not `stdClass` | those names | Type-hint `StreamBucket` |
| 84i-tidy | Constructor failure throws instead of warning with a broken object | `new tidy` | Catch the exception |
| 84i-xml-handlers | `xml_set_*_handler` requires `callable\|string\|null`. A method-name string is checked against the object from `xml_set_object()`, which must run first. Empty string still disables the handler and is deprecated (`84d-xml`) | `xml_set_` | Pass `[$object, 'method']` instead of a method-name string |
