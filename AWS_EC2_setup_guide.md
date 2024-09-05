# Amazon Web Services (AWS).

**Amazon Web Services (AWS)** es una plataforma en la nube ofrecida por Amazon que proporciona una amplia gama de servicios en la nube (cloud computing), como almacenamiento, computación, bases de datos, redes, entre otros. AWS permite a las empresas y desarrolladores crear, desplegar y gestionar aplicaciones en la nube sin tener que preocuparse por la infraestructura física.

## Amazon EC2.

**Amazon EC2 (Elastic Compute Cloud)** es uno de los servicios más populares de AWS y permite ejecutar aplicaciones en servidores virtuales, conocidos como instancias, en la nube. EC2 proporciona capacidad de computación escalable, lo que significa que puedes ajustar el tamaño de tus recursos según la demanda, pagando solo por el uso que realmente necesitas.


## Instancias.

**Instancias de EC2** son servidores virtuales que puedes lanzar para ejecutar aplicaciones. Existen diferentes tipos de instancias con distintas configuraciones de CPU, memoria, almacenamiento y capacidad de red, lo que permite elegir la configuración más adecuada para las necesidades de tu aplicación.

Beneficios de usar EC2:

- Escalabilidad: Puedes aumentar o disminuir la cantidad de recursos en función de las necesidades de tu aplicación.
- Pago por uso: Solo pagas por el tiempo que la instancia está en funcionamiento, lo que lo hace flexible y rentable.
- Opciones de personalización: Puedes elegir entre una variedad de sistemas operativos y configuraciones de hardware.
- Alta disponibilidad: EC2 proporciona opciones para distribuir instancias en diferentes regiones geográficas y zonas de disponibilidad, lo que garantiza que las aplicaciones permanezcan disponibles incluso en caso de fallos.

## Aprovisionando instancias en EC2.

En el contexto de AWS, la palabra `aprovisionar` (del inglés "provision") se refiere al proceso de configurar y lanzar recursos en la nube para su uso. Cuando se habla de aprovisionar una instancia en EC2, significa que estás creando y configurando un servidor virtual con ciertos recursos (CPU, memoria, almacenamiento, etc.) listos para ejecutar aplicaciones.

## Configurando Pares de Claves (key pairs).

Los **pares de claves (key pairs)** son un mecanismo de seguridad utilizado en servicios de la nube como AWS EC2 para garantizar un acceso seguro a las instancias (servidores virtuales). Un par de claves consta de dos partes:

- *Clave pública*: Esta clave se almacena en la instancia en la nube. Se utiliza para cifrar los datos que solo pueden ser descifrados por la clave privada correspondiente.
- *Clave privada*: Esta clave se descarga y guarda localmente. Se utiliza para autenticarte y conectarte a la instancia. La clave privada descifra la información que fue cifrada con la clave pública, permitiéndote acceder de manera segura al servidor.

### Pasos para configurar el par de claves en EC2.

Es necesario crear tantos pares de claves sean necesarios para asegurar las instancias en la nube. Para ello, sigue los siguientes pasos.

1. Iniciar sesión en la [Consola de AWS](https://console.aws.amazon.com/) con usuario y contraseña.
2. Seleccionar el servicio `EC2`.
3. Seleccionar la opción `Pares de claves` que se encuentra en la sección de **Red y Seguridad.**
4. Asignar un nombre al par de claves.
5. Seleccionar el Tipo de par de claves `RSA`.
6. Seleccionar el formato de archivo de clave privada `.pem`.
7. Crear pares de claves.

Al crear el par de claves se genera un archivo `'nombre-par-claves'.pem` con el nombre que asignamos a nuestro par de claves.

## Grupos de seguridad

Los **grupos de seguridad** en AWS son un componente crucial para gestionar la seguridad de las instancias en la nube, como las instancias de EC2. Un grupo de seguridad actúa como un firewall virtual que controla el tráfico de red entrante y saliente a nivel de instancia.

### Pasos para crear Grupos de seguridad en EC2.

Es necesario configurar los permisos para los grupos de seguridad. Para ello sigue los siguientes pasos:

1. Iniciar sesión en la [Consola de AWS](https://console.aws.amazon.com/) con usuario y contraseña.
2. Seleccionar el servicio `EC2`.
3. Seleccionar la opción `Grupos de seguridad` que se encuentra en la sección de **Red y Seguridad.**
4. Presionar el botón `Crear grupo de seguridad` para comenzar la configuración de nuestro grupo de seguridad.
5. Configurar el nombre del grupo de seguridad