# Confluent Platform Enterprise 5.3 as single node installation (4dev) in AWS
Simple terraform script to deploy confluent platform enterprise to aws as a single node installation.
What you need to setup in AWS:
*AWS SSH Key <your-key>
*an existing Security Group, SSH enabled "your_security_group_id"
*an existing Subnet "your subnet id"
*AWS API key "aws_access_key"
*AWS API secret "aws_secret_key"
*Choose your region in AWS "aws_region"


## adapt terraform script to your environment
in main.tf change your data of
* instance_type = "t2.large"
* key_name      = "your-key"
* vpc_security_group_ids = ["your security group id"]
* subnet_id = "your subnet id"

I defined a fixed private IP. So, choose the right subnet, so that private IP fits into the IP range of your subnet.

Please change also variables.tf with your data.

* variable "aws_access_key"
* variable "aws_secret_key"
*  variable "aws_region"

## execute terraform
If done install terraform on your computer and execute
```
terraform init
terraform plan
terraform apply
```
## play with your confluent environment in cloud
to connect your aws compute instance via ssh use
```
ssh -i ~/keys/your-key.pem ec2-user@<PUBLIC IP of aws Instance>
```

If you want to work with the GUI of Confluent Control Center create a sshtunnel:
```
ssh -i ~/keys/your-key.pem -N -L 9022:ip-172-31-30-30.<YOUR-REGION-IN_AWS>.compute.internal:9021 ec2-user@<PUBLIC IP of aws Instance>
```
  
Then you can use confluent Control Center via http://localhost:9022
Of course you could also change the Security Group rule for your compte instance and open all the Ports, which are necessary to communicate with the Confluent installation on compute in aws. But a simple tunnel might be enough for short tests.

## safe costs and destroy aws compute services
If you are finished, execute following command to destroy averything in AWS.This will save costs.
```
terraform destroy.
```
  

