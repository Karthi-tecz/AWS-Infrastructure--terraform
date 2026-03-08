# SNS Topic
resource "aws_sns_topic" "notifications" {
  name = "${var.environment}-notifications"

  tags = {
    Name = "${var.environment}-sns-topic"
  }
}

# SQS Queue
resource "aws_sqs_queue" "main" {
  name                      = "${var.environment}-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Name = "${var.environment}-sqs-queue"
  }
}

# SQS Dead Letter Queue
resource "aws_sqs_queue" "dlq" {
  name = "${var.environment}-dlq"

  tags = {
    Name = "${var.environment}-dlq"
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda Policy
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.environment}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "cloudwatch:PutMetricData",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach AWS managed policy for VPC access
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "processor" {
  filename         = "lambda_function.zip"
  function_name    = "${var.environment}-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"
  timeout         = 60

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.notifications.arn
      SQS_QUEUE_URL = aws_sqs_queue.main.url
    }
  }

  tags = {
    Name = "${var.environment}-lambda-processor"
  }
}

# Lambda Security Group
resource "aws_security_group" "lambda" {
  name_prefix = "${var.environment}-lambda-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-lambda-sg"
  }
}

# Lambda Source Code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_function.zip"
  source {
    content = templatefile("${path.module}/lambda_function.py", {
      sns_topic_arn = aws_sns_topic.notifications.arn
      sqs_queue_url = aws_sqs_queue.main.url
    })
    filename = "index.py"
  }
}

# CloudWatch Event Rule to trigger Lambda
resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "${var.environment}-lambda-trigger"
  description         = "Trigger Lambda function"
  schedule_expression = "rate(5 minutes)"
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "TargetId1"
  arn       = aws_lambda_function.processor.arn
}

# Lambda Permission for CloudWatch Events
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}

# SNS Subscription for Email
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "email"
  endpoint  = "admin@techhodude.co.in"
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.processor.function_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.environment}-lambda-logs"
  }
}
