data "qovery_environment" "staging" {
  id = var.environment_id
}

locals {
  application_match_paths = {
    api_gateway = ["apps/api-gateway/", "packages/contracts/", "packages/logger/", "pnpm-lock.yaml"]
    orders      = ["apps/orders/", "packages/contracts/", "packages/logger/", "pnpm-lock.yaml"]
    payments    = ["apps/payments/", "packages/contracts/", "packages/logger/", "pnpm-lock.yaml"]
    web         = ["apps/web/", "packages/contracts/", "pnpm-lock.yaml"]
  }

  migration_match_paths = {
    orders   = ["apps/orders/migrations/", "apps/orders/Dockerfile", "pnpm-lock.yaml"]
    payments = ["apps/payments/migrations/", "apps/payments/Dockerfile", "pnpm-lock.yaml"]
  }
}

# Pipeline order: databases -> migrations -> core-services -> edge
resource "qovery_deployment_stage" "databases" {
  environment_id = data.qovery_environment.staging.id
  name           = "databases"
  description    = "Service-owned PostgreSQL databases"
}

resource "qovery_deployment_stage" "migrations" {
  environment_id = data.qovery_environment.staging.id
  name           = "migrations"
  description    = "Schema migrations run by lifecycle jobs"
  is_after       = qovery_deployment_stage.databases.id
}

resource "qovery_deployment_stage" "core_services" {
  environment_id = data.qovery_environment.staging.id
  name           = "core-services"
  description    = "Independent domain services deploy in parallel"
  is_after       = qovery_deployment_stage.migrations.id
}

resource "qovery_deployment_stage" "edge" {
  environment_id = data.qovery_environment.staging.id
  name           = "edge"
  description    = "Public gateway and web application"
  is_after       = qovery_deployment_stage.core_services.id
}

module "orders" {
  source = "../../modules/service"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.core_services.id
  name                = "orders"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/orders/Dockerfile"
  internal_port       = 8081
  match_paths         = local.application_match_paths.orders
}

module "payments" {
  source = "../../modules/service"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.core_services.id
  name                = "payments"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/payments/Dockerfile"
  internal_port       = 8082
  match_paths         = local.application_match_paths.payments
}

module "api_gateway" {
  source = "../../modules/service"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.edge.id
  name                = "api-gateway"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/api-gateway/Dockerfile"
  internal_port       = 8080
  publicly_accessible = true
  match_paths         = local.application_match_paths.api_gateway
}

module "web" {
  source = "../../modules/service"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.edge.id
  name                = "web"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/web/Dockerfile"
  internal_port       = 3000
  publicly_accessible = true
  match_paths         = local.application_match_paths.web
}

module "orders_migrations" {
  source = "../../modules/lifecycle-job"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.migrations.id
  name                = "orders-migrations"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/orders/Dockerfile"
  match_paths         = local.migration_match_paths.orders
}

module "payments_migrations" {
  source = "../../modules/lifecycle-job"

  environment_id      = data.qovery_environment.staging.id
  deployment_stage_id = qovery_deployment_stage.migrations.id
  name                = "payments-migrations"
  repository_url      = var.repository_url
  branch              = var.branch
  dockerfile_path     = "apps/payments/Dockerfile"
  match_paths         = local.migration_match_paths.payments
}
