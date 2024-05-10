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
   sudo systemctl enable nginx
   ```

 `systemctl` es una herramienta de administración de servicios en sistemas Linux. Permite interactuar con el sistema de inicio, controlar servicios (como iniciar, detener, reiniciar, habilitar o deshabilitar), ver el estado de los servicios y más
