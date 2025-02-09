# Azure Blob Storage Terraform Module

This Terraform module creates an Azure Blob Storage account and a container within it. It allows you to configure various properties of the storage account and the container.

## Prerequisites

- An Azure account with an active subscription.
- Terraform installed on your local machine.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "azure_blob_storage" {
  source              = "./terraform-azure-blob-storage"
  storage_account_name = "your_storage_account_name"
  resource_group_name  = "your_resource_group_name"
  location            = "your_location"
  container_name      = "your_container_name"
}
```

## Input Variables

| Variable                   | Description                                   | Type   | Default |
|---------------------------|-----------------------------------------------|--------|---------|
| `storage_account_name`    | The name of the storage account.              | string | n/a     |
| `resource_group_name`     | The name of the resource group.               | string | n/a     |
| `location`                | The Azure region where the resources will be created. | string | n/a     |
| `container_name`          | The name of the blob container.               | string | n/a     |

## Outputs

| Output                   | Description                                   |
|--------------------------|-----------------------------------------------|
| `storage_account_id`     | The ID of the created storage account.       |
| `container_id`           | The ID of the created blob container.        |

## Example

Here is an example of how to call this module:

```hcl
module "my_blob_storage" {
  source              = "./terraform-azure-blob-storage"
  storage_account_name = "mystorageaccount"
  resource_group_name  = "myresourcegroup"
  location            = "East US"
  container_name      = "mycontainer"
}
```

## License

This module is licensed under the MIT License. See the LICENSE file for more details.