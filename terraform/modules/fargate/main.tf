resource "aws_security_group" "allow_tls" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_security_group" "alb" {
  vpc_id = var.vpc-id

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

resource "aws_lb" "main" {
  name               = var.albname
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public-subnets
}

resource "aws_lb_target_group" "app1" {
  name     = "app1-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc-id
}

resource "aws_lb_target_group" "app2" {
  name     = "app2-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc-id
}

resource "aws_lb_listener" "app1" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }
}

resource "aws_lb_listener" "app2" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2.arn
  }
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster-name
}

resource "aws_ecs_task_definition" "app1" {
  family                   = "app1-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "app1",
    "image": "${var.docker_image_app1}",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_task_definition" "app2" {
  family                   = "app2-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "app2",
    "image": "${var.docker_image_app2}",
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "app1" {
  name            = "app1-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private-subnets
    security_groups  = [aws_security_group.allow_tls.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app1.arn
    container_name   = "app1"
    container_port   = 3000
  }
}

resource "aws_ecs_service" "app2" {
  name            = "app2-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app2.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private-subnets
    security_groups  = [aws_security_group.allow_tls.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app2.arn
    container_name   = "app2"
    container_port   = 5000
  }
}
