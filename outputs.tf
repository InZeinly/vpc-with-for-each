output "oauth" {
  value = var.github_oauth_token
}

output "repo_url" {
    value = var.repo_url
}

output "app_count" {
  value = var.app_count
}

output "vpc_id" {
  value = module.vpc.vpc_id
  }