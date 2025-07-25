provider "aws" {
    region = "us-east-1"
}

provider "azurerm" {
    subscription_id = ""
    client_id = ""
    client_secret = ""
    tenant_id = ""
}

resource "aws_instance" "aws_server" {
    ami = ""
    instance_type = ""
}

resource "azurerm_virtual_machine" "azure_server" {
    name = "server1"
    location = "eastus"
    vm_size = "Standard_A1"
    resource_group_name = ""
    network_interface_ids = ""
    storage_os_disk {
      name = "os_disk_1"
      create_option = ""
    }
}
