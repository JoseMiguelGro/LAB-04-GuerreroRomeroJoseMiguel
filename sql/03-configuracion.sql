-- Actividad 4 - Revisar pg_hba.conf
SELECT type, database, user_name, address, auth_method FROM pg_hba_file_rules;

-- Actividad 7 - Revisar autenticación
SHOW password_encryption;

-- Actividad 10 - Revisar extensiones
SELECT extname, extversion FROM pg_extension ORDER BY extname;

-- Actividad 11 - Revisar configuración relacionada con conexiones
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
