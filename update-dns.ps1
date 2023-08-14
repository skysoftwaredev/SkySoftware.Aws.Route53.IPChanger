
# Configurações
$hostedZoneId = "hostzoneid"
$recordName = "domain-to-change-in-aws.com"
$ttl = 300
$caminhoArquivo = ".\ip.txt"

# Função para obter o endereço IP público atual
function Get-PublicIP {
   return  (New-Object System.Net.WebClient).DownloadString("https://api64.ipify.org");
}

function Get-CurrentIP {
    if (Test-Path -Path $caminhoArquivo){
        return Get-Content -Path $caminhoArquivo
    }
    else{
        return "";
    }
}

function Update-LocalIP($newIP){
    Set-Content -Path $caminhoArquivo -Value $newIP
}

# Função para atualizar o registro DNS no Route 53
function Update-DNSRecord ($newIP) {
    if ([bool]($newIP -as [ipaddress])){
        $changeObject = @{
            Changes = @(
                @{
                    Action = "UPSERT"
                    ResourceRecordSet = @{
                        Name = $recordName
                        Type = "A"
                        TTL = $ttl
                        ResourceRecords = @(
                            @{
                                Value = $newIP
                            }
                        )
                    }
                }
            )
        }

        $jsonString = $changeObject | ConvertTo-Json -Depth 10
        
        Set-Content -Path .\change.json -Value $jsonString

        aws route53 change-resource-record-sets `
            --hosted-zone-id $hostedZoneId `
            --change-batch  file://.\change.json
    }
}

# Execute o script
$newIP = Get-PublicIP
$curIP = Get-CurrentIP

if ($newIP -ne $curIP){
    Write-Host "Updating DNS record..."
    Write-Host "New IP: $newIP"
    Update-DNSRecord($newIP)
    Write-Host "DNS record updated successfully."
    Update-LocalIP($newIP)
} else {
    Write-Host "IP are equals"
}


