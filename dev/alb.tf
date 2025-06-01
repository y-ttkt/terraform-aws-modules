resource "aws_lb" "app" {
  name            = "${local.project}-${local.env}-app"
  internal        = false # 公開型 ALB
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public[*].id # パブリックサブネット群

  tags = {
    Name = "${local.project}-${local.env}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${local.project}-${local.env}-app"
  target_type = "instance" # EC2 インスタンスをターゲットにする
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/" # アプリの空応答でもOKなパス
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.app
  ]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app.id
  port             = 80
}
