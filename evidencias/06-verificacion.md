# Actividad 18 - Caso integral
| # | Problema | Riesgo | Control propuesto |
| :--- | :--- | :--- | :--- |
| 1 | Escucha en todas las interfaces (`*`) | Exposición global a escaneos y ataques | Cambiar `listen_addresses` a la IP privada |
| 2 | App usa cuenta con privilegios admin | Toma de control por Inyección SQL | Crear un rol limitado solo para la App (DML) |
| 3 | Firewall permite puerto 5432 global | Ataques de red externos | Limitar puerto 5432 solo a IPs autorizadas |
| 4 | `pg_hba` permite `all/all 0.0.0.0/0` | Cualquier IP puede intentar loguearse | Definir IPs, usuarios y BD específicas en pg_hba |
| 5 | "No hay problema porque contraseñas son fuertes" | Falsa sensación de seguridad (fuerza bruta, sniffing) | Implementar defensa multicapa, forzar `scram-sha-256` y TLS |

**¿Es suficiente tener contraseñas fuertes?**
No. La seguridad depende de múltiples capas (Defensa en Profundidad). Una contraseña fuerte no sirve si la conexión no usa TLS (interceptación), si el usuario tiene privilegios excesivos (escalamiento al vulnerar la app), o si los archivos en el servidor están expuestos (lectura directa desde el Sistema Operativo).