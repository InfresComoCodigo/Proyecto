########################################
# main.tf
########################################
locals {
  use_sort_key = var.sort_key != ""
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode   # así no te preocupas por RCU/WCU

  hash_key     = var.hash_key

  # ---------- Atributos ----------
  attribute {
    name = var.hash_key
    type = "S"
  }

  # Agrega sort key solo si se definió
  dynamic "attribute" {
    for_each = local.use_sort_key ? [1] : []
    content {
      name = var.sort_key
      type = "S"
    }
  }

  # ---------- Etiquetas ----------
  tags = {
    project     = "Villa Alfredo"
    environment = terraform.workspace
  }
}
