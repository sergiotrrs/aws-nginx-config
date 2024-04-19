# Instalación de MariaDB en AWS Linux 2023

## ¿Qué es MariaDB?

MariaDB es un sistema de gestión de bases de datos relacional (RDBMS) de código abierto que es una bifurcación de MySQL. Ofrece características avanzadas, alto rendimiento y es compatible con la mayoría de las aplicaciones MySQL. MariaDB es utilizado por empresas de todo el mundo para gestionar sus datos de manera eficiente y segura.

## Pasos para instalar MariaDB en AWS Linux 2023

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

### Paso 3: Instalar MariaDB Server

Para instalar MariaDB Server en AWS Linux, utilice el siguiente comando:

   ```bash
   sudo dnf install mariadb105-server
   ```

### Paso 4: Iniciar el servicio MariaDB

Inicie el servicio de MariaDB y habilítelo para que se inicie automáticamente en el arranque del sistema.

   ```bash
   sudo systemctl start mariadb
   sudo systemctl enable mariadb
   ```

 `systemctl` es una herramienta de administración de servicios en sistemas Linux. Permite interactuar con el sistema de inicio, controlar servicios (como iniciar, detener, reiniciar, habilitar o deshabilitar), ver el estado de los servicios y más

### Paso 5: Verificar el servicio MariaDB

Una vez que la inicialización haya finalizado, puede verificar el estado del servicio de MariaDB.

   ```bash
    sudo systemctl status mariadb
   ```

### Paso 6: Configurar MariaDB

Para mejorar la seguridad de su instalación de MariaDB, ejecute el script de seguridad incluido.

   ```bash
    sudo mysql_secure_installation
   ```

### Paso 7: Acceda a los servicios de MariaDB

Una vez configurado, puede acceder a la consola de MariaDB utilizando el siguiente comando:

   ```bash
    mysql -u root -p
   ```
   
Se le pedirá que ingrese la contraseña que configuró anteriormente. Una vez dentro de la consola de MariaDB, puede comenzar a crear bases de datos, tablas y realizar consultas SQL.