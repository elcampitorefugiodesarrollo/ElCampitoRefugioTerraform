# Repo infraestructura el campito

# Crear ambiente nuevo
Para crear un ambiente nuevo, es necesario tener los siguientes requerimientos:
- AWS CLI -> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Credenciales -> Crear usuario y obtener clave https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
- Terraform -> https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Crear el ambiente corriendo el script `scripts/crear_ambiente.sh` e ingresando el nombre del ambiente.
El script valida las dependencias, crea el archivo para el la configuracion del backend en S3 y crea el archivo versions.tf y finalmente inicializa terraform.

Una vez validada la estructura, se recomienda crear un commit.

# Subir nueva imagen a ECR
Requerimientos
- Credenciales IAM
- Tu usuario de IAM tiene que estar en el archivo `modules/ecr/main.tf`. Busca la referencia con "@REF:1" (ctrl+f)

Procedimiento (Windows WSL2)
- `aws ecr-public get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin public.ecr.aws`
- `sudo docker push la-imagen`