output "build" {
  /*value = {
    R_01_app_manager_kafka_cluster_key_KEY       = confluent_api_key.app_manager_kafka_cluster_key.id,
    R_01_app_manager_kafka_cluster_key_SECRET    = nonsensitive(confluent_api_key.app_manager_kafka_cluster_key.secret),

    R_02_sr_cluster_key_KEY                      = confluent_api_key.sr_cluster_key.id,
    R_02_sr_cluster_key_SECRET                   = nonsensitive(confluent_api_key.sr_cluster_key.secret),
    
    R_03_clients_kafka_cluster_key_KEY           = confluent_api_key.clients_kafka_cluster_key.id,
    R_03_clients_kafka_cluster_key_SECRET        = nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret),
    
    R_04_____cluster_url                         = confluent_kafka_cluster.acme_cluster.bootstrap_endpoint
  }*/

  value = <<-EOT

  ########################################
  #   Confluent Cloud Setup Info         #
  ########################################

  Environment ID: ${confluent_environment.acme_env.id}
  
  Kafka Cluster
  ID: ${confluent_kafka_cluster.acme_cluster.id}
  Bootstrap URL: ${confluent_kafka_cluster.acme_cluster.bootstrap_endpoint}
     Topic name: [${confluent_kafka_topic.orders.topic_name}]

  Flink pool
  ID: ${confluent_flink_compute_pool.main.id}
  Kind: ${confluent_flink_compute_pool.main.kind}

  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):

  ${confluent_service_account.app_manager.display_name}
       SA ID: ${confluent_service_account.app_manager.id}
     API Key: "${confluent_api_key.app_manager_kafka_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.app_manager_kafka_cluster_key.secret)}"

  ${confluent_service_account.sr.display_name} 
       SA ID: ${confluent_service_account.sr.id}
     API Key: "${confluent_api_key.sr_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.sr_cluster_key.secret)}"

  ${confluent_service_account.clients.display_name}
       SA ID: ${confluent_service_account.clients.id}
     API Key: "${confluent_api_key.clients_kafka_cluster_key.id}"
  API Secret: "${nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret)}"

  Client Setup (you may need to remove SASL_SSL:// from bootstrap.server):

  bootstrap.servers=${confluent_kafka_cluster.acme_cluster.bootstrap_endpoint}
  security.protocol=SASL_SSL
  sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='${confluent_api_key.clients_kafka_cluster_key.id}' password='${nonsensitive(confluent_api_key.clients_kafka_cluster_key.secret)}';
  sasl.mechanism=PLAIN
  
  Schema Registry Client Setup:

  schema.registry.url=${confluent_schema_registry_cluster.simple_sr_cluster.rest_endpoint}
  basic.auth.credentials.source=USER_INFO
  basic.auth.user.info=${confluent_api_key.sr_cluster_key.id}:${nonsensitive(confluent_api_key.sr_cluster_key.secret)}


  EOT

}
