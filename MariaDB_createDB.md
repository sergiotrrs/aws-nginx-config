# Creación de una Base de Datos en MariaDB.

En esta guía, aprenderás cómo crear una base de datos en MariaDB instalada en una instancia EC2 con Amazon Linux. La base de datos estará diseñada para una aplicación de comercio electrónico.

## Pasos para Crear la Base de Datos.

### Paso 1: Acceda a los servicios de MariaDB.

Accede  a la consola de MariaDB utilizando el siguiente comando:

   ```bash
    mysql -u root -p
   ```

El usuario root puede ser cambiado por otro usuario configurado previamente.

### Paso 2: Crea la Base de Datos.

Ejecuta el siguiente comando SQL para crear la base de datos.

   ```sql
    CREATE DATABASE ecommerce;
   ```

### Paso 3: Crea Usuarios.

#### a. Usuario con Todos los Privilegios.
Crea un usuario con todos los privilegios en la base de datos de comercio electrónico. Reemplaza 'username' y 'password'  con tu nombre de usuario y contraseña deseados:

   ```sql
    CREATE USER 'username'@'%' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON ecommerce.* TO 'username'@'%';
    FLUSH PRIVILEGES;
   ```

#### b. Usuario de Solo Lectura.
Crea un usuario con privilegios de solo lectura en la base de datos de comercio electrónico. Reemplaza 'readonly_username' y 'readonly_password' con tu nombre de usuario y contraseña deseados:

   ```sql
    CREATE USER 'readonly_username'@'localhost' IDENTIFIED BY 'readonly_password';
    GRANT SELECT ON ecommerce.* TO 'readonly_username'@'localhost';
    FLUSH PRIVILEGES;
   ```

### Paso 4: Verifica la Base de Datos y los Usuarios.

Puedes verificar que la base de datos y los usuarios se hayan creado correctamente listando las bases de datos y los usuarios.

   ```sql
    SHOW DATABASES;
    SELECT user FROM mysql.user;
   ```

### 5. Verifica los Permisos del Usuario

Puedes verificar los permisos de un usuario específico ejecutando la siguiente consulta SQL.

   ```sql
   SHOW GRANTS FOR 'username'@'%';
   ```

### Paso 6: Sal de MariaDB.
Sal de la interfaz de línea de comandos de MariaDB.

   ```sql
    EXIT;
   ```
