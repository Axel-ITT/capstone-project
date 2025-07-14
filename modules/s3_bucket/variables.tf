variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow deletion of non-empty buckets"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the bucket"
}
