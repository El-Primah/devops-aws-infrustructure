resource "aws_route53_zone" "staging_f_item_com" {
  name    = var.zone_f_item_com
}


# --- A zone records ---
resource "aws_route53_record" "dfg_beanstalk_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "beanstalk.staging.f_item.com"
  type    = "A"

  alias {
    name                   = "dualstack.beanstalk-staging-692399835.eu-west-1.elb.amazonaws.com"
    zone_id                = "Z32O12XQLNTSW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dfg_consumer_test_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "consumer-test.staging.f_item.com"
  type    = "A"

  alias {
    name                   = "abcea327c717741d3a751ab71953b9bd-259871077.eu-west-1.elb.amazonaws.com"
    zone_id                = "Z32O12XQLNTSW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dfg_meme_talk_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "meme-talk.staging.f_item.com"
  type    = "A"

  alias {
    name                   = "a638bad59dc9842f08eeca0591ce978c-1190708459.eu-west-1.elb.amazonaws.com"
    zone_id                = "Z32O12XQLNTSW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dfg_pki_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "pki.staging.f_item.com"
  type    = "A"

  alias {
    name                   = "a638bad59dc9842f08eeca0591ce978c-1190708459.eu-west-1.elb.amazonaws.com"
    zone_id                = "Z32O12XQLNTSW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "dfg_rabbitmq_dashboard_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "rabbitmq-dashboard.staging.f_item.com"
  type    = "A"

  alias {
    name                   = "dualstack.beanstalk-staging-692399835.eu-west-1.elb.amazonaws.com"
    zone_id                = "Z32O12XQLNTSW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dfg_staging_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "staging.f_item.com"
  type    = "A"

  alias {
    name                   = "staging.staging.f_item.com"
    zone_id                = aws_route53_zone.staging_f_item_com.id
    evaluate_target_health = false
  }
}


# --- NS zone records ---
resource "aws_route53_record" "dfg_staging_ns" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "staging.f_item.com"
  type    = "NS"
  ttl     = 172800
  records = [
    "ns-286.awsdns-35.com.",
    "ns-960.awsdns-56.net.",
    "ns-1299.awsdns-34.org.",
    "ns-1992.awsdns-57.co.uk."
  ]
}


# --- SOA zone records ---
resource "aws_route53_record" "dfg_staging_soa" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "staging.f_item.com"
  type    = "SOA"
  ttl     = 900
  records = [
    "ns-286.awsdns-35.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}


# --- TXT zone records ---
resource "aws_route53_record" "dfg_cname_test_txt" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "cname-test.staging.f_item.com"
  type    = "TXT"
  ttl     = 300
  records = ["heritage=external-dns,external-dns/owner=externaldns,external-dns/resource=ingress/dfg/production"]
}


# --- CNAME zone records ---
resource "aws_route53_record" "dfg_app_a" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "app.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["meme-waf-stage-1939768587.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_acm_validations_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "_f6b346ba9a96d7495d18f1ea0bfe23ab.staging.f_item.com"
  type    = "CNAME"
  ttl     = 60
  records = ["_cdf9ee8a23768824ca316e2404b4d461.tjxrvlrcqj.acm-validations.aws."]
}

resource "aws_route53_record" "dfg_alertmanager_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "alertmanager.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["ada41fcb9f14b4e71b898dc82bfd7aab-783253237.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_api_test_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "api-test.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["api-staging-nlb-17c597659177f87e.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_app_dr_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "app-dr.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["a113b985f1cce470c8ab501d653d8ed7-13991486.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_app_test_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "app-test.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["ada41fcb9f14b4e71b898dc82bfd7aab-783253237.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_app_sub_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "_1faec799a6f59404961ec135604a70c2.app.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_00babaae14d609014917a005cee34df9.czrmfnbpdk.acm-validations.aws."]
}

resource "aws_route53_record" "dfg_cognito_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "cognito.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["d3ik8o9q8np9gn.cloudfront.net"]
}

resource "aws_route53_record" "dfg_cognito_validation_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "_c15297a7a7598cb4c0d80a4a2080514f.cognito.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_8378d59edc3a3082115d503bf62977f8.kqlycvwlbp.acm-validations.aws"]
}

resource "aws_route53_record" "dfg_consumer_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "consumer.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["abcea327c717741d3a751ab71953b9bd-259871077.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_dashboard_dr_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "dashboard-dr.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["a113b985f1cce470c8ab501d653d8ed7-13991486.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_dashboard_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "dashboard.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["beanstalk-staging-692399835.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_data_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "data.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_gm_app_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "gm-app.staging.f_item.com"
  type    = "CNAME"
  ttl     = 86400
  records = ["ab390848a5cb14dec8551cfff31757fe-6fd079ceb683c8f5.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_gm_web_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "gm-web.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_grafana_dev_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "grafana-dev.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a638bad59dc9842f08eeca0591ce978c-1190708459.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_grafana_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "grafana.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_k8s_dashboard_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "k8s-dashboard.staging.f_item.com"
  type    = "CNAME"
  ttl     = 86400
  records = ["ab390848a5cb14dec8551cfff31757fe-6fd079ceb683c8f5.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_kibana_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "kibana.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_metabase_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "metabase.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["ada41fcb9f14b4e71b898dc82bfd7aab-783253237.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_nexus_test_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "nexus-test.staging.f_item.com"
  type    = "CNAME"
  ttl     = 60
  records = ["nexus-test-508172801.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_prometheus_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "prometheus.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["ada41fcb9f14b4e71b898dc82bfd7aab-783253237.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_rabbitmq_dashboard_test_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "rabbitmq-dashboard-test.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["ada41fcb9f14b4e71b898dc82bfd7aab-783253237.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_repo_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "repo.staging.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["a9cc695af0d1745f09b17c5ac6060698-1331008366.eu-west-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "dfg_research_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "research.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}

resource "aws_route53_record" "dfg_resource_cname" {
  zone_id = aws_route53_zone.staging_f_item_com.id
  name    = "resource.staging.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4dcb24bfe5b849ccb6809fd2bf06653-d0a0b209f235678d.elb.eu-west-1.amazonaws.com"]
}
