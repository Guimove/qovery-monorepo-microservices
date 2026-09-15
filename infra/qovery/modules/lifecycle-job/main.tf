resource "qovery_job" "this" {
  environment_id      = var.environment_id
  deployment_stage_id = var.deployment_stage_id
  name                = var.name

  cpu                  = 500
  memory               = 512
  max_duration_seconds = 600
  max_nb_restart       = 1

  schedule = {
    on_start = {
      entrypoint = "node"
      arguments  = ["dist/index.js", "migrate"]
    }
  }

  source = {
    docker = {
      dockerfile_path = var.dockerfile_path
      git_repository = {
        url       = var.repository_url
        branch    = var.branch
        root_path = "/"
      }
    }
  }

  healthchecks = {}

  deployment_restrictions = [
    for path in var.match_paths : {
      mode  = "MATCH"
      type  = "PATH"
      value = path
    }
  ]
}
