resource "confluent_flink_compute_pool" "main" {
  display_name = "acme_compute_pool"
  cloud        = "AWS"
  region       = "${local.cc_region}"
  max_cfu      = 5

  environment {
    id = confluent_environment.acme_env.id
  }
}
