
# Tutorial: Atualização Automática de DNS Dinâmico com AWS Route 53
Neste tutorial, você aprenderá como configurar uma solução de atualização automática de DNS dinâmico usando a AWS Route 53. Isso permitirá que um registro DNS seja atualizado automaticamente com o seu IP dinâmico sempre que ele mudar.

## Parte 1: Configuração da Conta na AWS
### Passo 1: Crie uma Conta na AWS
Se você ainda não possui uma conta na AWS, siga estas etapas para criar uma:

1. Acesse https://aws.amazon.com/ e clique em "Crie uma conta gratuita".
2. Siga as instruções para criar uma conta AWS com suas informações.
### Passo 2: Configuração de Credenciais
1. Após criar sua conta, acesse o Console de Gerenciamento da AWS.
2. No canto superior direito, clique na sua conta e selecione "My Security Credentials".
3. Clique em "Continuar para Security Credentials".
4. Na seção "Access keys (access key ID and secret access key)", crie ou gere uma nova chave de acesso.

## Parte 2: Configuração de Atualização Automática de DNS Dinâmico
### Passo 1: Crie uma Política no IAM
1. Acesse o Console de Gerenciamento da AWS e vá para o serviço IAM.
2. No painel de navegação à esquerda, clique em "Policies" e em "Create policy".
3. Escolha "JSON" e cole a política de permissão para atualizar registros no Route 53. (Exemplo fornecido abaixo)
4. Defina um nome e descrição para a política e clique em "Create policy".
   
Exemplo de política JSON:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetChange"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/YOUR_HOSTED_ZONE_ID"
            ]
        }
    ]
}
```
### Passo 2: Crie um Usuário no IAM
1. No painel de navegação à esquerda do IAM, clique em "Users" e em "Add user".
2. Escolha um nome para o usuário, selecione "Programmatic access" e clique em "Next: Permissions".
3. Anexe a política criada no passo anterior ao usuário e clique em "Next: Tags".
4. Pule as tags (se não for necessário) e clique em "Next: Review".
5. Revise as configurações e clique em "Create user". Anote as chaves de acesso geradas.
### Passo 3: Configuração do Script
1. No servidor onde você deseja executar o script, instale as AWS Tools para PowerShell ou a biblioteca necessária.
2. Crie um script (por exemplo, update-dns.ps1) e cole o código do script PowerShell fornecido anteriormente.
3. Substitua YOUR_ACCESS_KEY e YOUR_SECRET_KEY pelas chaves de acesso geradas no passo anterior.
4. Substitua YOUR_HOSTED_ZONE_ID pelo ID da sua zona hospedada no Route 53.
5. Ajuste outras configurações no script conforme necessário.
### Passo 4: Agende a Execução do Script
1. Agende a execução do script para atualizar o DNS a cada hora.
2. Use ferramentas como Agendador de Tarefas no Windows ou cron no Linux.
