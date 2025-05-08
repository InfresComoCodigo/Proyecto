resource "aws_scheduler_schedule" "lambda_trigger" {
  name       = "lambda-eventbridge-schedule"
  group_name = "default"

  schedule_expression = var.schedule_expression

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_arn
    role_arn = aws_iam_role.scheduler_invoke_lambda.arn

    input = jsonencode({
      source = "eventbridge"
      message = "Scheduled trigger"
    })
  }
}

resource "aws_iam_role" "scheduler_invoke_lambda" {
  name = "scheduler-invoke-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "scheduler.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "invoke_lambda_policy" {
  name = "allow-invoke-lambda"
  role = aws_iam_role.scheduler_invoke_lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "lambda:InvokeFunction",
      Resource = var.lambda_arn
    }]
  })
}