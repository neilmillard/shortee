resource "aws_iam_role" "lambda_role" {
  name               = "${module.label.id}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role_main_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_role_main_policy.arn
}

resource "aws_iam_policy" "lambda_role_main_policy" {
  name   = "${module.label.id}-lambda-main-policy"
  policy = data.aws_iam_policy_document.lambda_role_main_policy.json
}

data "aws_iam_policy_document" "lambda_role_main_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:eu-west-2:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
      actions = [
        "dynamodb:DescribeTable",
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
      ]
      resources = [
        aws_dynamodb_table.short_url.arn,
      ]
    }

    statement {
      actions = [
        "dynamodb:UpdateItem",
        "dynamodb:Query",
      ]
      resources = [
        aws_dynamodb_table.short_url.arn
      ]
    }

    statement {
      actions = [
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:DescribeStream",
        "dynamodb:ListStreams",

      ]
      resources = [
        aws_dynamodb_table.short_url.stream_arn,
      ]
    }

    statement {
      actions = [
        "lambda:ListFunctions",
      ]

      resources = ["*"]
    }

    statement {
      actions = [
        "lambda:DeleteFunction",
      ]

      resources = ["arn:aws:lambda:eu-west-2:${data.aws_caller_identity.current.account_id}:function:*"]
    }
}
