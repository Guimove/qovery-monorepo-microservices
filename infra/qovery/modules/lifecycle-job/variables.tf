variable "environment_id" {
  description = "Qovery environment UUID."
  type        = string
}

variable "deployment_stage_id" {
  description = "Migration stage UUID."
  type        = string
}

variable "name" {
  description = "Qovery lifecycle job name."
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
  description = "Paths that may trigger this migration job."
  type        = set(string)
}
