# Lab locks IAM permission: s3:GetBucketObjectLockConfiguration
# Terraform will acess this during bucket permission and throw an error
# Module allows to continue despite this non critical error

resource "aws_s3_bucket" "template" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}
