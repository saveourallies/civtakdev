resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucketname 
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3Public" {
  bucket = aws_s3_bucket.tfstate.id
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}
