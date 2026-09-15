variable "project_id" {
  description = "Qovery project UUID that owns the demo environment."
  type        = string
}

variable "cluster_id" {
  description = "Qovery cluster UUID where the demo environment runs."
  type        = string
}

variable "environment_name" {
  description = "Name of the dedicated Qovery demo environment."
  type        = string
  default     = "monorepo-demo"
}

variable "repository_url" {
  description = "Git URL of this monorepo."
  type        = string
  default     = "https://github.com/Guimove/qovery-monorepo-microservices.git"
}

variable "branch" {
  description = "Branch deployed to staging."
  type        = string
  default     = "main"
}
