terraform {
  backend "s3" {
    bucket = "el-campito-refugio-terraform-state"
    key    = "prod"
    region = "us-east-1"
  }
}
