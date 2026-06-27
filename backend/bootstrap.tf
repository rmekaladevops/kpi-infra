provider "aws" {
  region = "ap-south-1"

}

resource "aws_s3_bucket" "tf_state" {
  for_each = toset(["dve", "int", "prod"])
  bucket   = "kpi-tfstate-${each.key}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  for_each = aws_s3_bucket.tf_state
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  for_each     = toset(["dve", "int", "prod"])
  name         = "kpi-tflock-${each.key}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
