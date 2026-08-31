resource "aws_route53_zone" "us_f_item_com" {
  name    = "us.f_item.com"
  comment = "Managed by Terraform"
}


# --- A zone records ---
resource "aws_route53_record" "us_dfg_bastion_a" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "bastion.us.f_item.com"
  type    = "A"
  ttl     = 300
  records = ["3.81.209.145"]
}


# --- NS zone records ---
resource "aws_route53_record" "us_dfg_ns" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "us.f_item.com"
  type    = "NS"
  ttl     = 172800
  records = [
    "ns-369.awsdns-46.com.",
    "ns-1179.awsdns-19.org.",
    "ns-1606.awsdns-08.co.uk.",
    "ns-613.awsdns-12.net."
  ]
}


# --- SOA zone records ---
resource "aws_route53_record" "us_dfg_soa" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "us.f_item.com"
  type    = "SOA"
  ttl     = 900
  records = [
    "ns-369.awsdns-46.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}


# --- CNAME zone records ---
resource "aws_route53_record" "us_dfg__6411f0fe5e6b406d60b963a37dd31125_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "_6411f0fe5e6b406d60b963a37dd31125.us.f_item.com"
  type    = "CNAME"
  ttl     = 300
  records = ["_9cc62b9fc7f9c245d8624e0ba641dd8b.qhdymdbmnz.acm-validations.aws."]
}

resource "aws_route53_record" "us_dfg_alertmanager_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "alertmanager.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["afeed89c2d7244f06841a4d9c6d24bf1-620033641.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_app_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "app.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["meme-gateway-us-1577424448.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_beanstalk_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "beanstalk.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["afeed89c2d7244f06841a4d9c6d24bf1-620033641.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_dashboard_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "dashboard.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["admin-dashboard-us-1714416588.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_grafana_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "grafana.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["afeed89c2d7244f06841a4d9c6d24bf1-620033641.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_kibana_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "kibana.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["afeed89c2d7244f06841a4d9c6d24bf1-620033641.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_prometheus_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "prometheus.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["a4a372ff0258a44a89d97132a44dc37b-2131761393.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "us_dfg_rabbitmq_dashboard_cname" {
  zone_id = aws_route53_zone.us_f_item_com.id
  name    = "rabbitmq-dashboard.us.f_item.com"
  type    = "CNAME"
  ttl     = 120
  records = ["afeed89c2d7244f06841a4d9c6d24bf1-620033641.us-east-1.elb.amazonaws.com"]
}