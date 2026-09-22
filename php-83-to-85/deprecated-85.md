# PHP 8.5 deprecated

Source: https://www.php.net/manual/en/migration85.deprecated.php

P2. These warn on 8.5 and still run. They did not warn on 8.3.

| ID | What warns | Search | After | Rector (only this rule) |
| --- | --- | --- | --- | --- |
| 85d-output-handler | Producing output (`echo`, print) inside a user output handler | `ob_start(` | Do not write output in the handler. The warning bypasses that handler | none |
| 85d-cast | Casts `(boolean)`, `(integer)`, `(double)`, `(binary)` | `(boolean)`, `(integer)`, `(double)`, `(binary)` | `(bool)`, `(int)`, `(float)`, `(string)` | `RenameCastRector` |
| 85d-case-semi | `case` or `default` ended with `;` | `case `, `default;` | Use `:`. `case 1;` → `case 1:` | `ColonAfterSwitchCaseRector` |
| 85d-backtick | Backtick operator, alias of `shell_exec()` | a backtick pair in PHP | `shell_exec('cmd')`. Both return `null` on failure | `ShellExecFunctionCallOverBackticksRector` |
| 85d-debug-info | `__debugInfo()` returning `null` | `function __debugInfo` | `return []` | `NullDebugInfoReturnRector` |
| 85d-report-memleaks | ini `report_memleaks` | `report_memleaks` | Remove the setting | none |
| 85d-const-redeclare | `define()` or `const` of a name that already exists. Already warned; now also deprecated | `define(` | Define each name once | none |
| 85d-closure-bind | `Closure::bind` / `bindTo` misuse that already warned: static closure + instance, wrong class, unbinding `$this`, binding to an internal class, rebinding a function closure | `->bindTo(`, `Closure::bind(` | Stop the bind. The warning is now a deprecation | none |
| 85d-sleep-wakeup | `__sleep()` and `__wakeup()`. Soft deprecation: no runtime warning on 8.5 | `function __sleep`, `function __wakeup` | `__serialize(): array` of values, `__unserialize(array $data): void`. Read the body first. `__sleep` returned names; `__serialize` returns values. Keep both methods only if PHP 7 must still load the class | Do not run `SleepToSerializeRector` or `WakeupToUnserializeRector` until the body is checked. They guess the property copy |
| 85d-null-offset | `null` as an array key, or `array_key_exists(null, $a)` | `array_key_exists(null`, `[null]` | Use `''`. `$a[null]` becomes `$a['']` | `ArrayKeyExistsNullToEmptyStringRector` covers `array_key_exists` only |
| 85d-str-inc | `$s++` / `++$s` when `$s` is a non-numeric string | `++` on strings | `str_increment($s)` | none |
| 85d-argc-argv | Web SAPI filling `$_SERVER['argc']` / `argv` from the query string | `$_SERVER['argc']`, `$_SERVER['argv']`, `register_argc_argv` | Set `register_argc_argv=0`. Read `$_GET` or `QUERY_STRING` | none |
| 85d-curl-close | `curl_close()`, `curl_share_close()` | `curl_close(`, `curl_share_close(` | Delete the call. Handles free themselves | `RemoveFuncCallRector` |
| 85d-date-rfc7231 | `DATE_RFC7231`, `DateTimeInterface::RFC7231` | `RFC7231` | Format GMT yourself. The constant ignores the object timezone | none |
| 85d-finfo-close | `finfo_close()` | `finfo_close(` | Delete the call | `RemoveFuncCallRector` |
| 85d-finfo-context | `finfo_buffer()` `context` argument | `finfo_buffer(` | Drop the context argument. It is ignored | `RemoveFinfoBufferContextArgRector` |
| 85d-imagedestroy | `imagedestroy()` | `imagedestroy(` | Delete the call | `RemoveFuncCallRector` |
| 85d-mhash | `MHASH_*` constants | `MHASH_` | Use `hash()` algorithm names | none |
| 85d-intl-error-level | ini `intl.error_level` | `intl.error_level` | Check errors yourself, or set `intl.use_exceptions` | none |
| 85d-ldap-wallet | `ldap_connect()` wallet form, `ldap_connect_wallet()`, `GSLC_SSL_NO_UATH`, `GSLC_SSL_ONEWAY_UATH`, `GSLC_SSL_TWOWAY_UATH` | `ldap_connect_wallet(`, `GSLC_SSL_` | Stop using the Oracle Instant Client wallet API | none |
| 85d-mysqli-execute | `mysqli_execute()` alias | `mysqli_execute(` | `mysqli_stmt_execute()` | `RenameFunctionRector` |
| 85d-openssl-key-length | `openssl_pkey_derive()` `key_length` | `openssl_pkey_derive(` | Omit `key_length`. It is ignored or truncates the key | `RemoveFuncCallArgRector` |
| 85d-pdo-uri | DSN prefix `uri:` | `uri:` | Do not load a DSN from a remote URI | none |
| 85d-reflection-set-accessible | `Reflection*::setAccessible()` | `setAccessible(` | Delete the call. It has no effect since 8.1 | `RemoveReflectionSetAccessibleCallsRector` |
| 85d-reflection-missing | `ReflectionClass::getConstant()` for a missing constant; `ReflectionProperty::getDefaultValue()` when there is no default | `getConstant(`, `getDefaultValue(` | `hasConstant()` / `hasDefaultValue()` first | none |
| 85d-spl-autoload-unregister | `spl_autoload_unregister('spl_autoload_call')` | `spl_autoload_unregister(` | Unregister each entry from `spl_autoload_functions()` | none |
| 85d-spl-object-storage | `SplObjectStorage::contains()`, `attach()`, `detach()` | `->contains(`, `->attach(`, `->detach(` on `SplObjectStorage` | `offsetExists()`, `offsetSet()`, `offsetUnset()` | `RenameMethodRector` |
| 85d-arrayobject-object | `new ArrayObject($object)` or `new ArrayIterator($object)` where `$object` is not an array | `new ArrayObject`, `new ArrayIterator` | Pass an array. `new ArrayObject([$object])`, or `$arrayObject->getArrayCopy()` | none |
| 85d-socket-set-timeout | `socket_set_timeout()` | `socket_set_timeout(` | `stream_set_timeout()` | `RenameFunctionRector` |
| 85d-dir-null | `readdir(null)`, `rewinddir(null)`, `closedir(null)` | `readdir(`, `rewinddir(`, `closedir(` | Pass the directory handle | none |
| 85d-chr | `chr()` with an int outside 0–255 | `chr(` | `chr($n % 256)` keeps the old wrap. Or reject the value | `ChrArgModuloRector` wraps with `% 256`. That preserves the old byte, it does not reject bad input |
| 85d-ord | `ord()` of a string that is not one byte | `ord(` | `ord($s[0])` if the first byte was intended. A longer string is a bug | `OrdSingleByteRector` rewrites to the first byte. Read the call before applying |
| 85d-http-response-header | Variable `$http_response_header` | `$http_response_header` | `http_get_last_response_headers()` | none |
| 85d-xml-parser-free | `xml_parser_free()` | `xml_parser_free(` | Delete the call | `RemoveFuncCallRector` |

## PDO driver constants and methods

`PDO::` driver constants and methods are deprecated. Call the driver class. Rector: `RenameClassConstFetchRector` and `RenameMethodRector` in the 8.5 set.

Search: `PDO::MYSQL_`, `PDO::DBLIB_`, `PDO::FB_`, `PDO::ODBC_`, `PDO::PGSQL_`, `PDO::SQLITE_`, `->pgsql`, `->sqliteCreate`.

| PDO:: | Use |
| --- | --- |
| `DBLIB_ATTR_CONNECTION_TIMEOUT` | `Pdo\Dblib::ATTR_CONNECTION_TIMEOUT` |
| `DBLIB_ATTR_QUERY_TIMEOUT` | `Pdo\Dblib::ATTR_QUERY_TIMEOUT` |
| `DBLIB_ATTR_STRINGIFY_UNIQUEIDENTIFIER` | `Pdo\Dblib::ATTR_STRINGIFY_UNIQUEIDENTIFIER` |
| `DBLIB_ATTR_VERSION` | `Pdo\Dblib::ATTR_VERSION` |
| `DBLIB_ATTR_TDS_VERSION` | `Pdo\Dblib::ATTR_TDS_VERSION` |
| `DBLIB_ATTR_SKIP_EMPTY_ROWSETS` | `Pdo\Dblib::ATTR_SKIP_EMPTY_ROWSETS` |
| `DBLIB_ATTR_DATETIME_CONVERT` | `Pdo\Dblib::ATTR_DATETIME_CONVERT` |
| `FB_ATTR_DATE_FORMAT` | `Pdo\Firebird::ATTR_DATE_FORMAT` |
| `FB_ATTR_TIME_FORMAT` | `Pdo\Firebird::ATTR_TIME_FORMAT` |
| `FB_ATTR_TIMESTAMP_FORMAT` | `Pdo\Firebird::ATTR_TIMESTAMP_FORMAT` |
| `MYSQL_ATTR_USE_BUFFERED_QUERY` | `Pdo\Mysql::ATTR_USE_BUFFERED_QUERY` |
| `MYSQL_ATTR_LOCAL_INFILE` | `Pdo\Mysql::ATTR_LOCAL_INFILE` |
| `MYSQL_ATTR_LOCAL_INFILE_DIRECTORY` | `Pdo\Mysql::ATTR_LOCAL_INFILE_DIRECTORY` |
| `MYSQL_ATTR_INIT_COMMAND` | `Pdo\Mysql::ATTR_INIT_COMMAND` |
| `MYSQL_ATTR_MAX_BUFFER_SIZE` | `Pdo\Mysql::ATTR_MAX_BUFFER_SIZE` |
| `MYSQL_ATTR_READ_DEFAULT_FILE` | `Pdo\Mysql::ATTR_READ_DEFAULT_FILE` |
| `MYSQL_ATTR_READ_DEFAULT_GROUP` | `Pdo\Mysql::ATTR_READ_DEFAULT_GROUP` |
| `MYSQL_ATTR_COMPRESS` | `Pdo\Mysql::ATTR_COMPRESS` |
| `MYSQL_ATTR_DIRECT_QUERY` | `Pdo\Mysql::ATTR_DIRECT_QUERY` |
| `MYSQL_ATTR_FOUND_ROWS` | `Pdo\Mysql::ATTR_FOUND_ROWS` |
| `MYSQL_ATTR_IGNORE_SPACE` | `Pdo\Mysql::ATTR_IGNORE_SPACE` |
| `MYSQL_ATTR_SSL_KEY` | `Pdo\Mysql::ATTR_SSL_KEY` |
| `MYSQL_ATTR_SSL_CERT` | `Pdo\Mysql::ATTR_SSL_CERT` |
| `MYSQL_ATTR_SSL_CA` | `Pdo\Mysql::ATTR_SSL_CA` |
| `MYSQL_ATTR_SSL_CAPATH` | `Pdo\Mysql::ATTR_SSL_CAPATH` |
| `MYSQL_ATTR_SSL_CIPHER` | `Pdo\Mysql::ATTR_SSL_CIPHER` |
| `MYSQL_ATTR_SSL_VERIFY_SERVER_CERT` | `Pdo\Mysql::ATTR_SSL_VERIFY_SERVER_CERT` |
| `MYSQL_ATTR_SERVER_PUBLIC_KEY` | `Pdo\Mysql::ATTR_SERVER_PUBLIC_KEY` |
| `MYSQL_ATTR_MULTI_STATEMENTS` | `Pdo\Mysql::ATTR_MULTI_STATEMENTS` |
| `ODBC_ATTR_USE_CURSOR_LIBRARY` | `Pdo\Odbc::ATTR_USE_CURSOR_LIBRARY` |
| `ODBC_ATTR_ASSUME_UTF8` | `Pdo\Odbc::ATTR_ASSUME_UTF8` |
| `ODBC_SQL_USE_IF_NEEDED` | `Pdo\Odbc::SQL_USE_IF_NEEDED` |
| `ODBC_SQL_USE_DRIVER` | `Pdo\Odbc::SQL_USE_DRIVER` |
| `ODBC_SQL_USE_ODBC` | `Pdo\Odbc::SQL_USE_ODBC` |
| `PGSQL_ATTR_DISABLE_PREPARES` | `Pdo\Pgsql::ATTR_DISABLE_PREPARES` |
| `PGSQL_TRANSACTION_IDLE` | removed with PDO. Delete |
| `PGSQL_TRANSACTION_ACTIVE` | removed with PDO. Delete |
| `PGSQL_TRANSACTION_INTRANS` | removed with PDO. Delete |
| `PGSQL_TRANSACTION_INERROR` | removed with PDO. Delete |
| `PGSQL_TRANSACTION_UNKNOWN` | removed with PDO. Delete |
| `SQLITE_ATTR_EXTENDED_RESULT_CODES` | `Pdo\Sqlite::ATTR_EXTENDED_RESULT_CODES` |
| `SQLITE_ATTR_OPEN_FLAGS` | `Pdo\Sqlite::ATTR_OPEN_FLAGS` |
| `SQLITE_ATTR_READONLY_STATEMENT` | `Pdo\Sqlite::ATTR_READONLY_STATEMENT` |
| `SQLITE_DETERMINISTIC` | `Pdo\Sqlite::DETERMINISTIC` |
| `SQLITE_OPEN_READONLY` | `Pdo\Sqlite::OPEN_READONLY` |
| `SQLITE_OPEN_READWRITE` | `Pdo\Sqlite::OPEN_READWRITE` |
| `SQLITE_OPEN_CREATE` | `Pdo\Sqlite::OPEN_CREATE` |

| PDO:: method | Use |
| --- | --- |
| `pgsqlCopyFromArray` | `Pdo\Pgsql::copyFromArray` |
| `pgsqlCopyFromFile` | `Pdo\Pgsql::copyFromFile` |
| `pgsqlCopyToArray` | `Pdo\Pgsql::copyToArray` |
| `pgsqlCopyToFile` | `Pdo\Pgsql::copyToFile` |
| `pgsqlGetNotify` | `Pdo\Pgsql::getNotify` |
| `pgsqlGetPid` | `Pdo\Pgsql::getPid` |
| `pgsqlLOBCreate` | `Pdo\Pgsql::lobCreate` |
| `pgsqlLOBOpen` | `Pdo\Pgsql::lobOpen` |
| `pgsqlLOBUnlink` | `Pdo\Pgsql::lobUnlink` |
| `sqliteCreateAggregate` | `Pdo\Sqlite::createAggregate` |
| `sqliteCreateCollation` | `Pdo\Sqlite::createCollation` |
| `sqliteCreateFunction` | `Pdo\Sqlite::createFunction` |

ID for this table: `85d-pdo-driver`. One report row per file, listing each constant or method found there.
