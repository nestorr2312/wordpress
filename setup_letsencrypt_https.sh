#!/bin/bash
# Script para configurar HTTPS con Let's Encrypt y Certbot

# Cargar variables del .env
source .env

echo "--- Instalando Certbot ---"
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

echo "--- Obteniendo certificado SSL para $DOMAIN ---"
sudo certbot --apache -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

echo "--- Comprobando la renovación automática de Certbot ---"
sudo systemctl status snap.certbot.renew.service

echo "--- Configuración HTTPS completada ---"
