#Create a separate zone for Amplify routes
module "zone" {
  source           = "cloudposse/route53-cluster-zone/aws"
  version          = "0.15.0"
  name             = "demo"
  parent_zone_name = var.domain
  zone_name        = "$${name}.$${parent_zone_name}"
}

#Create a Amplify App
resource "aws_amplify_app" "app" {
  name         = "Demo"
  description  = "Demo App"
  repository   = var.repository
  access_token = var.access_token

  #Build Settings
  build_spec = <<-EOT
    version: 1
    frontend:
        phases:
          preBuild:
            commands:
              - npm config set registry https://npm.pkg.github.com
              //Add custom NPM_TOKEN line here.
              - npm config set always-auth true
              - yarn install
              //Add DEV Encrption key here.
              - yarn decrypt:env --confirm
          build:
            commands:
              - yarn run build
        artifacts:
          baseDirectory: build
          files:
            - '**/*'
        cache:
          paths:
            - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
  # Redirects for Single Page Web Apps (SPA)
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  environment_variables = var.global_variables #Global Environment Variables, define a map in .tfvars

  enable_auto_branch_creation = true
  enable_branch_auto_deletion = true

  auto_branch_creation_patterns = [
    "test*"
  ]

  auto_branch_creation_config {
    enable_auto_build = true
  }
}

#Main Branch creation and domain association
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.app.id
  branch_name = "main"
}

resource "aws_amplify_domain_association" "main" {
  app_id      = aws_amplify_app.app.id
  domain_name = module.zone.zone_name

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }
}