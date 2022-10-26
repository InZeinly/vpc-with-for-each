resource "aws_s3_bucket" "test_bucket" {
  bucket = "test_bucket"

  tags = {
    Name        = "Test-bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.test_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_test" {
  bucket = aws_s3_bucket.test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Dynamodb terraform state lock

resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
  hash_key = "LockID"
  read_capacity = 10
  write_capacity = 10
 
  attribute {
    name = "LockID"
    type = "S"
  }
}