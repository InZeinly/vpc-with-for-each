data "aws_region" "current" {}

resource "aws_security_group" "codebuild_sg" {
  name = "allow_vpc"
  description = "codebuild connectivity within vpc"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_codebuild_source_credential" "gitcred" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = var.github_oauth_token
  
}

resource "aws_codebuild_project" "democodebuild" {
  name = "codebuilddemo"
  description = " demo project with codebuild"
  build_timeout = "120"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:4.0"
        type = "LINUX_CONTAINER"
        privileged_mode = true

        environment_variable {
          name = "CI"
          value = "true"
        }
    }

    source {
        buildspec = var.build_spec_file
        type = "GITHUB"
        location = var.repo_url
        git_clone_depth = 1
        report_build_status = "true"
    }

    vpc_config {
        vpc_id = var.vpc_id
        subnets = var.private_subnet_id

        security_group_ids = [ aws_security_group.codebuild_sg.id ]
    }
}

resource "aws_codebuild_webhook" "dev_webhook" {
    project_name = aws_codebuild_project.democodebuild.name

    filter_group {
        filter {
            type = "EVENT"
            pattern = "PUSH"
          
        }

        filter {
            type = "COMMIT_MESSAGE"
            pattern = "(test)$"
        }
    }
}