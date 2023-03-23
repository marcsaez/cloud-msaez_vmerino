/*+++++++++++++++++++++++++++++++++++++++++++++++++++
  CONFIGURACIÓ DE CADA INSTANCIA + AUTOSCALING GROUP
++++++++++++++++++++++++++++++++++++++++++++++++++++*/

# Plantilla EC2
resource "aws_launch_configuration" "main" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.id]
  user_data_base64 = base64encode(data.template_file.cloud-init-config.rendered)
  
  lifecycle {
    create_before_destroy = true
  }
}

# AUTO ESCALING
resource "aws_autoscaling_group" "main" {
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size = 2
  max_size = 10
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}


# SECURITY GROUP
resource "aws_security_group" "instances" {
  name = "instances"
  egress {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
 
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "SSH connection"
      from_port        = 22
      protocol         = "tcp"
      security_groups  = []
      to_port          = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
   },
   {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "HTTP connection"
      from_port        = 80
      protocol         = "tcp"
      security_groups  = []
      to_port          = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
   }
   ]
}


# SECURITY GROUP LOAD BALANCER
resource "aws_security_group" "alb" {
  name = "terraform-alb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*+++++++++++++++++++++++++++++++++++++++++
  CONFIGURACIÓ DE APLICATION LOAD BALANCER |
+++++++++++++++++++++++++++++++++++++++++++*/

# LOAD BALANCER
resource "aws_lb" "example" {
  name               = "terraform-asg"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}