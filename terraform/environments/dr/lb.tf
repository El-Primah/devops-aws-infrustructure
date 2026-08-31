resource "aws_lb" "lb_meme" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.security_groups["lb_meme_gateway"].id]
  subnets            = [
    module.vpc.subnets["public1"].id,
    module.vpc.subnets["private2"].id
  ]

  enable_deletion_protection = false

  tags = {
    Environment       = var.environment
    Terraform_managed = true
  }
  
  depends_on   = [
    module.eks
  ]
}

# listeners
resource "aws_lb_listener" "listener_https_443" {
  load_balancer_arn = aws_lb.lb_meme.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = "arn:aws:acm:eu-central-1:101010101010:certificate/d60640c9-4319-4bf9-adf0-3ff481f577a4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_https_443.arn
    
    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.tg_https_443.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "listener_http_80" {
  load_balancer_arn = aws_lb.lb_meme.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_http_80.arn
    
    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.tg_http_80.arn
        weight = 1
      }
    }
  }
}

# target groups
resource "aws_lb_target_group" "tg_https_443" {
  name     = var.tg_https_443
  port     = var.tg_https_443_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
	health_check {
		enabled             = true
		healthy_threshold   = 5
		interval            = 30
		matcher             = "200"
		path                = "/"
		port                = "traffic-port"
		protocol            = "HTTP"
		timeout             = 5
		unhealthy_threshold = 2
	}
	
	stickiness {
		cookie_duration = 86400
		enabled         = false
		type            = "lb_cookie"
	}

 target_group_health {
		dns_failover {
			minimum_healthy_targets_count      = "1"
			minimum_healthy_targets_percentage = "off"
		}
		unhealthy_state_routing {
			minimum_healthy_targets_count      = 1
			minimum_healthy_targets_percentage = "off"
		}
	}
}

resource "aws_lb_target_group" "tg_http_80" {
  name     = var.tg_http_80
  port     = var.tg_http_80_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
	health_check {
		enabled             = true
		healthy_threshold   = 5
		interval            = 30
		matcher             = "301"
		path                = "/"
		port                = "traffic-port"
		protocol            = "HTTP"
		timeout             = 5
		unhealthy_threshold = 2
	}
	
	stickiness {
		cookie_duration = 86400
		enabled         = false
		type            = "lb_cookie"
	}

 target_group_health {
		dns_failover {
			minimum_healthy_targets_count      = "1"
			minimum_healthy_targets_percentage = "off"
		}
		unhealthy_state_routing {
			minimum_healthy_targets_count      = 1
			minimum_healthy_targets_percentage = "off"
		}
	}
}

# target attachment
resource "aws_autoscaling_attachment" "tg_https_443_attach" {
  autoscaling_group_name = module.eks.node_group_asg_names["default"]
  lb_target_group_arn    = aws_lb_target_group.tg_https_443.arn
  
  depends_on   = [
    module.eks
  ]
}

resource "aws_autoscaling_attachment" "tg_http_80_attach" {
  autoscaling_group_name = module.eks.node_group_asg_names["default"]
  lb_target_group_arn    = aws_lb_target_group.tg_http_80.arn
  
  depends_on   = [
    module.eks
  ]
}

