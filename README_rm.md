# Confluent Cloud basic demo

## Create the cluster

You can choose to use also the Terraform provide in order to create the environment and basic cluster for the demo.

Name the cluster `acme-cluster`

Create the topic `orders` without a schema.

## Schemaless example

## Create API Key for clients

On  the confluent Cloud Console :

1. click on left menù "clients"
2. In the page select java
3. Scroll down and click on "Create Kafka cluster API key" 

Create the files: 

<PROJECT_ROOT>/producer/config.properties
<PROJECT_ROOT>/consumer/config.properties

You can use  the config-template.properties as reference

Build the apps.


