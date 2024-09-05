# Preparando nuestro Proyecto Integrador.

El proyecto integrador se encuentra desarrollado de la siguiente manera:
- **Frontend**: HTML, CSS, JavaScript y Bootstrap.
- **Backend**: Spring boot con Java,
- **Base de datos**: MySQL.

## Acoplando frontend con backend

El primer paso que debemos realizar para que nuestro proyecto pueda vivir de manera remota es realizar el acoplamiento de la carpeta donde se desarrolló el frontend con la carpeta donde se desarrolló el backend.

> Es necesario recordarte que el punto de acceso de nuestro frontend es el archivo `index.html` el cual se debe encontrar en el nivel principal.

Para realizar el acoplamiento, copiaremos la carpeta del frontend dentro de la carpeta del backend, en la ruta `src/main/resources/static`

Puedes consultar el siguiente repositorio para observar la nueva estructura del proyecto.
[Repositorio de ejemplo](https://github.com/sergiotrrs/aws-ec2-demo.git)