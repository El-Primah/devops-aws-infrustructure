resource "aws_opensearch_domain" "comp_y_app_resources_dr" {
  domain_name    = "comp-y_app-resources-dr"
  engine_version = "Elasticsearch_5.5"

  cluster_config {
    instance_type          = "t2.medium.search"
    instance_count         = 2
    zone_awareness_enabled = false # 1-AZ, without standby
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 15
  }

  node_to_node_encryption {
    enabled = false
  }

  domain_endpoint_options {
    enforce_https = false
  }

  vpc_options {
    security_group_ids = [module.vpc.security_groups["allow_all_internal"].id]
    subnet_ids         = [module.vpc.subnets["private1"].id]
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/comp-y_app-resources-dr/*"
    }
  ]
}
POLICY
}

