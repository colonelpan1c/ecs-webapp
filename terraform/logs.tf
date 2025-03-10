# logs.tf

# CloudWatch group and log stream with retention of 30 days
resource "aws_cloudwatch_log_group" "ethereum_log_group" {
  name              = "/ecs/ethereum-app"
  retention_in_days = 30

  tags = {
    Name = "ethereum-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "ethereum_log_stream" {
  name           = "ethereum-log-stream"
  log_group_name = aws_cloudwatch_log_group.ethereum_log_group.name
}