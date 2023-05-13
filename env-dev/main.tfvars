env = "dev"

app_servers = {
  frontend = {
    name          = "frontend"
    instance_type = "t3.small"
  }

  catalogue = {
    name          = "catalogue"
    instance_type = "t3.small"
  }

  user = {
    name          = "user"
    instance_type = "t3.small"
  }
  cart = {
    name          = "cart"
    instance_type = "t3.small"
  }

  shipping = {
    name          = "shipping"
    instance_type = "t3.small"
    password = "RoboShop@1"
  }

  payment = {
    name          = "payment"
    instance_type = "t3.small"
    passowrd = "roboshop123"
  }
  dispatch = {
    name          = "dispatch"
    instance_type = "t3.small"
  }  
}

database_servers = {
    rabbitmq = {
    name          = "rabbitmq"
    instance_type = "t3.small"
    passowrd = "roboshop123"
  }
    mysql = {
    name          = "mysql"
    instance_type = "t3.small"
    password = "RoboShop@1"
  }
    redis = {
    name          = "redis"
    instance_type = "t3.small"
  }
    mongodb = {
    name          = "mongodb"
    instance_type = "t3.small"
  }
}
