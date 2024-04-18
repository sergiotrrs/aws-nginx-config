## DNF (Dandified YUM)

DNF es un sistema de gestión de paquetes utilizado principalmente en distribuciones de Linux basadas RPM (Red Hat Package Manager) como Red Hat, Fedora, CentOS y Amazon Linux 2023. DNF es una evolución de YUM (Yellowdog Updater, Modified), y se introdujo para mejorar la velocidad, el rendimiento y la usabilidad en comparación con su predecesor.

Para usar el comando DNF debes tener privilegios de super usuario. El programa sudo (super user do​) es una utilidad de los sistemas operativos tipo Unix, que permite a los usuarios ejecutar programas con los privilegios de seguridad de otro usuario (como el usuario root).

### Principales comandos de DNF

- **`sudo dnf update`**: Actualiza todos los paquetes instalados en el sistema a sus últimas versiones disponibles.
   ```bash
   sudo dnf update
   ```

- **`sudo dnf search`**: Permite buscar paquetes en los repositorios disponibles. 
   ```bash
   sudo dnf search mariadb
   ```

- **`sudo dnf info`**: Proporciona información detallada sobre un paquete específico, incluida su versión, descripción y dependencias. 
   ```bash
   sudo dnf info mariadb105-server
   ```

- **`sudo dnf install`**: Este comando se utiliza para instalar nuevos paquetes y todas sus dependencias no instaladas en el sistema.
   ```bash
   sudo dnf install mariadb105-server
   ```

- **`sudo dnf remove`**: Permite eliminar paquetes instalados en el sistema.
   ```bash
   sudo dnf remove mariadb105-server
   ```

- **`sudo dnf upgrade`**: Similar a dnf update, pero también maneja actualizaciones de versiones mayores de los paquetes instalados.
   ```bash
   sudo dnf upgrade mariadb105-server
   ```

- **`sudo dnf clean all`**: Se utiliza para limpiar el caché de paquetes descargados, lo que puede liberar espacio en disco.
   ```bash
   sudo dnf clean all
   ```