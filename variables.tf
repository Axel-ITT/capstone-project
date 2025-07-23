variable "project" {
  description = "Project name"
  type = string
}

variable "environment" {
  description = "Project environment"
  type = string
}

variable "ssh_address_range" {
  description = "Range of allowed ssh/scp adresses"
  type = string
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