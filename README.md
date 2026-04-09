## Screenshots

### Folder structure
![Folder structure](screenshots/folder-structure.png)
Modular Terraform project structure with separate modules for management groups, policy, networking, and RBAC. Each module is self-contained with its own inputs, outputs, and resources.

### Terraform init
![Terraform init](screenshots/terraform-init.png)
Azure provider successfully downloaded and initialized. Project is ready to authenticate and deploy resources to Azure.

### Management group
![Management group](screenshots/management-group.png)
Management group mg-landing-zone created at the top of the Azure hierarchy. All governance policies and RBAC controls flow down from this level.

### Policy assignment
![Policy assignment](screenshots/policy-assignment.png)
Custom Azure Policy enforcing environment tagging assigned at the management group scope. Any resource created without an environment tag is automatically denied — no workarounds possible at the subscription or resource group level.

### Resource groups
![Resource groups](screenshots/resource-groups.png)
Separate resource groups for hub and spoke environments. Isolating them means each team only has visibility and access to their own resources.

### VNet subnets
![VNet subnets](screenshots/vnet-subnets.png)
Hub virtual network with dedicated subnet. Resources deployed by the platform team live here — shared services, firewalls, and central connectivity.

### VNet peering
![VNet peering](screenshots/vnet-peering.png)
Bidirectional VNet peering between hub and spoke showing Connected status. Traffic between the two networks routes through the hub giving central visibility and control.

### IAM hub
![IAM hub](screenshots/iam-hub.png)
Contributor role assigned to the platform team on vnet-hub. Platform engineers can manage shared infrastructure without access to workload environments.

### IAM spoke
![IAM spoke](screenshots/iam-spoke.png)
Contributor role assigned to the workload team on vnet-spoke1. App teams can deploy into their own spoke without touching the central hub network.
