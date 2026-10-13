resource "aws_ecs_cluster" "overlay_cluster" {
  name = "stream-stats-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}