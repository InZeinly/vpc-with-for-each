output "iam_role" {
  value = aws_iam_role.TaskExecRole.id
}

output "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}