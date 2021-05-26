resource "aws_db_instance" "notejam-db" {

  identifier                  = var.db_identifier
  engine                      = "mysql"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  name                        = "notejam"
  username                    = var.db_user
  password                    = var.db_pass
  parameter_group_name        = "default.mysql5.7"
  option_group_name           = "default:mysql-5-7"
  auto_minor_version_upgrade  = true
  skip_final_snapshot         = true
  db_subnet_group_name        = var.db_subnet_group_name

  allocated_storage           = 10
  max_allocated_storage       = 100

  // other useful properties for ensuring availability and security:
  //  backup_retention_period = 14
  //  copy_tags_to_snapshot = true
  //  multi_az = true
  //  deletion_protection = true
  //  allow_major_version_upgrade = true
  //  maintenance_window = "Mon:00:00-Mon:03:00"
  //  monitoring_role_arn = ...
  //  storage_encrypted = true
  //  kms_key_id = ...
  //  enabled_cloudwatch_logs_exports = ["audit"]
}