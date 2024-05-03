
kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVER \
    --property schema.registry.url=$SCHEMA_REGISTRY_URL \
    --property basic.auth.credentials.source=USER_INFO \
    --property basic.auth.user.info="$BASIC_AUTH_USER_INFO" \
    --consumer.config config.properties \
    --topic $1  --from-beginning
   