# --------------------------------------------------------
# Schema Registry
# --------------------------------------------------------
/**
data "confluent_schema_registry_region" "simple_sr_region" {
    cloud = "AWS"
    region = "eu-central-1"
    package = "ADVANCED" 
}
**/


data "confluent_schema_registry_cluster" "simple_sr_cluster" {
    environment {
        id = confluent_environment.acme_env.id 
    }
    depends_on = [ confluent_kafka_cluster.acme_cluster
    
     ]
}