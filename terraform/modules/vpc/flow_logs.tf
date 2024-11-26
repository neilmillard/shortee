resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_iam_role.arn
  log_destination = aws_cloudwatch_log_group.cloudwatch_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
  tags            = var.tags
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "${var.name}-flow-log-${aws_vpc.vpc.id}"
  retention_in_days = var.retention_in_days
  tags              = var.tags
}

resource "aws_iam_role" "flow_log_iam_role" {
  name = "${var.name}-flow-log-role"
  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name = "${var.name}-flow-log-iam-role-policy-${aws_vpc.vpc.id}"
  role = aws_iam_role.flow_log_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
