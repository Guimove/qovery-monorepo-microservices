resource "qovery_application" "this" {
  environment_id      = var.environment_id
  deployment_stage_id = var.deployment_stage_id
  name                = var.name

  git_repository = {
    url       = var.repository_url
    branch    = var.branch
    root_path = "/"
  }

  build_mode      = "DOCKER"
  dockerfile_path = var.dockerfile_path
  auto_deploy     = true
  auto_preview    = true

  cpu                   = 500
  memory                = 512
  min_running_instances = 1
  max_running_instances = 2

  ports = [{
    name                = "http"
    internal_port       = var.internal_port
    external_port       = 443
    publicly_accessible = var.publicly_accessible
    protocol            = "HTTP"
    is_default          = true
  }]

  healthchecks = {
    readiness_probe = {
      type = {
        http = {
          port   = var.internal_port
          path   = "/health"
          scheme = "HTTP"
        }
      }
      initial_delay_seconds = 5
      period_seconds        = 10
      timeout_seconds       = 5
      success_threshold     = 1
      failure_threshold     = 3
    }
  }

  environment_variables = [{
    key   = "SERVICE_NAME"
    value = var.name
  }]

  deployment_restrictions = [
    for path in var.match_paths : {
      mode  = "MATCH"
      type  = "PATH"
      value = path
    }
  ]
}
