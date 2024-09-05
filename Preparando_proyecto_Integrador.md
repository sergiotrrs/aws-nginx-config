# Preparando nuestro Proyecto Integrador.

El proyecto integrador se encuentra desarrollado de la siguiente manera:
- **Frontend**: HTML, CSS, JavaScript y Bootstrap.
- **Backend**: Spring boot con Java,
- **Base de datos**: MySQL.

## Acoplando frontend con backend

El primer paso que debemos realizar para que nuestro proyecto pueda vivir de manera remota es realizar el acoplamiento de la carpeta donde se desarrolló el frontend con la carpeta donde se desarrolló el backend.

> Es necesario recordarte que el punto de acceso de nuestro frontend es el archivo `index.html` el cual se debe encontrar en el nivel principal.

Para realizar el acoplamiento, copiaremos la carpeta del frontend dentro de la carpeta del backend, en la ruta `src/main/resources/static`

Puedes consultar el siguiente repositorio para observar la nueva estructura del proyecto
[Repositorio de ejemplo](https://github.com/sergiotrrs/aws-ec2-demo.git)

## Configurando mi URL remota

Solicita la `IP pública` proporcionada por la instancia de AWS a la persona encargada, ya que esta será la dirección que reemplazarás en el frontend y te permitirá vincular con el servidor remoto que configuraremos más adelante.

Hasta este momento hemos desarrollado nuestra API y realizado pruebas HTTP de manera local, pero necesitamos conectarnos a una IP remota para realizar pruebas de manera remota. Por ello, localiza todas las url de tu proyecto que apunten a `localhost:8080` y sustitúyela por la `IP pública` proporcionada.

*Revisa cada archivo de tu código para asegurarte que se realicen los cambios correctos.*

## Propiedades para Producción (Variables de entorno)

Por seguridad, es necesario ocultar las propiedades del proyecto como variables de entorno, ya que de esta manera no exponemos información sensible a nivel producción. Para ello, realizamos lo siguiente:

1. Crear un nuevo archivo llamado `application-prod.properties` en la ruta `src/main/resources` 
- Este servirá exclusivamente para configuración de producción.
- No es necesario modificar `application.properties` o `application.yml`.

2. Dentro del archivo `application-prod.properties` copiar lo siguiente:
```properties

spring.jpa.hibernate.ddl-auto=update

spring.datasource.url=jdbc:mysql://${MYSQLHOST}:${MYSQLPORT}/${MYSQLDATABASE}
spring.datasource.username=${MYSQLUSER}
spring.datasource.password=${MYSQLPASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```
3. En la carpeta del proyecto abrir el archivo `.gitignore` y realizar comentarios sobre las siguientes líneas:
```properties
# build
# !**/src/main/**/build/
```

## ¿Qué es Gradle y para qué sirve en Spring Boot?

Gradle es una herramienta de automatización de compilación que se utiliza para gestionar y construir proyectos de software. En un proyecto de Spring Boot, Gradle permite gestionar las dependencias, compilar el código, ejecutar pruebas, crear archivos ejecutables (.jar o .war) y desplegar la aplicación de manera eficiente.

## Construyendo el proyecto con Gradle

Necesitamos ejecutar varias tareas en nuestro proyecto, tales como configurar, descargar dependencias, compilar clases Java, ejecutar pruebas y crear archivos `jar`. Para ello haremos uso de las tareas de gradle.

Generar el jar con doble click en: 
Gradle Task-> ecommerce -> build -> build
