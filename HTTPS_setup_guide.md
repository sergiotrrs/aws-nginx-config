# Manual de Configuración HTTPS para API en EC2 con NGINX y Let's Encrypt

Este manual detalla el proceso para asegurar una API REST de Spring Boot con un certificado SSL/TLS gratuito. Se utilizará NGINX como proxy inverso, **DuckDNS** para obtener un nombre de dominio gratuito y Let's Encrypt para la generación de certificados en una instancia EC2.

## ¿Qué es HTTPS y por qué es fundamental?

HTTPS son las siglas de Hypertext Transfer Protocol Secure (Protocolo Seguro de Transferencia de Hipertexto). En términos sencillos, es la versión segura y cifrada de HTTP. La 'S' final es la clave, ya que indica que toda la comunicación entre tu navegador y el servidor web está encriptada.

Esto garantiza tres pilares de la seguridad en la web:

1. Confidencialidad: La información que se envía (como contraseñas, datos personales o números de tarjeta de crédito) no puede ser leída por un atacante que intercepte la comunicación.

2. Integridad: Los datos no pueden ser modificados en tránsito sin que se detecte. Esto evita que un atacante inyecte código malicioso o altere la información que recibes.

3. Autenticación: Asegura que te estás comunicando con el servidor legítimo y no con un impostor. Esto es lo que verifica el certificado SSL/TLS.

Los navegadores modernos aplican una estricta política de seguridad llamada "Bloqueo de Contenido Mixto" (Mixed Content Blocking). Esto significa que si tu frontend está en `https://my-ecommerce.com` y tu backend está en `http://api.my-ecommerce.com`, la comunicación fallará. El navegador no permitirá que una página segura haga peticiones a un servidor inseguro para proteger al usuario de posibles ataques.

Por esta razón, es absolutamente necesario que tanto el frontend como el backend (tu API REST) se sirvan a través de HTTPS.

## ¿Qué es NGINX?

NGINX es un servidor web de alto rendimiento que también puede funcionar como proxy inverso, balanceador de carga y caché HTTP. En esta configuración, lo usaremos como **proxy inverso**: recibirá las peticiones HTTPS desde internet, las desencriptará y las reenviará de forma segura a nuestra aplicación Spring Boot, que se ejecuta localmente en el puerto 8080.

## ¿Qué es Let's Encrypt y Certbot?

**Let's Encrypt** es una autoridad de certificación (CA) gratuita, automatizada y abierta. Proporciona certificados SSL/TLS sin costo para habilitar HTTPS en los sitios web.

**Certbot** es el cliente de software que se utiliza para obtener e instalar automáticamente los certificados de Let's Encrypt. Simplifica el proceso de configuración y también gestiona la renovación automática de los certificados antes de que expiren.

## Uso de DuckDNS para un Dominio Gratuito (Prueba de Concepto)

Para que Let's Encrypt pueda emitir un certificado, necesitamos un nombre de dominio público.

**¿Por qué no usar el DNS público que proporciona AWS?**
La dirección DNS que AWS asigna por defecto a una instancia (ej. `ec2-xx-xx-xx-xx.compute-1.amazonaws.com`) presenta dos problemas para este caso:
1.  **Es volátil**: Si detienes y vuelves a iniciar la instancia, tanto la IP pública como el nombre DNS cambiarán, rompiendo la configuración del certificado.
2.  **Políticas de Let's Encrypt**: Let's Encrypt tiene políticas muy estrictas y límites de velocidad para la emisión de certificados en dominios de proveedores de nube masivos como `amazonaws.com`, lo que a menudo resulta en fallos.

**¿Por qué DuckDNS es la solución para una prueba?**
**DuckDNS** es un servicio gratuito de DNS dinámico que nos proporciona un subdominio estable (ej. `my-ecommerce-demo.duckdns.org`). Este nombre no cambia y podemos apuntarlo fácilmente a la IP pública de nuestra instancia, cumpliendo así con los requisitos de Let's Encrypt.

## Pasos para Configurar HTTPS con NGINX y Let's Encrypt

A continuación se presentan los pasos para una API de Spring Boot llamada `my-ecommerce-demo`.

### Prerrequisitos

1.  **API en Ejecución**: Tener la aplicación Spring Boot `my-ecommerce-demo.jar` ejecutándose en la instancia EC2, escuchando en el puerto `8080`.
2.  **Dominio de DuckDNS Configurado**:
    * Ve a [DuckDNS](https://www.duckdns.org/) y crea una cuenta (puedes usar tu cuenta de Google, GitHub, etc.).
    * Registra el subdominio que desees, para este manual supondremos el nombre `my-ecommerce-demo`.
    * En el campo de la IP, **debes introducir la dirección IP pública actual de tu instancia EC2** y hacer clic en "update ip".

### Paso 1: Configurar el Security Group en AWS

La instancia debe permitir el tráfico web entrante. En la consola de AWS, asegúrate que en **Grupo de Seguridad** de tu instancia tenga las siguientes reglas de entrada:

| Tipo | Protocolo | Rango de puertos | Origen | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| HTTP | TCP | 80 | 0.0.0.0/0 | Permite a Certbot validar el dominio. |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Permite el tráfico final seguro. |

### Paso 2: Instalar Certbot

Instala la herramienta Certbot y su plugin específico para NGINX.

```bash
sudo dnf install certbot python3-certbot-nginx -y
```

### Paso 3: Instalación de NGINX y modificación del Archivo de Configuración para la API

Realiza la [Configuración de NGINX como Proxy Inverso](NGINX_installation_guide.md).

1. Modifica el archivo de configuración específico para tu API.

```bash
sudo nano /etc/nginx/conf.d/my-ecommerce-demo.conf
```

2. Modifica el valor del atributo server_name con el DNS obtenido con [DuckDNS](https://www.duckdns.org/)

```bash   
    # Esta es la línea clave que Certbot necesita encontrar. 
    # Debe coincidir con tu dominio de DuckDNS.
    server_name my-ecommerce-demo.duckdns.org;
```

3. Guarda el archivo y sal del editor (`Ctrl+X`, luego `Y`, y `Enter`).
   
### Paso 4: Obtener e Instalar el Certificado SSL
Con la configuración de NGINX ya preparada, ahora Certbot podrá encontrar el dominio y automatizar todo el proceso.

1. Ejecuta Certbot, usando tu dominio de DuckDNS.

```bash
sudo certbot --nginx -d my-ecommerce-demo.duckdns.org
```

2. Certbot te guiará con algunas preguntas (email, términos de servicio). 
   
### Paso 5: Verificación Final
Tu API ya debería estar funcionando de forma segura a través de HTTPS en tu dominio de DuckDNS.

1. Prueba en el navegador: Abre un navegador web y navega a `https://my-ecommerce-demo.duckdns.org/` seguido de la ruta de algún endpoint de tu API. Deberías ver el ícono del candado, indicando una conexión segura.

2. Revisa la configuración (Opcional): Puedes abrir de nuevo el archivo de configuración para ver los cambios que hizo Certbot.
```bash
cat /etc/nginx/conf.d/my-ecommerce-demo.conf 
```

Notarás que ahora el archivo tiene directivas ssl_certificate, ssl_certificate_key y escucha en el puerto 443 ssl, además del bloque que redirige el tráfico del puerto 80 al 443.

Una vez finalizado, tu API ya estará disponible en `https://generation-ch54.duckdns.org`. Certbot habrá transformado tu archivo de configuración para manejar el tráfico HTTPS en el puerto 443 y redirigir el del puerto 80.

### Consideraciones para un Entorno de Producción (Lectura opcional)

La configuración anterior es excelente para una prueba de concepto (PoC), desarrollo o proyectos personales. Para una aplicación real en producción, la práctica recomendada es diferente:

#### Dominio y Dirección IP
   
- Comprar un Dominio Propio: En lugar de usar un subdominio gratuito, se debe comprar un dominio propio (ej. www.mi-ecommerce-real.com). Esto ofrece profesionalismo, credibilidad y control total.

- Usar una Dirección IP Estática (Elastic IP): En AWS, se debe asignar una IP Elástica a la instancia EC2. Es una dirección IP pública estática que no cambia si la instancia se detiene o reinicia, garantizando que tu dominio siempre apunte al servidor correcto.

#### Alternativas para Dominio y Certificado

Existen varias formas de gestionar tu dominio y certificado SSL. Aquí se comparan dos enfoques comunes: uno totalmente integrado en AWS y otro usando un registrador externo como GoDaddy.

##### Alternativa A: Solución Integrada con AWS (Recomendado)

Este es el enfoque moderno y escalable si tu infraestructura está en AWS.

- Dominio: Puedes registrar tu dominio directamente con Amazon Route 53. Funciona como cualquier otro registrador (GoDaddy, Namecheap), pero se integra de forma nativa con otros servicios de AWS.

- Certificado: Utiliza AWS Certificate Manager (ACM).

  - Costo: Proporciona certificados SSL/TLS públicos totalmente gratuitos.

  - Renovación Automática: ACM gestiona la renovación de los certificados automáticamente, sin necesidad de cron jobs o Certbot en la instancia.

  - Integración: El certificado de ACM no se instala en la instancia EC2. En su lugar, se asocia a un Application Load Balancer (ALB). El ALB gestiona todo el tráfico HTTPS (terminación SSL) y lo reenvía de forma segura a tus instancias EC2 por el puerto 8080. Esta arquitectura es más segura y facilita el escalado horizontal.

##### Alternativa B: Usando un Registrador Externo (ej. GoDaddy)

Si ya tienes un dominio con un proveedor como GoDaddy, puedes integrarlo perfectamente con AWS.

- Dominio: Gestionas tu dominio (mi-ecommerce-real.com) en el panel de GoDaddy.

- Configuración de DNS: En GoDaddy, crearías un registro A que apunte a la IP Elástica de tu instancia EC2 o, preferiblemente, un registro CNAME que apunte al DNS de tu Application Load Balancer.

- Opciones para el Certificado:

  - Usar AWS Certificate Manager (Recomendado): Aún puedes solicitar un certificado gratuito en ACM para tu dominio de GoDaddy. ACM te pedirá verificar la propiedad del dominio, generalmente añadiendo un registro CNAME específico en tu panel de DNS de GoDaddy. Una vez verificado, puedes usar ese certificado con un Application Load Balancer como en la alternativa anterior.

  - Usar Let's Encrypt: Puedes seguir usando Certbot en tu instancia EC2 para generar el certificado. Funciona bien, pero acopla la gestión del certificado a la instancia, lo que es menos flexible que gestionarlo a nivel de balanceador de carga.