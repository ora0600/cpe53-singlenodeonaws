resource "aws_instance" "cp53" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = "t2.large"
  key_name      = "your-key"
  vpc_security_group_ids = ["your security group id"]
  subnet_id = "your subnet id"
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
