# Confluent Cloud Demo 

Here the steps to setup (and deliver if you need) this demo.

## Export credentials (to avoid to use them in each step):

    export CONFLUENT_CLOUD_API_KEY=<KEY>
    export CONFLUENT_CLOUD_API_SECRET=<SECRET>

## Provisioni the environment with Terraform

go to terraform folder:

    cd terraform

Then let's start using terraform and init dependencies

    terraform init

Let's check our plan

    terraform plan -var confluent_cloud_api_key=<your-key> -var confluent_cloud_api_secret=<your-secret>

To run the apply without promopt

    terraform apply -var confluent_cloud_api_key=<your-key> -var confluent_cloud_api_secret=<your-secret> -auto-approve 

To destroy the cluster:

    terraform destroy -var confluent_cloud_api_key=<your-key> -var confluent_cloud_api_secret=<your-secret> -auto-approve

You can use the provided scripts:

    ./terraform-plan.sh
    ./terraform-apply.sh
    ./terraform-destroy.sh


Will be useful fot the test to copy past the output from terraform into a backup file (just in case).

## Generate client config.properties

run the command `generate_clients_configs.sh` to create `config.properties`

# Simple java application test

Go back to the project root.

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

# Flink demo (short)

Go to the Flink's pool `SQL workspace` start running queries:

```sql
SELECT * FROM avrouser
```

The output is not so clear or useful.

Let's get some info (from the nested json/avro):

```sql
SELECT name, surname, addressinfo.city FROM avrouser
```

# Flink demo (long)

Generate data: 
* Create a datagen Avro for click_stream_users  (you can name it ClickStreamUsersGen )
* Create a datagen Avro for click_stream (you can name it ClickStreamGen )

You can use existing client API generated from terraform

## See avro messages

From `terraform` output copy and execute in a shell the last lines:

```
export BOOTSTRAP_SERVER="<BOOTSTRAP>"
export SCHEMA_REGISTRY_URL=https://<SCHEMA_REGISTRY_URL>
export BASIC_AUTH_USER_INFO=<KEY>:<SECRET>
```

Then run the command:

`./consume-avro.sh click_stream_users`

On another shell:

```
export BOOTSTRAP_SERVER="<BOOTSTRAP>"
export SCHEMA_REGISTRY_URL=https://<SCHEMA_REGISTRY_URL>
export BASIC_AUTH_USER_INFO=<KEY>:<SECRET>
```
The run the command:

`./consume-avro.sh click_stream`

To show the coming messages.

You can paus the click_stream_users connector after a while

## Flink SQL

Go to the Flink's pool `SQL workspace` start running queries:

```sql
SELECT user_id, username, remote_user, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id;
```

Select a user_id to use in the next query:

```sql
SELECT user_id, username, first_name, last_name, remote_user, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id
WHERE user_id=<YOUR_ID>;
```

Find some info about our users

```sql
SELECT * from click_stream_users where city = 'New York'
```

```sql
SELECT user_id, username, first_name, last_name, agent
FROM click_stream
INNER JOIN click_stream_users
ON click_stream.userid = click_stream_users.user_id
WHERE city = 'New York';
```

## Create sink table

We want to persist the result of our filter into a table (topic)

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

We can consume the result of our filter with an avro client

Copy connect configuratuin a file named local-conf/avroconsumer.properties

copy Schema registry info into `consumer-avro.sh`

Run the script and show the output

`./consume-avro.sh NewYorkClickStream`

A the end of the process you can show the lineage to inspect the pipelines

# Data portal overview

Click on `click_stream` topic

Create a business metadata (from right menu)

    Name: "owner"
    Description: "Data product owner department"
    Attribute: "name"

Go to topic `click_stream`

* Add `owner,name=IT` to `click_stream` from right menu

Go to topic `click_stream_users`

* Add `owner,name=CRM` to `click_stream_users` from right menu

Got to Data Portal click on `View all` (remember to select your cluster) from the Recently created

Serach appling filter Business meta data:

* `owner>name=CRM` 

See results, then change to:

* `owner>name=IT`

Click on `click_stream` show the topic `actions`

Create a tag PII and apply to topic