# Configuración de NGINX como Proxy Inverso.

## ¿Por qué no utilizar directamente el puerto 80 en mi aplicación de Spring Boot?

En Spring Boot, el puerto por defecto para escuchar solicitudes HTTP es el 8080. Sin embargo, no es posible configurar directamente el puerto 80 en la propiedad server.port debido a restricciones de seguridad y permisos.

Aquí tienes algunas razones por las que no se recomienda usar el puerto 80 directamente:

- Privilegios de Puerto: El puerto 80 está reservado para servicios web estándar (HTTP). En sistemas operativos Unix/Linux, los puertos por debajo del 1024 requieren privilegios de superusuario para ser utilizados. Ejecutar una aplicación Spring Boot con privilegios de superusuario no es seguro y no se recomienda.

- Conflictos con Servicios Existentes: El puerto 80 podría estar ocupado por otros servicios web en la misma máquina. Si intentamos usarlo directamente, podríamos enfrentarnos a conflictos y errores al iniciar nuestra aplicación.

- Recomendaciones de Seguridad: Por razones de seguridad, se sugiere utilizar un puerto no privilegiado (por encima del 1024) para aplicaciones web. Esto ayuda a evitar posibles vulnerabilidades y ataques.

## ¿Qué es un Proxy Inverso?

Un proxy inverso es un servidor que actúa como intermediario entre los clientes (navegadores, aplicaciones móviles, etc.) y los servidores de aplicaciones.

NGINX se utiliza comúnmente como un proxy inverso debido a su eficiencia y flexibilidad.
Ventajas de Usar un Proxy Inverso con NGINX:

- Seguridad: El proxy inverso oculta los detalles de la infraestructura detrás de él, protegiendo los servidores de aplicaciones de ataques directos.

- Balanceo de Carga: NGINX puede distribuir las solicitudes entrantes entre varios servidores de aplicaciones, mejorando la escalabilidad.

- Caché: Puede almacenar en caché respuestas para reducir la carga en los servidores de aplicaciones.

- SSL/TLS: NGINX puede manejar la terminación SSL/TLS, liberando a los servidores de aplicaciones de esta tarea. Esto significa que NGINX se encarga de descifrar las solicitudes cifradas (HTTPS) enviadas por el cliente y luego reenvía las solicitudes sin cifrar al servidor de aplicaciones (que puede estar ejecutando Spring Boot).

## Instalar NGINX en AWS Linux 2023

### Paso 1: Conectarse a su instancia de AWS Linux.

Utilice su cliente SSH favorito para conectarse a su instancia de AWS Linux.

```bash
ssh -i your_key.pem ec2-user@your_instance_public_ip
```

Es necesario que tu archivo de clave `.pem` tenga permisos de solo lectura; de lo contrario, podrías encontrarte con el error "Permissions 0644 for your_key.pem are too open". Para resolver este problema, establece permisos de solo lectura para el archivo `.pem`.

```bash
chmod 400 your_key.pem
```
El comando `chmod` en sistemas operativos tipo Unix se utiliza para cambiar los permisos de un archivo o directorio. En este comando, 400 especifica que el propietario del archivo (your_key.pem) debe tener permisos de solo lectura, mientras que todos los demás usuarios no tienen ningún permiso.

### Paso 2: Actualizar el sistema.

Antes de instalar cualquier paquete nuevo, es una buena práctica actualizar los paquetes existentes en el sistema.

   ```bash
   sudo dnf update
   ```

### Paso 3: Instalar NGINX

Para instalar NGINX en AWS Linux, utilice el siguiente comando:

   ```bash
   sudo dnf install nginx
   ```

### Paso 4: Iniciar el servicio NGINX

Inicie el servicio de nginx y habilítelo para que se inicie automáticamente en el arranque del sistema.

   ```bash
   sudo systemctl start nginx   
   ```
   ```bash   
   sudo systemctl enable nginx
   ```

 `systemctl` es una herramienta de administración de servicios en sistemas Linux. Permite interactuar con el sistema de inicio, controlar servicios (como iniciar, detener, reiniciar, habilitar o deshabilitar), ver el estado de los servicios y más


## Configurar NGINX como proxy inverso

Para configurar un proxy inverso de NGINX, puedes hacerlo directamente en el archivo `nginx.conf` o puedes optar por la estructura más organizada de tener carpetas `sites-available` y `sites-enabled`. En la configuración directa en `nginx.conf`, generalmente buscarías la sección http y agregarías las directivas necesarias para configurar el proxy inverso. 

Por otro lado, al usar las carpetas `sites-available` y `sites-enabled`, puedes crear archivos de configuración separados para cada sitio o aplicación que necesite un proxy inverso, lo que puede ser más fácil de mantener en entornos con múltiples configuraciones. Una vez que hayas configurado los archivos de configuración en sites-available, puedes habilitarlos creando enlaces simbólicos desde sites-enabled. Esto permite una gestión más modular y organizada de las configuraciones de proxy inverso en NGINX.

### Paso 1: Crear carpetas `site-enabled` y `site-available`

- sites-available: Este directorio se utiliza para almacenar archivos de configuración de sitios web disponibles. Estos archivos pueden contener la configuración de diferentes sitios web que podrían ser servidos por NGINX, pero no están activos actualmente.

- sites-enabled: En este directorio se colocan enlaces simbólicos (también conocidos como "symlinks") a los archivos de configuración de los sitios web que están activos y se están sirviendo actualmente. NGINX lee la configuración de los sitios web desde estos archivos en lugar de los archivos ubicados directamente en sites-available.

   ```bash
   sudo mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled
   ```

### Paso 2: Crear el archivo de configuración para el proxy inverso.

   ```bash
   sudo touch /etc/nginx/sites-available/reverse_proxy
   ```

### Paso 3: Edita el archivo de configuración `reverse_proxy`.

El siguiente comando te ayudará a iniciar la configuración del archivo `reverse_proxy`. Recuerda escribir correctamente el nombre del archivo creado anteriormente.

   ```bash
   sudo tee -a /etc/nginx/sites-available/reverse-proxy <<EOF
   # This configuration effectively sets up a reverse proxy 
   # server on port 80 that forwards incoming requests to a 
   # backend server running on localhost:8080

   server {
         listen       80;
         listen       [::]:80;
         server_name  localhost;

      location / {
         proxy_pass http://localhost:8080;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header X-Forwarded-Proto $scheme;
      }
   }
   EOF
   ```
Esta configuración establece un bloque de servidor para un proxy inverso en NGINX. Aquí hay un desglose de lo que hace cada sección:

- listen 80;: Configura NGINX para escuchar en el puerto 80 para conexiones HTTP entrantes.
- listen [::]:80;: Similar al anterior, pero para conexiones IPv6.
- server_name localhost;: Define el nombre del servidor al que se aplica este bloque de configuración. En este caso, se establece en 'localhost', lo que significa que este bloque de configuración manejará las solicitudes que lleguen al servidor con el nombre de host 'localhost'.

Dentro del bloque location / { }:

- proxy_pass http://localhost:8080;: Especifica que las solicitudes entrantes a esta ubicación deben ser reenviadas al servidor backend que se ejecuta en localhost en el puerto 8080.
- proxy_set_header Host $host;: Establece el encabezado Host de la solicitud enmascarada al valor del encabezado 'Host' de la solicitud original.
- proxy_set_header X-Real-IP $remote_addr;: Establece el encabezado X-Real-IP de la solicitud enmascarada a la dirección IP del cliente.
- proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;: Agrega la dirección IP del cliente al encabezado X-Forwarded-For de la solicitud enmascarada.
- proxy_set_header X-Forwarded-Proto $scheme;: Establece el encabezado X-Forwarded-Proto de la solicitud enmascarada a 'http' o 'https' según el protocolo de la solicitud original.

### Paso 4: Crear el enlace simbólico entre `site-enabled` y `site-available`

El enlace simbólico creado por esta línea de comando permitirá que NGINX utilice el archivo de configuración reverse-proxy ubicado en sites-available, haciéndolo efectivo al incluirlo en el directorio sites-enabled. Esto facilita la gestión de múltiples configuraciones de sitios web, ya que puedes habilitar o deshabilitar fácilmente diferentes configuraciones simplemente creando o eliminando enlaces simbólicos en el directorio sites-enabled.

   ```bash
   sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
   ```

### Paso 5: Incluir el archivo de configuración de `sites-enabled` en `nginx.conf`

- include: Es una directiva de NGINX que se utiliza para incluir archivos de configuración adicionales dentro del archivo principal de configuración (nginx.conf). Esto permite modularizar y organizar la configuración de NGINX en múltiples archivos.

Agrega la siguiente línea `include /etc/nginx/sites-enabled/*;` en el archivo `nginx.conf` después de `include /etc/nginx/conf.d/*.conf;`.

   ```bash
   sudo nano /etc/nginx/nginx.conf
   ```

   ```script
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
    # Load all configurations of enabled websites
    include /etc/nginx/sites-enabled/*;

   ```

### Paso 6: Prueba de sintaxis en el archivo de configuración de NGINX

El comando `sudo nginx -t` se utiliza para probar el archivo de configuración de NGINX en busca de errores de sintaxis sin aplicar realmente los cambios de configuración a la instancia de NGINX en ejecución.

   ```bash
   sudo nginx -t
   ```

Si la configuración es válida, NGINX mostrará "nginx.conf syntax is ok" e indicará qué archivo(s) de configuración se han probado. Si hay errores de sintaxis, NGINX proporcionará un mensaje de error detallado que indicará el problema y el número de línea donde se produjo el error.

### Paso 7: Reiniciar el servicio de NGINX

Para aplicar los cambios, es necesario reiniciar el servicio de NGINX. Utiliza el siguiente comando:

   ```bash
   sudo systemctl restart nginx
   ```

### Paso 8: Realiza una petición HTTP en el puerto 80

Antes de realizar la prueba, asegúrate de que tu backend se esté ejecutando en el puerto 8080, como se configuró anteriormente.

   ```bash
   curl localhost/api/v1/users
   ```

Si el puerto 80 está permitido como entrada en la instancia EC2, puedes realizar una petición desde Postman o desde la línea de comandos local utilizando la dirección IP pública de tu instancia:
   
   ```bash
   curl your_instance_public_ip/api/v1/users
   ```

Recuerda reemplazar your_instance_public_ip con la dirección IP pública de tu instancia EC2.