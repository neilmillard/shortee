resource "aws_security_group" "proxy_lambda_security_group" {
  vpc_id = module.vpc.vpc_id
}


resource "aws_security_group_rule" "build_and_deploy_lambda_https_egress" {
  security_group_id = aws_security_group.proxy_lambda_security_group.id
  from_port         = 443
  to_port           = 443
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
