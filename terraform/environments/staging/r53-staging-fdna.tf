resource "aws_route53_zone" "staging_comp_com" {
  name = var.zone_comp_com
}


# --- A zone records ---
resource "aws_route53_record" "staging_a" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "staging.comp.com"
  type    = "A"
  ttl     = 300
  records = ["63.33.251.230"]
}

resource "aws_route53_record" "dm_test_a" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "dm-test.staging.comp.com"
  type    = "A"
  ttl     = 300
  records = ["54.217.145.93"]
}

#resource "aws_route53_record" "phbot_sql_a" {
#  zone_id = aws_route53_zone.staging_comp_com.id
#  name    = "phbot-sql.staging.comp.com"
#  type    = "A"
#  ttl     = 300
#  records = ["34.107.123.40"]
#}


# --- NS zone records ---
resource "aws_route53_record" "staging_ns" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "staging.comp.com"
  type    = "NS"
  ttl     = 172800
  records = [
    "ns-2005.awsdns-58.co.uk.",
    "ns-337.awsdns-42.com.",
    "ns-1042.awsdns-02.org.",
    "ns-671.awsdns-19.net."
  ]
}


# --- SOA zone records ---
resource "aws_route53_record" "staging_soa" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "staging.comp.com"
  type    = "SOA"
  ttl     = 900
  records = [
    "ns-2005.awsdns-58.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}


# --- ALIAS zone records ---
resource "aws_route53_record" "md_alias" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "md.staging.comp.com"
  type    = "A"

  alias {
    name                   = "aff36662a5bdf4398967eb498e5d8068-7dd24ab7239f1eed.elb.us-east-1.amazonaws.com"
    zone_id                = "Z26RNL4JYFTOTI"
    evaluate_target_health = true
  }
}


# --- CNAME zone records ---
resource "aws_route53_record" "acm_validations_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "_2a62485e0a1630236264f5364a10e8ff.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_4c57c778bc0401ceb1cb8fbdad58fb17.njdczhxdjc.acm-validations.aws."]
}

resource "aws_route53_record" "api_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "api.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "apicor_item_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "apicor_item.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["d-h7nog2v9jb.execute-api.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "apigate_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "apigate.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["d-ts1ur7peja.execute-api.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "app_dr_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "app-dr.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["a6db6e43e801a42b494ecaaac89dfa7c-d086c726cffb42a1.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "app_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "app.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "cognito_cor_item_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "cognito-cor_item.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["d21o406s75djzk.cloudfront.net"]
}

resource "aws_route53_record" "cognito_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "cognito.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["d3e206zv7u4izv.cloudfront.net"]
}

resource "aws_route53_record" "cert_validation_duplicate_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "_2a62485e0a1630236264f5364a10e8ff.staging.comp.com.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_4c57c778bc0401ceb1cb8fbdad58fb17.njdczhxdjc.acm-validations.aws."]
}

resource "aws_route53_record" "cor_item_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "cor_item.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "grafana_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "grafana.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "jenkins_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "jenkins.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["internal-jenkins-new-1646193095.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "konga_phbot_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "konga-phbot.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "konga_sandbox_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "konga-sandbox.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "metabase_phbot_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "metabase-phbot.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "nexus_elb_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "nexus-elb.staging.comp.com"
  type    = "CNAME"
  ttl     = 120
  records = ["nexus-repo-753871032.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "phbot_api_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "phbot-api.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "phbot_doc_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "phbot-doc.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "phbot_sandbox_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "phbot-sandbox.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "phbot_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "phbot.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "rabbitmq_dashboard_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "rabbitmq-dashboard-phbot.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "solutions_sandbox_api_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "solutions-sandbox-api.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "requisitions_api_cname" {
  zone_id = aws_route53_zone.staging_comp_com.id
  name    = "requisitions-api.staging.comp.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ad0f13f69e62146c29f17268f2ab6de5-bc84addc917a2677.elb.eu-west-1.amazonaws.com"]
}
