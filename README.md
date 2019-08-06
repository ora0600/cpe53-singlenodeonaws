# cpe53-singlenodeonaws
Simple terraform script to deploy confluent platform enterprise to aws as a single node installation.
Please change variables.tf with your data.

# adapt terraform script to your environment
in main.tf change your data of
instance_type = "t2.large"
key_name      = "your-key"
vpc_security_group_ids = ["sg-0592eb43a5d0290fc"]
subnet_id = "subnet-9a539ef0"

# execute terraform
If done install terraform on your computer and execute
terraform init
terraform plan
terraform apply

# play with your confluent environment in cloud
to connect your aws compute instance via ssh use
ssh -i ~/keys/your-key.pem ec2-user@<PUBLIC IP of aws Instance>

If you want to work with the GUI of Confluent Control Center create a sshtunnel:
ssh -i ~/keys/your-key.pem -N -L 9022:ip-172-31-30-30.<YOUR-REGION-IN_AWS>.compute.internal:9021 ec2-user@<PUBLIC IP of aws Instance>
  
Then you can use confluent Control Center via http://localhost:9022

# safe costs and destroy aws compute services
If you are finished, execute
terraform destroy.

  

