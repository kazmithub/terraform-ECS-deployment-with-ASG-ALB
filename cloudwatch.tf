# CloudWatch Container Insights
# Provides detailed monitoring for ECS clusters

resource "aws_ecs_cluster_capacity_providers" "insights" {
  cluster_name = var.cluster_name

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

# Enable Container Insights on the ECS cluster
resource "aws_ecs_cluster" "with_insights" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# CloudWatch alarms for ECS service
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.service_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "ECS service CPU utilization is too high"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }
}
