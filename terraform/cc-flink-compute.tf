resource "confluent_flink_compute_pool" "main" {
  display_name = "acme_compute_pool"
  cloud        = "AWS"
  region       = "us-east-2"#"eu-central-1"
  max_cfu      = 5

  environment {
    id = confluent_environment.acme_env.id
  }
}
