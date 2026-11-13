#!/bin/bash

# Testa a porta 80 do Nginx
if curl -s -I http://localhost:80 | grep -q "200 OK"; then
    echo "Ìø¢ SUCESSO: O Nginx est√° ativo e respondendo 200 OK!"
else
    echo "Ì¥¥ ERRO: O servi√ßo Nginx n√£o respondeu como esperado."
fi
