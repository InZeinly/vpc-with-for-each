output "oauth" {
  value = var.github_oauth_token
}

output "repo_url" {
    value = var.repo_url
}

output "app_count" {
  value = var.app_count
}



# output "private_subnet_id" {
#   value = values(aws_subnet.subnets_priv).*.id
# }