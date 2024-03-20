#Amazon Linux 2023
#Actualizar paquetes

ssh -i spring-aws-smts-deploy.pem ec2-user@3.95.232.26
sudo yum update
sudo yum install java-17
sudo yum install git
sudo yum install nginx
sudo dnf update -y
sudo dnf install mariadb105-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb
sudo mysql_secure_installation
mysql -u MY_USER -p`MY_PASSWORD` -h MY_HOST -P 3306

# crear en Home carpeta app

mkdir app

# clonar repositorio de github y crear .JAR

# modificar permisos de ejecución

chmod +x gradlew
./gradlew build

# Copiar .JAR desde Home

# se puede omitir este paso, indicando la dirección completa del .JAR del proyecto

cp Chx-springboot-demo/build/libs/my-ecommerce-demo-1.0.0.jar app/app.jar

# crear carpetas en nginx

sudo mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled

# agregar en nginx.conf de nginx

sudo nano /etc/nginx/nginx.conf # después de: include /etc/nginx/conf.d/\*.conf;
include /etc/nginx/sites-enabled/\*;

# Configuracion para nginx

# se tiene que crear el archivo o se puede copiar del repositorio de git

sudo cp /home/ec2-user/Chx-springboot-demo/src/main/resources/config_server_aws/app /etc/nginx/sites-available/app
sudo nano /etc/nginx/sites-available/app
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/
sudo service nginx restart
sudo cp /home/ec2-user/Chx-springboot-demo/src/main/resources/config_server_aws/app.service /etc/systemd/system/app.service
sudo nano /etc/systemd/system/app.service
sudo systemctl enable app.service
sudo reboot now
sudo journalctl -u app.service -xe
