variable "AZ-list" {
  description = "List of AZ that should be deployed to"
  type = list(string)
}

variable "wordpress_setup_filepath" {
  description = "User data for launching a wordpress server"
  type = string
}

variable "instance_type" {
  description = "This describes the instance type"
  type = string
  default = "t3.micro"
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