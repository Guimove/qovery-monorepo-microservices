variable "environment_id" {
  description = "Qovery environment UUID."
  type        = string
}

variable "deployment_stage_id" {
  description = "Stage controlling this service's place in the deployment pipeline."
  type        = string
}

variable "name" {
  description = "Qovery application name."
  type        = string
}

variable "repository_url" {
  description = "Git repository containing the monorepo."
  type        = string
}

variable "branch" {
  description = "Branch deployed by Qovery."
  type        = string
  default     = "main"
}

variable "dockerfile_path" {
  description = "Dockerfile path relative to the repository root."
  type        = string
}

variable "match_paths" {
  description = "Paths that may trigger this application deployment."
  type        = set(string)
}

variable "internal_port" {
  description = "HTTP port exposed by the application."
  type        = number
}

variable "publicly_accessible" {
  description = "Whether Qovery creates a public endpoint."
  type        = bool
  default     = false
}
