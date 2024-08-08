Deploy Automatizado com Terraform, ECS e GitHub Actions
Este repositório contém uma aplicação web dividida em frontend e backend, que é provisionada e gerenciada usando Terraform, e implantada em um cluster ECS (Elastic Container Service) da AWS utilizando GitHub Actions para CI/CD.

Pré-requisitos
AWS CLI - Instale e configure a AWS CLI com suas credenciais AWS.
Terraform - Instale a última versão do Terraform.
Docker - Certifique-se de ter o Docker instalado e em execução.
GitHub Actions - Configure as secrets necessárias para integração com a AWS.
Passos para Configuração
1. Configuração do S3 Bucket para Backend do Terraform
Criar um bucket S3 para armazenar o estado do Terraform:

2.Vá para Settings > Secrets and variables > Actions > New repository secret.
Configuração das Secrets no GitHub
Navegue até a página do seu repositório no GitHub.

Adicione as seguintes secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION (valor: us-east-1)

3. Configuração do GitHub Actions
O GitHub Actions está configurado para automaticamente construir, testar e implantar a aplicação no ECS sempre que houver um push na branch main.



5. Deploy Manual (opcional)
Se precisar executar o Terraform manualmente, siga os passos abaixo:

Clone o repositório
Inicialize o Terraform:
terraform init

Planeje a infraestrutura:
terraform plan
Após confirmar todas as informações do terraform plan siga para o próximo passo.

Aplique as mudanças:
terraform apply --auto-approve

6. Acessando a Aplicação
Após a execução do Terraform, a aplicação será acessível via o ALB configurado. Você pode verificar o URL público do ALB diretamente no console da AWS.
