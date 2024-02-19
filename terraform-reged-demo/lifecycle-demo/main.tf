# main.tf

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"

  lifecycle {
    prevent_destroy = true

    # Ignore changes to the tags attribute
    ignore_changes = ["tags"]
	
	# Create a new resource before destroying the existing one during an update
    create_before_destroy = true

  }
}
