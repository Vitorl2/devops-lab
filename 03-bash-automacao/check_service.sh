#!/bin/bash

# 1. Valida se o usu√°rio passou os 2 argumentos ($1 = servi√ßo, $2 = porta)
if [ $# -lt 2 ]; then
    echo "‚ùå Erro: Par√¢metros ausentes!"
    echo "Uso correto: $0 <nome_do_servico> <porta>"
    exit 1
fi

SERVICE=$1
PORT=$2
LOG_FILE="healthcheck.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "Ì¥ç Verificando servi√ßo '$SERVICE' na porta '$PORT'..."

# 2. Testa Pilar 3 (Servi√ßo Ativo e Porta em Escuta)
if systemctl is-active --quiet "$SERVICE" && ss -tulpn | grep -q ":$PORT"; then
    MSG="[$TIMESTAMP] SUCCESS: O servi√ßo '$SERVICE' est√° ATIVO e escutando na porta $PORT."
    echo "Ìø¢ $MSG"
    echo "$MSG" >> "$LOG_FILE"
else
    MSG="[$TIMESTAMP] ERROR: Falha no servi√ßo '$SERVICE' ou porta $PORT n√£o est√° em escuta!"
    echo "Ì¥¥ $MSG"
    echo "$MSG" >> "$LOG_FILE"
fi
