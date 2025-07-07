# Configuración de NGINX como Proxy Inverso.

## ¿Por qué utilizar el puerto 8080 y no utilizar directamente el puerto 80 en mi aplicación de Spring Boot?

En Spring Boot, el puerto por defecto para escuchar solicitudes HTTP es el 8080. Sin embargo, no es posible configurar directamente el puerto 80 en la propiedad `server.port`, del archivo `application.properties`, debido a restricciones de seguridad y permisos.

Aquí tienes algunas razones por las que no se recomienda usar el puerto 80 directamente:

- Privilegios de Puerto: En sistemas operativos tipo Unix/Linux, los puertos por debajo del 1024 (como el puerto 80 para HTTP) requieren privilegios de superusuario (root) para ser utilizados. Ejecutar tu aplicación como root es una mala práctica de seguridad.

- Conflictos con Servicios Existentes: El puerto 80 podría estar ocupado por otros servicios web en la misma máquina, lo que causaría conflictos al iniciar tu aplicación.

- Recomendaciones de Seguridad: Se sugiere utilizar un puerto no privilegiado (mayor a 1024) para las aplicaciones y usar un servidor web dedicado como NGINX para gestionar el acceso público.

## ¿Qué es un Proxy Inverso?

Un proxy inverso es un servidor que actúa como intermediario entre los clientes (navegadores, aplicaciones móviles, etc.) y los servidores de aplicaciones.

NGINX se utiliza comúnmente como un proxy inverso debido a su eficiencia y flexibilidad.

Ventajas de Usar un Proxy Inverso con NGINX:

- Seguridad: Oculta la infraestructura de tu backend, protegiendo los servidores de aplicaciones de ataques directos.

- Balanceo de Carga: Puede distribuir el tráfico entre varias instancias de tu aplicación para mejorar la escalabilidad y disponibilidad.

- Caché: Almacena en caché contenido estático y dinámico para reducir la carga en los servidores de aplicación y acelerar las respuestas.

- Terminación SSL/TLS: NGINX puede manejar el cifrado y descifrado HTTPS, liberando a tu aplicación de esta tarea intensiva en CPU.

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
sudo dnf install nginx -y
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

La práctica moderna, y la configuración por defecto en la mayoría de las distribuciones actuales, es utilizar el directorio `/etc/nginx/conf.d/`. Todos los archivos que terminen en `.conf` dentro de este directorio son cargados automáticamente por NGINX. Este método es más simple y limpio que el antiguo sistema de `sites-available` y `sites-enabled`, ya que no requiere la creación de directorios adicionales ni enlaces simbólicos.

### Paso 1: Crear el archivo de configuración para la aplicación

Crea un nuevo archivo de configuración directamente en el directorio conf.d. Dale un nombre descriptivo, por ejemplo `my-ecommerce-demo.conf`.

```bash
sudo nano /etc/nginx/conf.d/my-ecommerce-demo.conf
```

### Paso 2: Agregar la configuración del proxy inverso

Pega la siguiente configuración en el archivo que acabas de crear. Este bloque le dice a NGINX que escuche en el puerto 80 y redirija todo el tráfico a tu aplicación Spring Boot que se ejecuta en el puerto 8080.

```bash
   # This configuration effectively sets up a reverse proxy 
   # server on port 80 that forwards incoming requests to a 
   # backend server running on localhost:8080

   server {
         listen       80;
         listen       [::]:80;
         server_name  localhost;

      location / {
         # Pasa todas las solicitudes a la API de Spring Boot que se ejecuta en el puerto 8080
         proxy_pass http://localhost:8080;
         # Headers importantes para que la aplicación backend conozca la solicitud original
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header X-Forwarded-Proto $scheme;
      }
   }
```

Guarda el archivo y sal del editor (`Ctrl+X`, luego `Y`, y `Enter`).

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


### Paso 3: Prueba de sintaxis en el archivo de configuración de NGINX

El comando `sudo nginx -t` se utiliza para probar el archivo de configuración de NGINX en busca de errores de sintaxis sin aplicar realmente los cambios de configuración a la instancia de NGINX en ejecución.

   ```bash
   sudo nginx -t
   ```

Si todo está correcto, deberías ver un mensaje como:

`nginx: the configuration file /etc/nginx/nginx.conf syntax is ok`

`nginx: configuration file /etc/nginx/nginx.conf test is successful`

Si hay errores de sintaxis, NGINX proporcionará un mensaje de error detallado que indicará el problema y el número de línea donde se produjo el error.

### Paso 7: Reiniciar el servicio de NGINX

Para aplicar los cambios, es necesario reiniciar el servicio de NGINX. Utiliza el siguiente comando:

```bash
sudo systemctl restart nginx
```

### Paso 8: Realiza una petición HTTP en el puerto 80

Antes de realizar la prueba, asegúrate de que tu backend se esté ejecutando en el puerto 8080, como se configuró anteriormente.

- Desde la misma instancia EC2

```bash
curl localhost/api/v1/users
```

Si el puerto 80 está permitido como entrada en la instancia EC2, puedes realizar una petición desde Postman o desde la línea de comandos local utilizando la dirección IP pública de tu instancia:
   
 - Desde tu máquina local
  
```bash
curl http://your_instance_public_ip/api/v1/users
```

Recuerda reemplazar your_instance_public_ip con la dirección IP pública de tu instancia EC2.

Si todo funciona, ¡has configurado exitosamente NGINX como un proxy inverso!