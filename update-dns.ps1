#!/bin/bash

# Configurações
HOSTED_ZONE_ID="SEU_ID_DA_ZONA_HOSPEDADA"
RECORD_NAME="domain.com"
TTL=300

# Arquivo para armazenar o último IP registrado
LAST_IP_FILE="c:\\last_ip.txt"

# Função para obter o endereço IP público atual
get_public_ip() {
    curl -s https://api64.ipify.org?format=json | jq -r .ip
}

# Função para ler o último IP registrado
get_last_ip() {
    if [ -f "$LAST_IP_FILE" ]; then
        cat "$LAST_IP_FILE"
    else
        echo "0.0.0.0"  # Um valor inicial para o primeiro registro
    fi
}

# Função para atualizar o último IP registrado
update_last_ip() {
    local new_ip=$1
    echo "$new_ip" > "$LAST_IP_FILE"
}

# Função para atualizar o registro DNS no Route 53
update_dns_record() {
    local new_ip=$1
    
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch '{
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$RECORD_NAME'",
                        "Type": "A",  # Altere para AAAA se for IPv6
                        "TTL": '$TTL',
                        "ResourceRecords": [{"Value": "'$new_ip'"}]
                    }
                }
            ]
        }'
    
    echo "DNS record updated successfully."
}

# Executa o script
new_ip=$(get_public_ip)
last_ip=$(get_last_ip)

if [ "$new_ip" != "$last_ip" ]; then
    echo "New IP: $new_ip"
    update_dns_record $new_ip
    update_last_ip $new_ip
else
    echo "IP has not changed."
fi
