#!/bin/bash
# Script para desplegar WordPress en el directorio raíz (/var/www/html/)

# Cargar variables del .env
source .env

echo "--- Descargando WordPress ---"
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz

echo "--- Movienso archivos de WordPress al directorio web ---"
sudo cp -r wordpress/* /var/www/html/
sudo rm /var/www/html/index.html # Eliminar la página por defecto de Apache

echo "--- Creando y configurando wp-config.php ---"
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php

# Reemplazar los valores de la base de datos
sudo sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sudo sed -i "s/username_here/$DB_USER/g" wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
sudo sed -i "s/localhost/localhost/g" wp-config.php # Asegurar que DB_HOST es localhost

# Generar e insertar claves de seguridad
SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/put your unique phrases here/a $SECURITY_KEYS" wp-config.php

echo "--- Corrigiendo permisos ---"
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

echo "--- Despliegue completado ---"
