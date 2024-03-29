resource "aws_instance" "cp53" {
  ami           = "${data.aws_ami.ami.id}"
  count         = var.instance_count
  instance_type = var.instance_type_resource
  key_name      = var.ssh_key_name
  
  user_data = data.template_file.confluent_instance.rendered

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "cp 53 instance"
  }
}
