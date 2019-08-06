resource "aws_instance" "cp53" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = "t2.large"
  key_name      = "your-key"
  vpc_security_group_ids = ["sg-0592eb43a5d0290fc"]
  subnet_id = "subnet-9a539ef0"
  private_ip = "172.31.30.30"
  
  user_data = data.template_file.confluent_instance.rendered

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "cp 53 instance"
  }
}
