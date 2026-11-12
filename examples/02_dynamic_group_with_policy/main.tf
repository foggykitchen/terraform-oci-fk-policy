terraform {
  required_version = ">= 1.3"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.21.0, < 7.0.0"
    }
  }
}

module "policy" {
  source = "../.."

  providers = {
    oci = oci.homeregion
  }

  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "fk_example_instance_principal_dg"
    description   = "Example dynamic group for OKE worker nodes"
    matching_rule = "ALL {instance.compartment.id='${var.compartment_ocid}'}"
  }

  policies = [
    {
      name        = "fk_example_instance_principal_policy"
      description = "Example policy for OKE worker nodes"
      statements = [
        "Allow dynamic-group fk_example_instance_principal_dg to manage autonomous-database in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_example_instance_principal_dg to manage autonomous-backup in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_example_instance_principal_dg to read vaults in compartment id ${var.compartment_ocid}"
      ]
    }
  ]
}
