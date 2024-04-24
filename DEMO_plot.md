Terraform

Export credentials (to avoid to use them in each step):

    export CONFLUENT_CLOUD_API_KEY=<KEY>
    export CONFLUENT_CLOUD_API_SECRET=<SECRET>

Then let's start using terraform and init dependencies

    terraform init

Let's check our plan

    terraform plan

To run the apply without promopt

    terraform apply -var confluent_cloud_api_key=<your-key> -var confluent_cloud_api_secret=<your-secret> -auto-approve 

To destroy the cluster:

    terraform destroy -auto-approve

You can use the provided scripts:

    ./terraform-plan.sh
    ./terraform-apply.sh
    ./terraform-destroy.sh


Will be useful fot the test to copy past the output from terraform into a backup file.

run the command `generate_clients_configs.sh` to create `config.properties`

# Simple java application test

Build the two clients in `producer` and `consumer` folders 

Producer

    mvn clean package -f simple-java/producer/pom.xml

Consumer
    
    mvn clean package -f simple-java/consumer/pom.xml

Copy the output section from terraform to preperly configure the clients `config.properties` (Get the API key, secret and bootstrap server)

Run the producer (fromm the repo root)
        
    java -jar simple-java/producer/target/java-simple-kafka-producer-1.0-jar-with-dependencies.jar config.properties

Run the consumer (fromm the repo root)

    java -jar simple-java/consumer/target/java-simple-kafka-consumer-1.0-jar-with-dependencies.jar  config.properties
    

Show the cloud console *lineage*

# Avro java application test

Build the two clients in `avro-java/avro-producer` and `avro-java/avro-consumer` folders

Producer

    mvn clean package -f avro-java/avro-producer/pom.xml

Consumer
    
    mvn clean package -f avro-java/avro-consumer/pom.xml

Copy the output section from terraform to preperly configure the clients `config.properties` (Get the API key, secret and bootstrap server)

Run the producer (fromm the repo root)
        
    java -jar avro-java/avro-producer/target/avro-sample-producer-1.0-jar-with-dependencies.jar config.properties avrouser

Run the consumer (fromm the repo root)

    java -jar avro-java/avro-consumer/target/avro-sample-consumer-1.0-jar-with-dependencies.jar config.properties avrouser
    

Show the cloud console *lineage*

# Flink demo

Generate data: 
* Create a datagen Avro for click_stream_users  (you can name it ClickStreamUsersGen )
* Create a datagen Avro for click_stream (you can name it ClickStreamGen )

You can use existing client API generated from terraform

## See avro messages

Copy connect configuratuin a file named local-conf/avroconsumer.properties

copy Schema registry info into `consumer-avro.sh`

`./consume-avro.sh click_stream_users`

# FLINK

Start with queries

```sql
SELECT user_id, username, remote_user, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id;
```

Get a user_id for the next query:

```sql
SELECT user_id, username, first_name, last_name, remote_user, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id
WHERE user_id=<YOUR_ID>;
```

```sql
SELECT * from click_stream_users where city = 'New York'
```

```sql
SELECT user_id, username, remote_user, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id
WHERE city = 'New York';
```

## Create sink table

```sql
CREATE TABLE NewYorkClickStream(
    user_id INT,
    username VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    remote_user VARCHAR,
    agent VARCHAR,
    city VARCHAR
  );
```

## Populate the table with a select

```sql
INSERT INTO NewYorkClickStream
    SELECT user_id, username, first_name, last_name, remote_user, agent, city
    FROM click_stream
    INNER JOIN click_stream_users
    ON click_stream.userid = click_stream_users.user_id
    WHERE city = 'New York';
```

## Check the output

```sql
Select * from NewYorkClickStream
```

# Consume Avro Messages from Flink topic

Copy connect configuratuin a file named local-conf/avroconsumer.properties

copy Schema registry info into `consumer-avro.sh`

Run the script and show the output

`consumer-avro.sh NewYorkClickStream`

A the end of the process you can show the lineage to inspect the pipelines

## Alternatively you can use kafka avro console consumer to get the mesages from the topic

# Data portal demo

Click on `click_stream` topic

Create a business metadata

    Name: "owner"
    Description: "Data product owner department"
    Attribute: "name"

* Add `owner,name=IT` to `click_stream`
* Add `owner,name=CRM` to `click_stream_users`

Got to Data Portal click on `View all` from the Recently created

Serach appling filter Business meta data:

* `owner>name=CRM` 

See results, then change to:

* `owner>name=IT`

Click on `click_stream` show the topic `actions`

Create a tag PII and apply to topic