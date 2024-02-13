aws_region = us-east-1

webserver_instances = [
  {
    id          = 1,
    tagged_name = "public-webserver-1",
    server_type = "t2.micro",
    web_subnet  = "sandbox_subnet_public_1"
  },
  {
    id          = 2,
    tagged_name = "public-webserver-2",
    server_type = "t2.micro",
    web_subnet  = "sandbox_subnet_public_2"
  },
]

