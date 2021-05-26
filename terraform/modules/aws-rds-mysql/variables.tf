variable "env" {
  description = "Name of the environment"
}

variable "db_identifier" {
  description = "Name of the database"
}

variable "engine_version" {
  description = "Major engine version used for MySQL"
}

variable "instance_class" {
  description = "Instance class used for the database"
}

variable "db_user" {
  description = "Name of the default user created for the database"
}

variable "db_pass" {
  description = "Name of the password created for the database user. Change it afterwards!"
}

variable "db_subnet_group_name" {
  description =  "Name of the DB subnet group"
}
