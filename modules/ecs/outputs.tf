output "iam_role" {
  value = aws_iam_role.TaskExecRole.id
}

output "app_count" {
  value = var.app_count
}
