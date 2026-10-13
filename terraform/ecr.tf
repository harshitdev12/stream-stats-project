# Repository for the Express OBS Overlay
resource "aws_ecr_repository" "frontend_repo" {
  name                 = "harxitgaming-overlay-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true 
  }
}

# Repository for the Flask Stats API
resource "aws_ecr_repository" "backend_repo" {
  name                 = "harxitgaming-overlay-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}