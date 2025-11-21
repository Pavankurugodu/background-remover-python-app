terraform {
  backend "s3" {
    bucket         = "<bucket-name>"
    key            = "${var.environment}/terraform.tfstate"
    region         = var.aws_region
    use_lockfile = true
    versioning_configuration {
      status = "Enabled"
    }
  }
}
