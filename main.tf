provider "aws" {}

resource "random_password" "serverless_postgres_master_pwd" {
  length  = 16
  special = false
}

resource "aws_rds_cluster" "serverless_postgres" {
  cluster_identifier   = "io-viljami-serverless-postgres"
  engine               = "aurora-postgresql"
  engine_mode          = "serverless"
  enable_http_endpoint = true
  master_username      = "postgres"
  master_password      = random_password.serverless_postgres_master_pwd.result
  scaling_configuration {
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
  backup_retention_period = 5
  skip_final_snapshot     = true
  copy_tags_to_snapshot   = true
  apply_immediately       = true
}

resource "aws_secretsmanager_secret" "serverless_postgres_master_secret" {
  name = "aurora_postgres_master"
}

resource "aws_secretsmanager_secret_version" "serverless_postgres_master_secret" {
  secret_id = aws_secretsmanager_secret.serverless_postgres_master_secret.id
  secret_string = jsonencode({
    "username"            = aws_rds_cluster.serverless_postgres.master_username
    "password"            = random_password.serverless_postgres_master_pwd.result
    "engine"              = "postgres"
    "host"                = aws_rds_cluster.serverless_postgres.endpoint
    "port"                = aws_rds_cluster.serverless_postgres.port
    "dbClusterIdentifier" = aws_rds_cluster.serverless_postgres.id
  })
}
