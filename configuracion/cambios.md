# Cambios y Checklist de Hardening

## Comparativa: Configuración antes y después (Actividad 16)

| Control | Antes | Después | Justificación |
| :--- | :--- | :--- | :--- |
| **listen_addresses** | `'*'` (Todas) | `'10.10.10.20, localhost'` | Limitar escucha a interfaces estrictamente necesarias reduce la superficie de exposición ante ataques masivos. |
| **pg_hba.conf** | `0.0.0.0/0` (Global) | Rangos limitados (ej. `10.10.10.0/24`) | Restricción lateral y evitación de ataques desde redes fuera del alcance autorizado. |
| **Método de autenticación** | `md5` o `trust` | `scram-sha-256` | Reemplazo de métodos heredados o sin seguridad por algoritmos de hash más resistentes criptográficamente. |
| **Usuarios administrativos** | Expuestos a la red | Limitados por host en hba | Minimizar el riesgo de que la cuenta de máxima criticidad sea interceptada o sufra fuerza bruta. |
| **Cuentas de aplicación** | `SUPERUSER` heredado | Rol propio con privilegios limitados | Mínimo privilegio para garantizar que una app vulnerada no escale al control del servidor. |
| **Puerto** | 5432 libre a Internet | 5432 filtrado por reglas SO | Defensa en profundidad: el sistema no depende solo de la capa base de datos. |
| **TLS** | Deshabilitado | Habilitado (>= TLSv1.2) | Cifrado en tránsito, bloquea visualización en texto claro de consultas y extracción pasiva de datos (sniffing). |
| **Permisos SO** | Permisivos (755/644) | Estrictos (700 para Data, 600 config) | Aislamiento físico-lógico contra otros procesos o usuarios del mismo servidor. |
| **Extensiones** | Librerías de prueba sueltas | Auditoría finalizada, librerías restringidas | Disminución de componentes ejecutables internos innecesarios que pudieran ser explotados. |

---

## Checklist de Hardening (Actividad 17)

| # | Control | Verificado | Evidencia |
| :--- | :--- | :--- | :--- |
| 1 | Puerto documentado | Sí | Se consultó `SHOW port;` |
| 2 | Interfaces de escucha justificadas | Sí | `SHOW listen_addresses;` modificado |
| 3 | pg_hba.conf revisado | Sí | Expresiones amplias (`::/0`, `0.0.0.0/0`) retiradas |
| 4 | Redes autorizadas restringidas | Sí | Reglas IP configuradas conceptualmente |
| 5 | Autenticación segura | Sí | `SHOW password_encryption;` retorna scram |
| 6 | Superusuarios identificados | Sí | Sentencia `SELECT rolname ... FROM pg_roles;` |
| 7 | Cuentas de aplicación separadas | Sí | Mapeo DBA, APP, CONSULTA creado |
| 8 | Privilegios mínimos | Sí | Quitado SUPERUSER, LOGIN innecesario a roles grupales |
| 9 | Extensiones revisadas | Sí | `SELECT extname ... FROM pg_extension;` |
| 10| TLS verificado | Sí | Confirmado en `pg_stat_ssl` con TLS 1.2+ |
| 11| Configuración protegida | Sí | Verificado propietario/grupo del `postgresql.conf` |
| 12| Directorio de datos protegido | Sí | Confirmados permisos de lectura/escritura (`700`) |
| 13| Firewall documentado | Sí | Tabla conceptual de denegación por defecto (Act. 14) |
| 14| Actualizaciones documentadas | Sí | Agregado requerimiento en la Línea Base |
| 15| Configuración registrada | Sí | `baseline.md` y `cambios.md` construidos con éxito |
