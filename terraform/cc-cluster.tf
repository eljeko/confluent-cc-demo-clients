# --------------------------------------------------------
# Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "acme_cluster" {
  display_name = local.cluster_name
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2" #"eu-central-1"
  basic {}
  environment {
    id = confluent_environment.acme_env.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.acme_cluster.id
  }
  topic_name    = "orders"
  rest_endpoint = confluent_kafka_cluster.acme_cluster.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }




}

resource "confluent_kafka_topic" "click_stream_users" {
  kafka_cluster {
    id = confluent_kafka_cluster.acme_cluster.id
  }
  topic_name    = "click_stream_users"
  rest_endpoint = confluent_kafka_cluster.acme_cluster.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "click_stream" {
  kafka_cluster {
    id = confluent_kafka_cluster.acme_cluster.id
  }
  topic_name    = "click_stream"
  rest_endpoint = confluent_kafka_cluster.acme_cluster.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "click_stream_codes" {
  kafka_cluster {
    id = confluent_kafka_cluster.acme_cluster.id
  }
  topic_name    = "click_stream_codes"
  rest_endpoint = confluent_kafka_cluster.acme_cluster.rest_endpoint

  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
