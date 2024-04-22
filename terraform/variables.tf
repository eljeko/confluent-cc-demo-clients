locals {
    env_name = "acme-prod"
    cluster_name = "acme-cluster"
    description = "Resource created for 'Simple Basic Cluster Workshop"
}


variable "confluent_cloud_api_key" {
  default = "KEY"
}
variable "confluent_cloud_api_secret" {
  default = "SECRET"
}