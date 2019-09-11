#!/bin/bash
yum update -y
yum install wget -y
yum install unzip -y
yum install java-1.8.0-openjdk-devel.x86_64 -y
yum install jq
# install confluent
mkdir -p /home/ec2-user/software
chown ec2-user:ec2-user /home/ec2-user/software
cd /home/ec2-user/software
wget ${confluent_platform_location}
tar -xvf confluent-5.3.0-2.12.tar.gz
chown ec2-user:ec2-user confluent-5.3.0/*
rm confluent-5.3.0-2.12.tar.gz

# adding metric into kafka broker for control center
echo "metric.reporters=io.confluent.metrics.reporter.ConfluentMetricsReporter" >> /home/ec2-user/software/confluent-5.3.0/etc/kafka/server.properties
echo "confluent.metrics.reporter.bootstrap.servers=localhost:9092" >> /home/ec2-user/software/confluent-5.3.0/etc/kafka/server.properties
echo "confluent.metrics.reporter.topic.replicas=1" >> /home/ec2-user/software/confluent-5.3.0/etc/kafka/server.properties

########### Creating the Service zookeeper ############

cat > /lib/systemd/system/zookeeper.service <<- "EOF"
[Unit]
Description=Confluent Zookeeper
After=network.target
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/zookeeper-server-start ${confluent_home_value}/etc/kafka/zookeeper.properties
ExecStop=${confluent_home_value}/bin/zookeeper-server-stop ${confluent_home_value}/etc/kafka/zookeeper.properties
[Install]
WantedBy=multi-user.target
EOF

############# Enable and Start ############

systemctl enable zookeeper
systemctl start zookeeper

########### Creating the Service Kafka ############

cat > /lib/systemd/system/kafka.service <<- "EOF"
[Unit]
Description=Confluent Kafka Broker
After=zookeeeper
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/kafka-server-start ${confluent_home_value}/etc/kafka/server.properties
ExecStop=${confluent_home_value}/bin/kafka-server-stop ${confluent_home_value}/etc/kafka/server.properties
[Install]
WantedBy=multi-user.target
EOF

############# Enable and Start ############

systemctl enable kafka
systemctl start kafka

########### Creating the Service Kafka REST ############

cat > /lib/systemd/system/kafka-rest.service <<- "EOF"
[Unit]
Description=Confluent Kafka REST
After=kafka
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/kafka-rest-start ${confluent_home_value}/etc/kafka-rest/kafka-rest.properties
ExecStop=${confluent_home_value}/bin/kafka-rest-stop ${confluent_home_value}/etc/kafka-rest/kafka-rest.properties
[Install]
WantedBy=multi-user.target
EOF

############# Enable and Start ############

systemctl enable kafka-rest
systemctl start kafka-rest

########### Creating the Service KSQL-Server ############

cat > /lib/systemd/system/ksql-server.service <<- "EOF"
[Unit]
Description=Confluent KSQL Server
After=kafka
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/ksql-server-start ${confluent_home_value}/etc/ksql/ksql-server.properties
ExecStop=${confluent_home_value}/bin/ksql-server-stop ${confluent_home_value}/etc/ksql/ksql-server.properties
[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable ksql-server
systemctl start ksql-server

########### Creating the Service Kafka-connect ############

cat > /lib/systemd/system/kafka-connect.service <<- "EOF"
[Unit]
Description=Kafka Connect
After=kafka
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/connect-distributed ${confluent_home_value}/etc/kafka-connect/kafka-connect.properties
[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable kafka-connect
systemctl start kafka-connect

########### Creating the Service Control Server ############
cat > /lib/systemd/system/control-center.service <<- "EOF"
[Unit]
Description=Confluent Control Center
After=kafka
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/control-center-start ${confluent_home_value}/etc/confluent-control-center/control-center-dev.properties
ExecStop=${confluent_home_value}/bin/control-center-stop ${confluent_home_value}/etc/confluent-control-center/control-center-dev.properties
[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable control-center
systemctl start control-center
# config bash_profile for ec2-user
echo "export PATH=${confluent_home_value}/bin:\$PATH" >> /home/ec2-user/.bash_profile
echo "export CONFLUENT_HOME=${confluent_home_value}" >> /home/ec2-user/.bash_profile
chown ec2-user:ec2-user /home/ec2-user/.bash_profile
echo "export PATH=${confluent_home_value}/bin:\$PATH" >> /root/.bash_profile
echo "export CONFLUENT_HOME=${confluent_home_value}" >> /root/.bash_profile
# create install script for confluent cli, to install later if you need
echo "#!/bin/bash" > /home/ec2-user/install_cli.sh
echo "curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/bin" >> /home/ec2-user/install_cli.sh
chown ec2-user:ec2-user /home/ec2-user/install_cli.sh
chmod ugo+x /home/ec2-user/install_cli.sh

