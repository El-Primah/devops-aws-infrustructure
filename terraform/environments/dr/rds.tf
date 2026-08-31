resource "aws_db_instance" "restored_db" {
  #count = 0
  identifier              = var.snapshot_restored_db_name
  snapshot_identifier     = var.snapshot_arn
  skip_final_snapshot     = true
  instance_class          = "db.m5.large"
  allocated_storage       = 504
  db_subnet_group_name    = aws_db_subnet_group.new_subnet_group.name
  vpc_security_group_ids  = [module.vpc.security_groups["allow_all_internal"].id]
  kms_key_id              = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/85253d7b-482e-4901-9972-f6a58b59f822" # alias/aws/rds

  iam_database_authentication_enabled = true

  storage_encrypted       = true
  publicly_accessible     = false
  multi_az                = false
  storage_type            = "gp3"
  #parameter_group_name   = "param-group"

  tags = {
    From = "prod"
  }
}

resource "aws_db_subnet_group" "new_subnet_group" {
  name       = var.restored_db_new_subnet_group_name
  subnet_ids = [module.vpc.subnets["public1"].id, module.vpc.subnets["public2"].id, module.vpc.subnets["private1"].id, module.vpc.subnets["private2"].id]

  tags = {
    Name = "DR DB subnet group"
  }
}
