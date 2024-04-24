#Main Cluster
BOOT_STRAP=`jq -r '.. | select(.bootstrap_endpoint?).bootstrap_endpoint' $1`

#Client API KEY
API_KEY=`jq -r '.. | select(.name?=="clients_kafka_cluster_key")|.instances[0].attributes.id' $1`
API_SECRET=`jq -r '.. | select(.name?=="clients_kafka_cluster_key")|.instances[0].attributes.secret' $1`

#Schema Registry
SR_API_KEY=`jq -r '.. | select(.name?=="sr_cluster_key")|.instances[0].attributes.id' $1`
SR_API_SECRET=`jq -r '.. | select(.name?=="sr_cluster_key")|.instances[0].attributes.secret' $1`
SR_URL=`jq -r '.. | select(.name?=="simple_sr_cluster")|.instances[0].attributes.rest_endpoint' $1`

echo "#########################"
echo "# Generated config file #"
echo "#########################"
echo ""
echo "bootstrap.servers="$BOOT_STRAP
echo "security.protocol=SASL_SSL"
echo "sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='$API_KEY' password='$API_SECRET';"
echo "sasl.mechanism=PLAIN"
echo ""
echo "# Client setup"
echo "client.dns.lookup=use_all_dns_ips"
echo "session.timeout.ms=45000"
echo "acks=all"
echo ""
echo "# Serializer"
echo "key.serializer=org.apache.kafka.common.serialization.StringSerializer"
echo "value.serializer=org.apache.kafka.common.serialization.StringSerializer"
echo "key.deserializer=org.apache.kafka.common.serialization.StringDeserializer"
echo "value.deserializer=org.apache.kafka.common.serialization.StringDeserializer"
echo ""
echo "# Required connection configs for Confluent Cloud Schema Registry"
echo "schema.registry.url="$SR_URL
echo "basic.auth.credentials.source=USER_INFO"
echo "basic.auth.user.info="$SR_API_KEY":"$SR_API_SECRET