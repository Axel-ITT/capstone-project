variable "project" {
  description = "Project name"
  type = string
}

variable "environment" {
  description = "Project environment"
  type = string
}

variable "ip_address" {
  description = "IP address"
  type = string
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "ami_id" {
  type        = string
  description = "ID of ami to use"
}

variable "key_path" {
  type        = string
  description = "Filepath for ssh key"
}

variable "AZ-list" {
  description = "List of AZ that should be deployed to"
  type = list(string)
}

variable "setup_filepath" {
  description = "User data for launching a nodered server"
  type = string
}

variable "flows_filepath" {
  description = "Nodered flows for website setup"
  type = string
}

variable "instance_type" {
  description = "This describes the instance type"
  type = string
}

variable "ssh_port" {
  description = "SSH Port"
  type = number
  default = 22
}

variable "http_port" {
  description = "HTTP Port"
  type = number
  default = 80
}

variable "https_port" {
  description = "HTTPS Port"
  type = number
  default = 8080
}

variable "skip_bucket_creation_if_exists" {
  type        = bool
  default     = true
  description = "Skip bucket creation if it exists"
}

