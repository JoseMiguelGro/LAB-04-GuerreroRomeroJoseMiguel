# Línea Base de Seguridad (Baseline) - PostgreSQL 16

## Red
* **Interfaces autorizadas:** Limitar `listen_addresses` estrictamente a la red privada o localhost (ej. `listen_addresses = '10.10.10.20, localhost'`).
* **Puerto:** Mantener estándar (5432) pero restringido por firewall.
* **Firewall:** Regla *Allowlist* que solo permita origen desde la subred de aplicaciones y DBA (ej. `10.10.10.0/24`). Denegar implícitamente todo lo demás.

## Autenticación
* **Método:** `scram-sha-256` mandatorio. Eliminar cualquier rastro de métodos "trust" en red o "md5".
* **Políticas de credenciales:** Uso de gestor de contraseñas, deshabilitar conexiones sin clave.
* **Cuentas administrativas:** Prohibido el inicio de sesión remoto a las cuentas SUPERUSER.

## Autorización
* **Roles:** Implementación estricta de cuentas de consulta, app y administradores.
* **Privilegios:** Revocar accesos por defecto (como `PUBLIC`) sobre esquemas vitales.
* **Cuentas de aplicación:** Rol por aplicación, solo con permisos de manipulación de datos (DML) donde sea necesario. Sin permisos CREATEROLE, CREATEDB, LOGIN o SUPERUSER innecesarios.

## Configuración
* **Parámetros relevantes:** Definir límites lógicos en `max_connections` (basado en recursos del servidor, ej: 100), `statement_timeout` y `idle_in_transaction_session_timeout` para evitar acaparamiento de conexiones.
* **Extensiones:** Las estrictamente necesarias instaladas por los DBA.
* **Conexiones:** Uso preferente de un Pooler (como PgBouncer) en producción.

## Sistema Operativo
* **Propietario de archivos:** Usuario de servicio dedicado (`postgres`).
* **Permisos:** 
  * Archivos sensibles como `pg_hba.conf` y `postgresql.conf`: Permisos `600` o `640`.
  * Protección del directorio de datos (`PGDATA`): Permisos estrictos `700` (-rwx------).

## Cifrado
* **TLS:** Habilitado (`ssl = on`).
* **Protocolo:** `ssl_min_protocol_version = 'TLSv1.2'` (o TLSv1.3 preferiblemente).
* **Protección de credenciales:** Las aplicaciones no deben quemar contraseñas en el código fuente, sino extraerlas mediante variables de entorno seguras o baúles de claves.

## Mantenimiento
* **Actualización:** Evaluar e instalar actualizaciones menores de PostgreSQL periódicamente.
* **Revisión periódica:** Auditoría trimestral a la tabla de `pg_roles` y permisos remotos en `pg_hba.conf`.
* **Documentación:** Todo cambio de hardening se somete a control de versiones.
