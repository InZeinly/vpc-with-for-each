resource "aws_ecr_repository" "test_repo" {
  name                 = "testapp-testenv"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# added 12.11

resource "aws_ecr_repository_policy" "test_repo" {
  repository = aws_ecr_repository.test_repo.name
  policy     = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          “ecr:GetAuthorizationToken”,
          “ecr:GetRepositoryPolicy”,
          “ecr:DescribeRepositories”,
          “ecr:ListImages”,
          “ecr:DescribeImages”
        ]
      }
    ]
}
EOF
}