#!/bin/bash

# Script de Monitoramento da Stack de 2 Camadas (Nginx + MariaDB)
LOG_FILE="/vagrant/03-bash-automacao/stack_health.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log_message() {
    local level="$1"
    local message="$2"
    echo "[$DATE] [$level] $message" | tee -a "$LOG_FILE"
}

echo "========================================"
echo "   Verificação de Saúde da Stack 2-Tier"
echo "========================================"
echo ""

log_message "INFO" "Iniciando checagem da stack completa..."

# 1. Checagem da Camada de Banco (MariaDB)
if systemctl is-active --quiet mariadb && ss -tuln | grep -q ':3306'; then
    log_message "OK" "MariaDB: Serviço ATIVO e Porta 3306 em ESCUTA"
    MARIADB_STATUS="OK"
else
    log_message "ERRO" "MariaDB: FALHA no serviço ou porta 3306"
    MARIADB_STATUS="FALHA"
fi

# 2. Checagem da Camada Web (Nginx - Serviço e Porta 80)
if systemctl is-active --quiet nginx && ss -tuln | grep -q ':80'; then
    log_message "OK" "Nginx: Serviço ATIVO e Porta 80 em ESCUTA"
    NGINX_STATUS="OK"
else
    log_message "ERRO" "Nginx: FALHA no serviço ou porta 80"
    NGINX_STATUS="FALHA"
fi

# 3. Checagem de Requisição HTTP (cURL testando retorno 200 OK)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$HTTP_CODE" -eq 200 ]; then
    log_message "OK" "HTTP Localhost: Respondeu com código 200 (OK)"
    HTTP_STATUS="OK"
else
    log_message "ERRO" "HTTP Localhost: Respondeu com código $HTTP_CODE"
    HTTP_STATUS="FALHA"
fi

# 4. Resumo e Diagnóstico Final
echo ""
echo "----------------------------------------"
echo "RESUMO DA STACK:"
echo "  MariaDB (Porta 3306): $MARIADB_STATUS"
echo "  Nginx (Porta 80):     $NGINX_STATUS"
echo "  Web HTTP 200 OK:      $HTTP_STATUS"
echo "----------------------------------------"

if [[ "$MARIADB_STATUS" == "OK" && "$NGINX_STATUS" == "OK" && "$HTTP_STATUS" == "OK" ]]; then
    log_message "INFO" "Status Geral da Stack: 100% OPERACIONAL"
    echo "Status Geral: SAUDÁVEL ���"
else
    log_message "ALERTA" "Status Geral da Stack: PROBLEMAS DETECTADOS"
    echo "Status Geral: FALHA ⚠️"
fi

echo ""
echo "Log registrado em: $LOG_FILE"
echo "========================================"
