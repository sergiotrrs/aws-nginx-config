# Configuración para un servidor Nginx que actúa 
# como un servidor proxy inverso para redirigir 
# el tráfico HTTP entrante desde el puerto 80 a 
# una aplicación(springboot) que se ejecuta en el 
# mismo servidor en el puerto 8080.
# Ubicación del archivo /etc/nginx/sites-available/app

server {
    listen 80;
    server_name public_ip_EC2_instance;

    location / {
      proxy_pass http://localhost:8080;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;

   }

}
