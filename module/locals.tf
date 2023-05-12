 locals = {
    name = var.env !=  "" ?  "{var.components_name}-${var.env}" : var.components_name
         }