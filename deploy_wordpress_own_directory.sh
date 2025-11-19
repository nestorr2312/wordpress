#!/bin/bash
# Script para desplegar WordPress en un subdirectorio (e.g., /var/www/html/blog)

# Cargar variables del .env
source .env

DEST_DIR="/var/www/html/blog"

echo "--- Creando directorio de destino ---"
sudo mkdir -p $DEST_DIR
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz

echo "--- Movienso archivos de WordPress al directorio web ---"
sudo cp -r wordpress/* $DEST_DIR/

# La configuración de wp-config.php es similar al script anterior...
# (Omitido por ser repetitivo, pero seguiría la misma lógica de sed)

echo "--- Corrigiendo permisos en el subdirectorio ---"
sudo chown -R www-data:www-data $DEST_DIR
sudo chmod -R 755 $DEST_DIR

echo "--- Despliegue en subdirectorio completado ---"
