# Configuración para la ejecución de una Aplicación Spring Boot en AWS EC2.

## ¿Qué es Spring Boot?

Spring Boot es framework de código abierto para crear aplicaciones Java de manera rápida y con un mínimo de configuración. Está construido sobre el proyecto Spring Framework y proporciona un conjunto de herramientas y convenciones que simplifican el desarrollo de aplicaciones empresariales.

## ¿Qué es una Api Rest?

Una API REST (Representational State Transfer) es una arquitectura para el diseño de sistemas distribuidos basados en la web. En una API REST, los recursos (como datos o funcionalidades) se representan como URI (Identificadores de Recursos Uniformes) y se pueden acceder a través de operaciones estándar HTTP (GET, POST, PUT, DELETE, etc.).

Una API REST permite a los desarrolladores crear aplicaciones que pueden comunicarse entre sí a través de Internet de manera flexible y ligera. Facilita la integración y el intercambio de datos entre diferentes sistemas y aplicaciones, lo que resulta en una mayor eficiencia y escalabilidad.

## Pasos para instalar OpenJDK y Git en AWS Linux 2023

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

### Paso 3: Instalar OpenJDK.

Amazon Corretto es una distribución sin costo, multiplataforma y lista para producción de Open Java Development Kit (OpenJDK). Corretto cuenta con soporte a largo plazo que incluirá mejoras de rendimiento y correcciones de seguridad:

   ```bash
    sudo dnf install java-17
   ```

### Paso 4: Instalar Git y clonar un repositorio.

Aunque Git y GitHub son herramientas independientes, se complementan entre sí para facilitar la colaboración y el desarrollo de software en equipo. Además, aunque no es necesario, Git y GitHub pueden utilizarse en conjunción con instancias EC2 de Amazon para transferir archivos y desplegar aplicaciones en la nube de AWS de manera eficiente.

   ```bash
    sudo dnf install git
   ```
Si no cuentas con un repositorio, puede clonar el siguiente proyecto de Spring Boot `aws-ec2-demo`.

   ```bash
    git clone https://github.com/sergiotrrs/aws-ec2-demo.git    
   ```
El proyecto `aws-ec2-demo`cuenta con dos perfiles, en el perfil por default usa una base de datos en memoria H2, en el perfil `dev` realiza la conexión con una base de datos en MySQL.

## Ejecuta una aplicación de Spring Boot con una base de datos en memoria. 

### Paso 1: Ejecuta una aplicación usando Gradle o Maven.

Prueba la aplicación en la instancias EC2, para ello dirígete a la raíz del proyecto clonado y verifica los permisos del archivo gradlew o mvnw.

   ```bash
    ls -l gradlew
   ```
El archivo gradlew(o mvnw) deben tener permisos de ejecucíón, de no ser así, cambia los permisos para poder ejecutar el script.

   ```bash
   chmod +x gradlew
   ```

Ejecuta tu aplicación. En caso de que uses Maven ejecuta `./mvnw spring-boot:run`.

   ```bash
   ./gradlew bootRun
   
   ```

Para detener la aplicación pulsa las teclas `ctrl + c`. Deten la apliación hasta que hayas terminado con las pruebas que se describe en el siguiente paso.

### Paso 2: Realiza pruebas en los endpoints de tu aplicación

Si has clonado el proyecto anteriormente, puedes realizar el registro de un usuario utilizando el comando cURL. Dado que la terminal SSH está ocupada ejecutando la aplicación Spring Boot, necesitarás abrir otra conexión SSH como se indicó en el [Paso 1: Conectar a tu instancia de AWS Linux](#paso-1-conectar-a-tu-instancia-de-aws-linux). Una vez que hayas abierto otra conexión SSH, ejecuta los siguientes comandos:

   ```bash
    curl -d '{"email":"winnie@disney.com","password":"honeyhoney","firstName":"winnie", "lastName":"pooh"}' -H "Content-Type:application/json" localhost:8080/api/v1/users
   ```
   ```bash
    curl localhost:8080/api/v1/users
   ```

## Ejecuta una aplicación de Spring Boot con una base de datos en MySQL o MariaDB

### Paso 1: Verificar la existencia de la base de datos en MySQL o MariaDB

Antes de ejecutar la aplicación de Spring Boot, es importante asegurarse de que la base de datos necesaria esté disponible. Si no tienes una base de datos existente, puedes crear una nueva siguiendo las instrucciones proporcionadas en los tutoriales [MariaDB_installation_guide.md](MariaDB_installation_guide.md) y [MariaDB_createDB.md](MariaDB_createDB.md).

Para la aplicación `aws-ec2-demo`, asegúrate de crear una base de datos con las siguientes credenciales:

- **Host name**: localhost
- **Port**: 3306
- **Database**: `my_ecommerce`
- **User name**: mickey_mouse
- **Password**: d1sn3y

### Paso 2: Ejecuta una aplicación usando Gradle o Maven

Para probar la aplicación en las instancias EC2, dirígete a la raíz del proyecto clonado y verifica los permisos del archivo `gradlew` o `mvnw`.

   ```bash
    ls -l gradlew
   ```

El archivo `gradlew` (o `mvnw`) debe tener permisos de ejecución. Si no es así, cambia los permisos para poder ejecutar el script.

   ```bash
   chmod +x gradlew
   ```

Ejecuta tu aplicación indicando las credenciales adecuadas de tu base de datos. En caso de que uses variables de entorno en tu archivo `application.propertier` ejecuta el comando:

-  ./gradlew bootRun -Dspring.profiles.active=prod -Dserver.port=8080 -DMYSQLHOST=host_here -DMYSQLDATABASE=db_here -DMYSQLPORT=port_here -DMYSQLUSER=root/user_here -DMYSQLPASSWORD=pass_here

   ```bash
   ./gradlew bootRun -Dspring.profiles.active=prod -Dserver.port=8080 -DMYSQLHOST=localhost -DMYSQLDATABASE=my_ecommerce -DMYSQLPORT=3306 -DMYSQLUSER=mickey_mouse -DMYSQLPASSWORD=d1sn3y   
   ```
Para detener la aplicación presionando las teclas `ctrl + c`. Deten la apliación hasta que hayas terminado con las pruebas que se describe en el siguiente paso.

### Paso 3: Realiza pruebas a los endpoints de tu aplicación.

Si has clonado el proyecto anteriormente, puedes registrar un nuevo usuario utilizando el comando cURL. Dado que la terminal SSH está ocupada ejecutando la aplicación Spring Boot, necesitarás abrir otra conexión SSH como se indicó en el [Paso 1: Conectar a tu instancia de AWS Linux](#paso-1-conectar-a-tu-instancia-de-aws-linux). 

- Dado que la conexión se realizará a una base de datos persistente, después de hacer una solicitud POST puedes detener tu aplicación y verificar que los datos agregados seguirán registrados.

Una vez que hayas abierto otra conexión SSH, ejecuta los siguientes comandos:

   ```bash
    curl -d '{"email":"winnie@disney.com","password":"honeyhoney","firstName":"winnie", "lastName":"pooh"}' -H "Content-Type:application/json" localhost:8080/api/v1/users
   ```

   ```bash
    curl localhost:8080/api/v1/users
   ```

Una vez finalizado las pruebas deten tu aplicación presionando las teclas `ctrl + c`.

## Genera el empaquetado de tu aplicación (.jar).

Un archivo .jar es un archivo Java que se utiliza para empaquetar y distribuir aplicaciones Java. "JAR" significa "Java ARchive". Cuando ejecutas un archivo .jar de una aplicación Spring Boot, automáticamente se inicia un servidor embebido que ejecuta tu aplicación. Esto significa que no necesitas preocuparte por configurar un servidor web por separado; Spring Boot se encarga de todo por ti.
 
### Paso 1: Genera el empaquetado(.jar) de tu aplicación.

Para generar el empaquetado (.jar) de tu aplicación, ejecuta el siguiente comando desde la raíz de tu aplicación. Si estás utilizando Maven, ejecuta `./mvnw clean package`.


   ```bash
   ./gradlew build   
   ```

## Paso 2: Ejecuta el archivo empaquetado de tu aplicación.

Para ejecutar el archivo empaquetado de tu aplicación, utiliza el siguiente comando desde la raíz de tu aplicación. Si estás utilizando variables de entorno, indícalo como se muestra a continuación:
 
   ```bash
   java -jar -Dspring.profiles.active=prod -Dserver.port=8080 -DMYSQLHOST=localhost -DMYSQLDATABASE=my_ecommerce -DMYSQLPORT=3306 -DMYSQLUSER=mickey_mouse -DMYSQLPASSWORD=d1sn3y build/libs/aws-ec2-demo-1.0.0.jar
   ```

Si usas Maven cambia la ruta del empaquetado a `/target/my-ecommerce-demo-1.0.0.jar`. Puedes probar el funcionamiento de tu aplicación haciendo una consulta HTTP desde otra ventana de comandos conectada a tu instancia EC2.

   ```bash
    curl localhost:8080/api/v1/users
   ```

Deten la ejecución de tu empaquetado presionando las teclas `ctrl + c`.

## Configurar y habilitar el servicio de tu aplicación en la instancia EC2.

Los siguientes pasos te permiten configurar y habilitar un servicio en un sistema Amazon Linux, lo que asegura que el servicio se inicie automáticamente al arrancar el sistema y que se ejecute según la configuración especificada en el archivo de servicio.

### Paso 1: Crear el archivo de servicio.

Primero, necesitas crear un archivo de servicio en el directorio /etc/systemd/system/ con la extensión .service.

   ```bash
   sudo touch /etc/systemd/system/springboot-app.service
   ```

### Paso 2: Edita el archivo de servicios.

Utiliza un editor de texto para editar este archivo y definir cómo systemd debería manejar tu servicio. Por ejemplo, podrías especificar el comando que systemd debería ejecutar para iniciar tu servicio y otras opciones de configuración relevantes.

   ```bash
   sudo nano /etc/systemd/system/springboot-app.service
   ```
Escribe a continuación la siguiente configuración en el archivo `springboot-app.service`. 

   ```script
   # Gestionar y controlar la ejecución de una aplicación 
   # Spring Boot en un entorno Linux.
   #
   # Si no lo requiere puede omitir profile.active, server.port 
   # y las variables de entorno.
   #
   # Cambia /home/ec2-user/app/app.jar por la ruta de tu archivo .jar
   # Ubicación del archivo /etc/systemd/system/springboot-app.service
   #
   #

   [Unit]
   Description=Spring Boot App
   After=syslog.target

   [Service]
   User=ec2-user
   ExecStart=java -jar -Dspring.profiles.active=prod -Dserver.port=8080 /home/ec2-user/aws-ec2-demo/build/libs/aws-ec2-demo-1.0.0.jar
   Environment="MYSQLHOST=localhost"
   Environment="MYSQLPORT=3306"
   Environment="MYSQLDATABASE=my_ecommerce"
   Environment="MYSQLUSER=mickey_mouse"
   Environment="MYSQLPASSWORD=d1sn3y"
   SuccessExitStatus=143

   [Install]
   WantedBy=multi-user.target
   ```

Una vez terminado guarda los cambios(`ctrl + s`) y sal del editor(`ctrl + x`).

### Paso 3: Habilitar e iniciar el servicio.

Después de haber definido tu archivo de servicio, puedes habilitarlo para que se inicie automáticamente al arrancar el sistema utilizando el comando systemctl enable.

   ```bash
   sudo systemctl enable springboot-app.service
   ```

Puedes iniciar el servicio inmediatamente después de haberlo habilitado utilizando el comando systemctl start. Esto iniciará tu servicio sin necesidad de reiniciar el sistema.

   ```bash
   sudo systemctl start springboot-app.service
   ```

Puedes ver el estado actual del servicio utilizando el comando systemctl status.

   ```bash
   sudo systemctl status springboot-app.service
   ```

Para ver los registros (logs) del sistema relacionados con un servicio específico.

   ```bash
   sudo journalctl -u springboot-app.service -xe
   ```

Para ver los registros (logs) del sistema relacionados con un servicio específico en tiempo real.

   ```bash
   sudo journalctl -u springboot-app.service -f
   ```

`-f` o `--follow`: sigue el flujo de registros en tiempo real. Esto significa que verás los registros más recientes y se actualizará automáticamente a medida que se agreguen nuevos registros al archivo de registro.

### Paso 4: Probar el servicio en ejecución.

Antes de probar el servicio en ejecución, asegúrate de que la instancia EC2 tenga los permisos adecuados configurados para permitir el tráfico de entrada en el puerto indicado.

Para probar el servicio, puedes utilizar el comando `curl` desde tu máquina local para enviar una solicitud HTTP a la instancia EC2 y recibir la respuesta. Aquí tienes un ejemplo de cómo hacerlo:

   ```bash
   curl ec2_public_ip:8080/api/v1/users
   ```
Si el puerto 8080 está abierto en la instancia EC2, puedes realizar las solicitudes desde Postman o desde tu aplicación web utilizando la API Fetch.

Recuerda reemplazar ec2_public_ip con la dirección IP pública de tu instancia EC2.

### Paso 5: Reiniciar una instancia EC2.

En caso de que necesite reiniciar una instancia EC2 ejecute.

   ```bash
   sudo reboot now
   ```
