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

  policies = [
    {
      name        = "fk_example_virtual_node_policy"
      description = "Example virtual node policy"
      statements = [
        "define tenancy ske as ocid1.tenancy.oc1..example",
        "define compartment ske_compartment as ocid1.compartment.oc1..example",
        "endorse any-user to associate compute-container-instances in compartment ske_compartment of tenancy ske with network-security-group in tenancy where ALL {request.principal.type='virtualnode',request.operation='CreateContainerInstance'}"
      ]
    }
  ]
}
