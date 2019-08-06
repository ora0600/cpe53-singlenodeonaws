###########################################
######## Confluent 5.3 Dev Instance ##########
###########################################

data "template_file" "confluent_instance" {
  template = file("utils/instance.sh")

  vars = {
    confluent_platform_location = var.confluent_platform_location
    confluent_home_value        = var.confluent_home_value
  }
}
