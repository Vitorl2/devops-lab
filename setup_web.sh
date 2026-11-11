#!/bin/bash

echo "Ì¥ç Checando Nginx..."
if systemctl is-active --quiet nginx; then
    echo "Ìø¢ Nginx j√° est√° ativo!"
else
    echo "Ìø° Iniciando Nginx..."
    sudo systemctl start nginx
fi

echo "Ìª°Ô∏è Configurando Firewall..."
sudo firewall-cmd --add-port=80/tcp --permanent > /dev/null 2>&1
sudo firewall-cmd --reload > /dev/null 2>&1

echo "Ì∑™ Testando acesso HTTP..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "‚úÖ SUCCESS: Servidor Web rodando e acess√≠vel na porta 80 (HTTP $HTTP_CODE)!"
else
    echo "‚ùå ERROR: Servidor respondeu com c√≥digo $HTTP_CODE"
fi
