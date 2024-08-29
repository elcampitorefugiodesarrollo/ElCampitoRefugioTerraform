terraform {
  backend "s3" {
    bucket = "el-campito-refugio-terraform-state"
    key    = "shared"
    region = "us-east-1"
  }
}
