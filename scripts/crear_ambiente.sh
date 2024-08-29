#!/bin/bash
# Salir si no se corre desde la raiz del repositorio
if [ ! -d .git ]; then
    echo "Tenes que correr el script desde la raiz del repositorio"
    exit 1
fi
WD=$(pwd)
set -e
echo "Validando requerimientos"
echo -n "AWS CLI "
if aws --version &> /dev/null; then
    echo -e "\e[32mOK\e[0m"
else
    echo -e "\e[31mERROR, ver https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html\e[0m"
    exit 1
fi
echo -n "AWS Config "
if aws s3 ls &> /dev/null; then
    echo -e "\e[32mOK\e[0m"
else
    echo -e "\e[31mERROR, falta obtener credenciales y correr 'aws configure'\e[0m"
    exit 1
fi
echo -n "Terraform "
if terraform -version &> /dev/null; then
    echo -e "\e[32mOK\e[0m"
else
    echo -e "\e[31mERROR, falta instalar terraform. Ver https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli\e[0m"
    exit 1
fi
read -p "Ingrese el nombre del nuevo ambiente a crear: " ENVIRONMENT_NAME
ENV_PATH="iac/environment/$ENVIRONMENT_NAME"
echo "El codigo del ambiente sera almacenado en $ENV_PATH"
echo "Creando ambiente"
mkdir -p $ENV_PATH
echo "terraform {
  backend \"s3\" {
    bucket = \"el-campito-refugio-terraform-state\"
    key    = \"$ENVIRONMENT_NAME\"
    region = \"us-east-1\"
  }
}" > $ENV_PATH/backend.tf

echo "terraform {
  required_version = \"~> 1.9\"
  required_providers {
    aws = {
      version = \"~> 5.0\"
      source = \"hashicorp/aws\"
    }
  }
}" > $ENV_PATH/versions.tf

echo "Inicializando ambiente"
cd $ENV_PATH
terraform init