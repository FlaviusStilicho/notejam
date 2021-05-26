resource "aws_security_group" "db_ingress" {
  name = "ingress_notejame_${var.env}"
  description = "Allow inbound database connections"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_security_group_rule" "db_ingress_notejam" {
  security_group_id = aws_security_group.db_ingress.id

  from_port = 3306
  protocol = "tcp"
  to_port = 3306
  type = "ingress"
  source_security_group_id = data.aws_security_group.eks_cluster_security_group.id
}


//
//  ingress {
//    from_port = 3306
//    protocol = "tcp"
//    to_port = 3306
//
//    source_security_group_id =
//  }

