variable "key_name" {
  description = "AWS SSH key name"
  type        = string
}

variable "db_user" {
  description = "Postgres username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}

variable "docker_tag" {
  description = "Tag Docker pour les images (commit SHA ou latest)"
  type        = string
  default     = "latest"
}
