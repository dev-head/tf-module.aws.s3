data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#-{define locals and additional data as needed}-#
locals {
  active_buckets  = { for key,value in var.buckets : key => value if value["enabled"] == true }
}