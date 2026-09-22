# PHP 8.4 deprecated

Source: https://www.php.net/manual/en/migration84.deprecated.php

P2. These warn on 8.4 and 8.5 and still run.

| ID | What warns | Search | After | Rector (only this rule) |
| --- | --- | --- | --- | --- |
| 84d-nullable | Implicit nullable: `function f(T $a = null)`. If a required param follows, the default must also go | `= null)` and `= null,` on typed params | `function f(?T $a = null)`. Required param after it: `function f(?T $b, U $c)` with no `= null` on `$b` | `ExplicitNullableParamTypeRector` does the `?T` form only. It does not drop `= null` before a required param. Do that by hand |
| 84d-pow-zero-neg | `0 ** -n` and `pow(0, -n)` | `pow(`, `**` | Use `fpow()` for IEEE semantics. Otherwise avoid a zero base with a negative exponent | none |
| 84d-class-underscore | Class name `_` exactly. `_MyClass` is fine | `class _` | Rename the class | none |
| 84d-e-user-error | `trigger_error(..., E_USER_ERROR)` | `E_USER_ERROR` | Throw, or `exit()` when exit is the real intent | none |
| 84d-e-strict | Constant `E_STRICT` | `E_STRICT` | Remove it from masks and comparisons | none |
| 84d-curlopt-binary | `CURLOPT_BINARYTRANSFER` | `CURLOPT_BINARYTRANSFER` | Delete the option. It has no effect | none |
| 84d-dateperiod-iso | `new DatePeriod($isoString, $options)` | `new DatePeriod` | `DatePeriod::createFromISO8601String()` | none |
| 84d-sunfuncs | `SUNFUNCS_RET_TIMESTAMP`, `SUNFUNCS_RET_STRING`, `SUNFUNCS_RET_DOUBLE` | `SUNFUNCS_RET_` | Stop using `date_sunrise()` / `date_sunset()` results via these constants | none |
| 84d-dba-key-split | `dba_key_split(null)` or `dba_key_split(false)` | `dba_key_split(` | Do not pass null or false. It already returned false | none |
| 84d-dom-php-err | `DOM_PHP_ERR` | `DOM_PHP_ERR` | Stop comparing against it. Allocation failures throw (`84i-dom-alloc`) | none |
| 84d-dom-props | `DOMDocument::$actualEncoding`, `$config`; `DOMEntity::$actualEncoding`, `$encoding`, `$version` | `actualEncoding`, `->config` on DOM | Stop reading these properties | none |
| 84d-hash-options | Invalid options array to hash functions | `hash_hmac(`, `hash_pbkdf2(`, `hash(` | Pass only documented options | none |
| 84d-intlcal-set | `IntlCalendar::set()` / `intlcal_set()` with more than 2 args | `IntlCalendar::set(`, `intlcal_set(` | `setDate()` or `setDateTime()` | none |
| 84d-intlgreg | `IntlGregorianCalendar` construct or `intlgregcal_create_instance()` with more than 2 args | `IntlGregorianCalendar`, `intlgregcal_create_instance(` | `createFromDate()` or `createFromDateTime()` | none |
| 84d-ldap-connect | `ldap_connect()` with more than 2 args | `ldap_connect(` | `ldap_connect_wallet()` for the wallet form. Note `85d-ldap-wallet`: that replacement is itself deprecated in 8.5 | none |
| 84d-ldap-exop | `ldap_exop()` with more than 4 args | `ldap_exop(` | `ldap_exop_sync()` | none |
| 84d-mysqli-ping | `mysqli_ping()` / `mysqli::ping()` | `mysqli_ping(`, `->ping(` | Delete. Reconnect was removed in 8.2 | none |
| 84d-mysqli-kill | `mysqli_kill()` / `mysqli::kill()` | `mysqli_kill(`, `->kill(` | SQL `KILL` | none |
| 84d-mysqli-refresh | `mysqli_refresh()` / `mysqli::refresh()` and `MYSQLI_REFRESH_*` | `mysqli_refresh(`, `MYSQLI_REFRESH_` | SQL `FLUSH` | none |
| 84d-mysqli-store | Explicit `mode` on `mysqli_store_result()`, and `MYSQLI_STORE_RESULT_COPY_DATA` | `mysqli_store_result(`, `MYSQLI_STORE_RESULT_COPY_DATA` | Call `mysqli_store_result($result)` with no mode | none |
| 84d-pgsql-escape-q | `??` inside dollar-quoted strings in PDO_PGSQL | `??` in PostgreSQL SQL | A single `?` is enough inside dollar quotes | none |
| 84d-pg-2arg | 2-arg `pg_fetch_result()`, `pg_field_prtlen()`, `pg_field_is_null()` | those names | 3-arg form with `row: null` | none |
| 84d-lcg | `lcg_value()` | `lcg_value(` | `(new Random\Randomizer)->getFloat(0, 1)` | none |
| 84d-reflection-method | `new ReflectionMethod('Class::method')` one string | `new ReflectionMethod` | `ReflectionMethod::createFromMethodName('Class::method')` | none |
| 84d-session-handler | `session_set_save_handler()` with more than 2 args | `session_set_save_handler(` | Two-arg form: an object implementing `SessionHandlerInterface`, plus optional `register_shutdown` | none |
| 84d-session-sid | Changing `session.sid_length` or `session.sid_bits_per_character` | those ini keys | Accept 32-char hex session ids. Stop setting these | none |
| 84d-session-trans | Changing `session.use_only_cookies`, `session.use_trans_sid`, `session.trans_sid_tags`, `session.trans_sid_hosts`, `session.referer_check`. Constant `SID` | `SID`, those ini keys | Cookie sessions only. Stop reading `SID` | none |
| 84d-soap-add-function | `SoapServer::addFunction()` with an int, and `SOAP_FUNCTIONS_ALL` | `addFunction(`, `SOAP_FUNCTIONS_ALL` | Pass `get_defined_functions()` flattened, not the int constant | none |
| 84d-spl-fixed-wakeup | `SplFixedArray::__wakeup()` | `SplFixedArray` and `__wakeup` | Override `__serialize()` / `__unserialize()` | none |
| 84d-csv-escape | Default `escape` on `fputcsv()`, `fgetcsv()`, `str_getcsv()`, `SplFileObject::setCsvControl()` | `fputcsv(`, `fgetcsv(`, `str_getcsv(`, `setCsvControl(` | Pass `escape` explicitly. `SplFileObject` fput/fget are exempt when `setCsvControl()` already set a default | `AddEscapeArgumentRector` |
| 84d-stream-context | `stream_context_set_option($ctx, $optionsArray)` two args | `stream_context_set_option(` | `stream_context_set_options($ctx, $optionsArray)` | none |
| 84d-unserialize-s | Uppercase `S` tag in serialized strings | `unserialize(` | Regenerate the payload so strings use the lowercase `s` tag | none |
| 84d-xml | `xml_set_object()`, and non-callable strings passed to `xml_set_*` | `xml_set_object(`, `xml_set_` | `xml_set_element_handler($parser, [$this, 'start'], [$this, 'end'])` | none |
