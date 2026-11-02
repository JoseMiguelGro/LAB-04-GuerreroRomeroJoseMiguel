# LAB-04 - Hardening y configuración segura de PostgreSQL

- **Autor: Guerrero Romero Jose Miguel**
- **Grupo: 4-3**

## Objetivo
Aplicar un proceso básico de hardening de PostgreSQL, identificando configuraciones inseguras, reduciendo la superficie de exposición y estableciendo controles de acceso, autenticación y configuración segura.

## Entorno
* Motor: PostgreSQL 16
* Sistema Operativo: Linux
* Rol: Administrador de Base de Datos (DBA)

## Superficie de ataque inicial
Se detectó que el servidor escuchaba en todas las interfaces (`listen_addresses = '*'`), el puerto 5432 estaba expuesto a redes amplias, había reglas permisivas en `pg_hba.conf` (como `0.0.0.0/0`), y se utilizaban cuentas administrativas para conexiones de aplicaciones.

## Hallazgos
* Falta de separación de roles y privilegios (aplicaciones usando SUPERUSER).
* Archivos de configuración con riesgo de exposición a nivel de sistema operativo.
* Puerto expuesto sin justificación de segmentación de red adecuada.

## Cambios realizados
* Se restringió el valor de `listen_addresses` a la IP privada necesaria.
* Se modificó `pg_hba.conf` aplicando un modelo de Allowlist con cifrado `scram-sha-256`.
* Se separaron cuentas creando perfiles DBA, APP y CONSULTA, revocando permisos excesivos.
* Se verificó la implementación de TLS.

## Justificación de los cambios
Los cambios responden al principio de **Mínimo Privilegio** y a la reducción de la **Superficie de Ataque**. Se implementó "Secure by default", garantizando que el acceso se otorgue únicamente a las entidades explícitamente autorizadas a nivel de red (Firewall), nivel de conexión (`pg_hba.conf`) y nivel de base de datos (Roles).

## Verificación
Se comprobó que las conexiones no autorizadas o desde IPs ajenas son rechazadas. La aplicación ahora puede operar exitosamente con su usuario restringido. Se validó a través de `pg_stat_ssl` que la comunicación viaja cifrada.

## Checklist de hardening
Revisar el archivo `configuracion/cambios.md` para el detalle de la línea base y los controles de verificación implementados.

## Conclusiones
El hardening de bases de datos requiere un enfoque de "Defensa en Profundidad". No es suficiente con usar contraseñas fuertes ni con cambiar de puerto; se debe proteger desde los permisos del sistema operativo y firewall, hasta la correcta gestión de autenticación, autorización de roles y encriptación de datos en tránsito dentro de PostgreSQL.

