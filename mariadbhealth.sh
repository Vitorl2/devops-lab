#!/bin/bash

# Script de verificação de saúde do MariaDB
# Salva histórico em mariadb_health.log

LOG_FILE="mariadbhealth.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Função para registrar no log e mostrar na tela
log_message() {
    local level="$1"
    local message="$2"
    echo "[$DATE] [$level] $message" | tee -a "$LOG_FILE"
}

echo "========================================"
echo "  Verificação de Saúde do MariaDB"
echo "========================================"
echo ""

log_message "INFO" "Iniciando verificação de saúde do MariaDB"

# 1. Verificar se o serviço está ativo
if systemctl is-active --quiet mariadb; then
    log_message "OK" "Serviço mariadb está ATIVO"
    SERVICE_STATUS="OK"
else
    log_message "ERRO" "Serviço mariadb NÃO está ativo"
    SERVICE_STATUS="FALHA"
fi

# 2. Verificar se a porta 3306 está em escuta
if ss -tuln | grep -q ':3306'; then
    log_message "OK" "Porta 3306 está em ESCUTA"
    PORT_STATUS="OK"
else
    log_message "ERRO" "Porta 3306 NÃO está em escuta"
    PORT_STATUS="FALHA"
fi

# 3. Tentar conexão básica (sem senha, apenas teste de socket/local)
if command -v mariadb >/dev/null 2>&1; then
    if mariadb -e "SELECT 1;" >/dev/null 2>&1; then
        log_message "OK" "Conexão local com MariaDB bem-sucedida"
        CONN_STATUS="OK"
    else
        log_message "AVISO" "Não foi possível conectar localmente (pode precisar de senha ou socket)"
        CONN_STATUS="AVISO"
    fi
else
    log_message "AVISO" "Cliente mariadb não encontrado no PATH"
    CONN_STATUS="AVISO"
fi

# 4. Resumo final
echo ""
echo "----------------------------------------"
echo "RESUMO:"
echo "  Serviço:     $SERVICE_STATUS"
echo "  Porta 3306:  $PORT_STATUS"
echo "  Conexão:     $CONN_STATUS"
echo "----------------------------------------"

if [[ "$SERVICE_STATUS" == "OK" && "$PORT_STATUS" == "OK" ]]; then
    log_message "INFO" "Verificação concluída: MariaDB aparenta estar saudável"
    echo "Status geral: SAUDÁVEL"
else
    log_message "ALERTA" "Verificação concluída: Problemas detectados"
    echo "Status geral: PROBLEMAS DETECTADOS"
fi

echo ""
echo "Histórico salvo em: $LOG_FILE"
echo "========================================"
[2026-11-13 15:27:48] [INFO] Iniciando verificação de saúde do MariaDB
[2026-11-13 15:27:48] [OK] Serviço mariadb está ATIVO
[2026-11-13 15:27:48] [OK] Porta 3306 está em ESCUTA
[2026-11-13 15:27:48] [AVISO] Não foi possível conectar localmente (pode precisar de senha ou socket)
[2026-11-13 15:27:48] [INFO] Verificação concluída: MariaDB aparenta estar saudável
