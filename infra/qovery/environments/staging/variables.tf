variable "environment_id" {
  description = "Existing Qovery staging environment UUID."
  type        = string
}

variable "repository_url" {
  description = "Git URL of this monorepo."
  type        = string
  default     = "https://github.com/acme/commerce-platform.git"
}

variable "branch" {
  description = "Branch deployed to staging."
  type        = string
  default     = "main"
}
