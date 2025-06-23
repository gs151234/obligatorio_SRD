#!/bin/bash
read INPUT

DEBUG_LOG="/var/log/input_wazuh_log"
BLOCKED_USER_LOG="/var/log/bloqueo-usuario.log"
AVOID_BLOCKED_ROOT="/var/log/wazuh-bloqueo-usuario.log"
WHITE_LIST="/var/ossec/etc/white_users.list"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

echo "$(timestamp) - RAW INPUT: $INPUT" >> "$DEBUG_LOG"

USER=$(echo "$INPUT" | jq -r '.parameters.alert.data.srcuser')
echo "$(timestamp) - El usuario bloqueado es: $USER" >> "$DEBUG_LOG"

# Validación contra whitelist
if grep -qw "$USER" "$WHITE_LIST"; then
  echo "$(timestamp) - Intento de bloqueo evitado (usuario en whitelist): $USER" >> "$AVOID_BLOCKED_ROOT"
  exit 0
fi

# Bloqueo del usuario
usermod --lock "$USER" && echo "$(timestamp) - Usuario $USER bloqueado por Wazuh" >> "$BLOCKED_USER_LOG"

# Cierre de sesión del usuario
sudo pkill -KILL -u "$USER"
echo "$(timestamp) - Sesión del usuario $USER cerrada" >> "$DEBUG_LOG"
