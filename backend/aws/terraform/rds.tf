# RDS PostgreSQL
resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.app_name}-db-subnet-group"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.app_name}-db"
  engine                  = "aurora-postgresql"
  engine_version          = "15.3"
  database_name           = "alumns_db"
  master_username         = "alumns_user"
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.app_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  backup_retention_period      = 7
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "sun:04:00-sun:05:00"
  
  enabled_cloudwatch_logs_exports = ["postgresql"]
  
  storage_encrypted = true

  tags = {
    Name = "${var.app_name}-db-cluster"
  }
}

resource "aws_rds_cluster_instance" "main" {
  count              = 2
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  publicly_accessible = false

  monitoring_interval    = 60
  monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
  performance_insights_enabled = true

  tags = {
    Name = "${var.app_name}-db-instance-${count.index + 1}"
  }
}
