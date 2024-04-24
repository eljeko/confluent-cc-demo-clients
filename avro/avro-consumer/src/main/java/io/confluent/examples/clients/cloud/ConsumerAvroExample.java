/**
 * Copyright 2020 Confluent Inc.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.confluent.examples.clients.cloud;

import example.kafka.UserInfo;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import io.confluent.kafka.serializers.KafkaAvroDeserializerConfig;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.PartitionInfo;
import org.apache.kafka.common.TopicPartition;

import java.time.Duration;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

import static io.confluent.examples.clients.cloud.Util.loadConfig;

public class ConsumerAvroExample {

    public static void main(final String[] args) throws Exception {
        if (args.length != 2) {
            System.out.println("Please provide command line arguments: configPath topic");
            System.exit(1);
        }

        final String topic = args[1];

        // Load properties from a local configuration file
        // Create the configuration file (e.g. at '$HOME/.confluent/java.config') with configuration parameters
        // to connect to your Kafka cluster, which can be on your local host, Confluent Cloud, or any other cluster.
        // Follow these instructions to create this file: https://docs.confluent.io/platform/current/tutorials/examples/clients/docs/java.html
        final Properties props = loadConfig(args[0]);

        // Add additional properties.
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
        props.put(KafkaAvroDeserializerConfig.SPECIFIC_AVRO_READER_CONFIG, true);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "demo-consumer-avro-1");
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        final Consumer<String, UserInfo> consumer = new KafkaConsumer<String, UserInfo>(props);
         consumer.subscribe(Arrays.asList(topic));

        /*
        Long total_count = 0L;

        List<PartitionInfo> partitionsInfo = consumer.partitionsFor(topic);


        for (PartitionInfo next : partitionsInfo) {
            try {
                consumer.seek(new TopicPartition(topic, next.partition()), 0);
            }catch (Exception ex){
                ex.printStackTrace();
            }
        }
*/
        try {
            while (true) {
                ConsumerRecords<String, UserInfo> records = consumer.poll(Duration.ofMillis(100));
                for (ConsumerRecord<String, UserInfo> record : records) {
                    String key = record.key();
                    UserInfo value = record.value();
                    System.out.printf("Consumed record with key %s and name: %s @ city [%s] \n", key,  value.getName(), value.getAddressinfo().getCity() );
                }
            }
        } finally {
            consumer.close();
        }
    }
}
