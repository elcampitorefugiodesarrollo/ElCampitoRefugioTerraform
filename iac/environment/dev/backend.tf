terraform {
  backend "s3" {
    bucket = "el-campito-refugio-terraform-state"
    key    = "dev"
    region = "us-east-1"
  }
}
