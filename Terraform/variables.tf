variable "prefix" {
  default = "raad"
}


variable "project" {
  default = "recipe-app-api-devops"
}

variable "contact" {
  default = "manjunathr.cloud@gmail.com"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "bastion_key_name" {
  default = "terraform-key"
}

variable "redshift_dbuser" {
  default = ""

}

variable "redshift_dbpassword" {
  default = ""

}

variable "redshift_maintenance_window" {
  default = ""

}

/*
variable "db_username" {
  description = "Username for the RDS postgres instance"
}

variable "db_password" {
  description = "Password for the RDS postgres instance"
}


variable "ecr_image_api" {
  description = "ECR image for API"
  default     = "875086615781.dkr.ecr.us-east-1.amazonaws.com/recipe-app-api-devops:latest"
}

variable "ecr_image_proxy" {
  description = "ECR image for proxy"
  default     = "875086615781.dkr.ecr.us-east-1.amazonaws.com/recipe-app-api-proxy:latest"
}

variable "django_secret_key" {
  description = "Secret key for Django app"
}

variable "dns_zone_name" {
  description = "Domain name"
  default     = "londonappdev.net"
}

variable "subdomain" {
  description = "Subdomain per environment"
  type        = map(string)
  default = {
    production = "api"
    staging    = "api.staging"
    dev        = "api.dev"
  }
}
*/