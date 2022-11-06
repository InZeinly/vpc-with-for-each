output "codebuild_project_name" {
  value = aws_codebuild_project.democodebuild.name
}

output "repo_url" {
  value = var.repo_url
}

output "priv_subnet" {
  value = var.private_subnet_id
}

output "COMMIT_MESSAGE" {
  value = var.COMMIT_MESSAGE
}