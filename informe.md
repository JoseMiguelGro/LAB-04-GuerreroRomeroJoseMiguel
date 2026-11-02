# Informe de Laboratorio - LAB-04

1. **¿Cuál era la principal superficie de ataque?**
La principal superficie abarcaba el puerto 5432 expuesto públicamente a través de `listen_addresses = '*'` combinado con un firewall permisivo, cuentas administrativas utilizadas por aplicaciones y un archivo `pg_hba.conf` con rangos de acceso demasiado amplios.

2. **¿Qué configuración representaba el mayor riesgo?**
La presencia de reglas tipo `host all all 0.0.0.0/0` en `pg_hba.conf` utilizando métodos de autenticación débiles (como md5 o trust), ya que abría la base de datos a ataques externos masivos.

3. **¿Qué cambio produjo la mayor reducción de exposición?**
Restringir `listen_addresses` a redes específicas o locales y depurar `pg_hba.conf` para especificar exactamente qué IP, usuario y base de datos pueden comunicarse.

4. **¿Qué diferencia existe entre firewall y pg_hba.conf?**
El **firewall** opera a nivel de red y puerto (Capa 3 y 4 del modelo OSI), permitiendo o bloqueando conexiones TCP/IP antes de que lleguen a la BD. **pg_hba.conf** actúa a nivel de la aplicación (PostgreSQL), filtrando conexiones basándose en usuario, base de datos de destino y determinando el mecanismo de autenticación requerido.

5. **¿Qué diferencia existe entre autenticación y autorización?**
**Autenticación** es demostrar quién eres (ej. introduciendo un usuario y un hash de contraseña). **Autorización** es lo que el sistema te permite hacer una vez dentro (ej. hacer un SELECT, o no tener permisos de hacer un DROP).

6. **¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**
Si la aplicación sufre una vulnerabilidad (como inyección SQL), el atacante heredará los permisos del usuario con el que se conectó. Si es SUPERUSER, el atacante obtiene control total de la base de datos y, en muchos casos, del sistema operativo subyacente.

7. **¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**
Cambiar de puerto es "seguridad por oscuridad". Herramientas de escaneo de red (como Nmap) encontrarán el servicio en el nuevo puerto rápidamente. No sustituye controles reales como contraseñas, cortafuegos o permisos restrictivos.

8. **¿Por qué listen_addresses='*' puede ser innecesario?**
Porque en la mayoría de las arquitecturas (especialmente web), la base de datos y la aplicación operan en una red privada (VLAN interna) o en el mismo equipo. Exponerlo a todas las interfaces incluye la red pública de internet, lo cual atrae ruido y ataques automatizados.

9. **¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**
Es la base. Si un usuario no autorizado del sistema operativo tiene permisos para leer los archivos de configuración (`pg_hba.conf` o `postgresql.conf`) o el directorio de datos (`data`), puede robar hashes de contraseñas, llevarse los archivos físicos de la base de datos o inyectar reglas fraudulentas, ignorando cualquier control lógico de GRANT o REVOKE interno de SQL.

10. **¿Qué controles deberían revisarse periódicamente?**
La auditoría de roles inactivos, verificación de extensiones innecesarias, revisión de rangos IP en el `pg_hba.conf` y en las reglas de firewall, así como actualizaciones o parches de seguridad liberados para la versión del motor de bases de datos.

---

## Reflexión (Sección 31)

**¿Qué cambiarías primero si recibieras la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción?**

Lo primero a modificar sería la **exposición de red**, configurando adecuadamente el firewall perimetral y revisando los rangos de orígenes de IP en el archivo `pg_hba.conf`. 

El riesgo de un ataque externo es alto y su impacto puede ser catastrófico (exfiltración total de datos o Ransomware). Al cerrar el acceso público o no autorizado a nivel de red, reducimos la exposición en casi un 90% instantáneamente sin requerir recortes de privilegios internos que pudieran impactar la continuidad o disponibilidad de las aplicaciones de negocio en el corto plazo. Una vez que el entorno está aislado y protegido, se puede planificar con calma la auditoría y segmentación interna de roles, autenticación y contraseñas débiles, garantizando disponibilidad durante la transición técnica.
