//--------------------------------------------------------------------
// Variables

variable "env" {}

//--------------------------------------------------------------------
// Modules
module "network" {
  source  = "app.terraform.io/AWSTFEDemos/network/aws"
  version = "3.0.8"

  availability_zones = "us-east-1a"
  key_name = "tfe-demos-darnold"
  network_name = "${var.env}"
  region = "us-east-1"
}

module "public_service" {
  source  = "app.terraform.io/AWSTFEDemos/public-service/aws"
  version = "1.0.1"

  env = "${var.env}"
  instance_type = "t2.micro"
  key_name = "${module.network.key_name}"
  private_subnet_id = "${element(module.network.private_subnets, 0)}"
  public_subnet_id = "${element(module.network.public_subnets, 0)}"
  service_healthcheck = "add/1/1"
  service_name = "simple-app"
  service_version = "1.0.0"
  vpc_id = "${module.network.vpc_id}"
}
