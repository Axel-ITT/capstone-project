# Upload node-red templates to s3, so that ec2 instances can grab them during initializsation


resource "aws_s3_bucket_public_access_block" "templates" {
  bucket = module.templates_bucket.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "flow" {
  bucket = module.templates_bucket.bucket_name
  key    = "flows.json"
  source = var.flows_filepath
  etag = filemd5(var.flows_filepath)
}