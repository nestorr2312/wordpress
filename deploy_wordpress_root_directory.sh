#!/bin/bash
# Script para desplegar WordPress en el directorio raíz (/var/www/html/)

# Cargar variables del .env
source .env

echo "--- Descargando y preparando WordPress ---"
cd /tmp
wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -zxvf wordpress.tar.gz
# Mueve los archivos directamente al directorio raíz del servidor
sudo cp -r wordpress/* /var/www/html/

# Eliminar archivos innecesarios
sudo rm /var/www/html/index.html # Eliminar la página por defecto de Apache
sudo rm -rf /tmp/wordpress # Limpiar archivos temporales

echo "--- Creando y configurando wp-config.php ---"
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php

# 1. Insertar credenciales corregidas
sudo sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sudo sed -i "s/username_here/$DB_USER/g" wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
sudo sed -i "s/localhost/$DB_HOST/g" wp-config.php # Usar localhost

# 2. Generar e insertar claves de seguridad (Como lo hicimos manualmente)
SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
# Inserta justo antes de la línea de las claves
sudo sed -i "/put your unique phrases here/a $SECURITY_KEYS" wp-config.php

echo "--- Creando usuario y base de datos en MariaDB ---"
sudo mysql -u root <<MYSQL_COMMANDS
CREATE DATABASE IF NOT EXISTS $DB_NAME;
# Crear el usuario con la contraseña segura y otorgar permisos
CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';
FLUSH PRIVILEGES;
MYSQL_COMMANDS

echo "--- Corrigiendo permisos para Apache (www-data) ---"
sudo chown -R www-data:www-data /var/www/html/
sudo find /var/www/html/ -type d -exec chmod 755 {} \;
sudo find /var/www/html/ -type f -exec chmod 644 {} \;

echo "--- Reiniciando Apache y finalizando ---"
sudo systemctl restart apache2

echo "--- Despliegue de WordPress completado ---"
echo "Accede a: http://<TU_IP> para la configuración final."
