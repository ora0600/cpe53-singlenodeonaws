# Confluent Platform Enterprise 5.3 as single node installation (4dev) in AWS
Simple terraform script to deploy confluent platform enterprise to aws as a single node installation.
What you need to setup in AWS:
  * AWS SSH Key <your-key>
  * AWS Access Keys : Access key ID "aws_access_key" and secret "aws_secret_key"
  * Choose your region in AWS "aws_region"

The created aws compute instance will use default security group (normally for ssh enabled, please check) and the defautl subnet and choose a private IP adress. Public IP will be choosed as well automatically, there is no fixed IP (Elastic IP).

## adapt terraform script to your environment
adapt the varibales file to your setup:
* instance_type = "t2.large", which resources template for your ec2 instance (check costs)
* key_name      = "your-key", your ssh key, store in AWS
* variable "aws_access_key", you have to create an API access key
* variable "aws_secret_key", you have to create an API access key
* variable "aws_region", which region do you want to deploy, e.g. eu-central-1
* variable instance_count, default value is 1, if you need more compute increase the number

## execute terraform
If done install terraform on your computer and execute
```
terraform init
terraform plan
terraform apply
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

SSH = SSH  Access: ssh -i <sshkey> ec2-user@<public-ip>
SSH_Tunnel = With Tunnel: ssh -i hackathon-temp-key.pem -N -L 9022:ip-172-31-14-21.<region>.compute.internal ec2-user@<publicip>
```
## play with your confluent environment in cloud
to connect your aws compute instance via ssh use
```
ssh -i ~/keys/your-key.pem ec2-user@<PUBLIC IP of aws Instance>
```

If you want to work with the GUI of Confluent Control Center create a sshtunnel:
```
ssh -i ~/keys/your-key.pem -N -L 9022:ip-<Private-IP>.<YOUR-REGION-IN_AWS>.compute.internal:9021 ec2-user@<PUBLIC IP of aws Instance>
```
  
Then you can use confluent Control Center via http://localhost:9022
Of course you could also change the Security Group rule for your compte instance and open all the Ports, which are necessary to communicate with the Confluent installation on compute in aws. But a simple tunnel might be enough for short tests.

## safe costs and destroy aws compute services
If you are finished, execute following command to destroy averything in AWS.This will save costs.
```
terraform destroy.
```
  
## Connect to Confluent Cloud
I have put the script ccloud-generate-env-vars.sh in the $HOME directory. If you install the Confluent Cloud cli a directory ~/.ccloud will be generated. Here you have to place a config file for Cloud properties
```
cat ~/.ccloud/config
bootstrap.servers=<confluent cloud server>:9092
ssl.endpoint.identification.algorithm=https
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="<API Key>" password="<API Secret>";
basic.auth.credentials.source=USER_INFO
schema.registry.basic.auth.user.info=<SCHEMA API Key>:<Schema API Secret>
schema.registry.url=https://<Schema Registry Host>
```
To generate the cloud properties files execute after you have added into config the correct Keys, URLs and secrets.
```
~/ccloud-generate-env-vars.sh ~/.ccloud/config
```
All property files will be generated into ./delta_configs/.
