# AWS Secrets Manager
resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.app_name}/jwt_secret"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.app_name}-jwt-secret"
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = var.jwt_secret
}

resource "aws_secretsmanager_secret" "db_host" {
  name                    = "${var.app_name}/db_host"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.app_name}-db-host"
  }
}

resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = aws_rds_cluster.main.endpoint
}

resource "aws_secretsmanager_secret" "db_user" {
  name                    = "${var.app_name}/db_user"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.app_name}-db-user"
  }
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = aws_rds_cluster.main.master_username
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.app_name}/db_password"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.app_name}-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "db_name" {
  name                    = "${var.app_name}/db_name"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.app_name}-db-name"
  }
}

resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = aws_rds_cluster.main.database_name
}
