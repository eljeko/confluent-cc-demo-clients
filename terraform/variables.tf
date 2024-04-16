locals {
    env_name = "basic-demo-workshop"
    cluster_name = "demo-basic-cluster"
    description = "Resource created for 'Simple Basic Cluster Workshop"
}


variable "confluent_cloud_api_key" {
  default = "KEY"
}
variable "confluent_cloud_api_secret" {
  default = "SECRET"
}