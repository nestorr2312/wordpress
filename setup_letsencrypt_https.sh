#!/bin/bash
# Script para configurar HTTPS con Let's Encrypt y Certbot

# Cargar variables del .env
source .env

echo "--- Instalando Certbot ---"
# Los pasos de instalación de Certbot aquí...

echo "--- Obteniendo certificado SSL para $DOMAIN ---"
# La línea clave para obtener el certificado
# sudo certbot --apache -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

echo "--- Configuración HTTPS completada ---"
