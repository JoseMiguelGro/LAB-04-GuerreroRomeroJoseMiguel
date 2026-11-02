-- Actividad 8 - Revisar usuarios y privilegios
-- Comando en psql: \du
-- Alternativa SQL:
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles ORDER BY rolname;
