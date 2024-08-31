module "state_bucket" {
  source                   = "terraform-aws-modules/s3-bucket/aws"
  version                  = "4.1.2"
  bucket                   = "el-campito-refugio-terraform-state"
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"
  versioning = {
    enabled = true
  }
}

resource "aws_dynamodb_table" "state_locks" {
  name           = "terraform-locks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}