resource "aws_ecr_repository" "aws-template" {
  name                 = "${var.project_name}-${var.env}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    env  = "${var.env}"
    name = "${var.project_name}-${var.env}-ecr"
  }
}
