resource "aws_cloudwatch_log_group" "pipes" {
  name              = "/${var.infra_name}-devops-${var.env_name}/infra"
}
resource "aws_cloudwatch_log_stream" "pipelog" {
  name           = "${local.infra_env}-pipes"
  log_group_name = aws_cloudwatch_log_group.pipes.name
}
