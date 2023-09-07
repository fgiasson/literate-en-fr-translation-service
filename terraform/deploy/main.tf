terraform {
  required_version = ">= 1.5.6" 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }    
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

resource "azurerm_resource_group" "acr" {
  name     = "translationarg"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                     = "translationacr"
  resource_group_name      = azurerm_resource_group.acr.name
  location                 = azurerm_resource_group.acr.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "null_resource" "build_and_push_image" {
  depends_on = [azurerm_container_registry.acr]

  triggers = {
    # Add a trigger to detect changes in your Docker build context
    # The timestamp forces Terraform to trigger the Docker build,
    # every time terraform is applied. The check to see if anything
    # needs to be updated in the Docker container is delegated
    # to Docker.
    build_trigger = timestamp()
  }

  provisioner "local-exec" {
    # Replace with the commands to build and push your Docker image to the ACR
    command = <<EOT
      # Build the Docker image
      docker build -t en-fr-translation-service:v1 ../../
      
      # Log in to the ACR
      az acr login --name translationacr
      
      # Tag the Docker image for ACR
      docker tag en-fr-translation-service:v1 translationacr.azurecr.io/en-fr-translation-service:v1
      
      # Push the Docker image to ACR
      docker push translationacr.azurecr.io/en-fr-translation-service:v1
    EOT
  }
}

resource "azurerm_container_group" "acr" {
  depends_on = [null_resource.build_and_push_image]

  lifecycle {
    replace_triggered_by = [
      # Replace `azurerm_container_group` each time this instance of
      # the the Docker image is replaced.
      null_resource.build_and_push_image.id
    ]
  }

  name                = "translation-container-instance"
  location            = azurerm_resource_group.acr.location
  resource_group_name = azurerm_resource_group.acr.name
  ip_address_type     = "Public"
  dns_name_label      = "en-fr-translation-service"
  restart_policy      = "Never"
  os_type             = "Linux"

  image_registry_credential {
     username = azurerm_container_registry.acr.admin_username
     password = azurerm_container_registry.acr.admin_password
    server   = "translationacr.azurecr.io"
  }

  container {
    name   = "en-fr-translation-service-container"
    image  = "translationacr.azurecr.io/en-fr-translation-service:v1"
    cpu    = 4
    memory = 8

    ports {
      protocol = "TCP"
      port     = 6000
    }
  }

  tags = {
    environment = "development"
  }
}
