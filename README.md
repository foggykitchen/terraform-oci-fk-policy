# terraform-oci-fk-policy

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for managing **Oracle Cloud Infrastructure (OCI) IAM policies** and an optional **dynamic group**, designed for explicit authorization patterns and hands-on learning.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and serves as a small, composable IAM building block for OCI examples and workloads, including **OKE add-ons**, autoscaler integrations, and instance-principal access patterns.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## 🎯 Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for OCI IAM building blocks:

- Focused on **tenancy-level IAM policies** and an optional **dynamic group**
- No hidden magic or abstract authorization flags
- Designed to be consumed by other modules and examples that need explicit OCI IAM

This is **not** a full OCI IAM framework. It is a **learning-first, composition-friendly module**.

---

## ✨ What the module does

The module creates:

- Zero or one OCI Dynamic Group
- Zero or more OCI IAM Policies

The module intentionally does **not** create:
- Compartments
- Users
- Groups
- Identity Domains
- Vaults
- Workloads
- Networking

Each of those concerns belongs in its own dedicated module.

The policy statements remain fully explicit in the calling layer. The module manages resource lifecycle and structure, but it does not hide IAM intent behind higher-level abstractions.

---

## 📂 Repository Structure

```bash
terraform-oci-fk-policy/
├── examples/
│   ├── 01_policy_only/
│   ├── 02_dynamic_group_with_policy/
│   └── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

All examples are runnable and demonstrate **incremental IAM composition**, starting from a minimal policy-only setup.

---

## 🚀 Example Usage

```hcl
module "policy" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-policy.git?ref=v0.1.0"

  providers = {
    oci = oci.homeregion
  }

  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "fk_oke_instance_principal_dg"
    description   = "Dynamic group for OKE worker nodes"
    matching_rule = "ALL {instance.compartment.id='${var.compartment_ocid}'}"
  }

  policies = [
    {
      name        = "fk_oke_adbs_identity_principal"
      description = "Policy to enable OKE worker nodes to manage Autonomous Database resources"
      statements = [
        "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-database in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_instance_principal_dg to manage autonomous-backup in compartment id ${var.compartment_ocid}",
        "Allow dynamic-group fk_oke_instance_principal_dg to read vaults in compartment id ${var.compartment_ocid}"
      ]
    }
  ]
}
```

---

## ⚙️ Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `tenancy_ocid` | `string` | ✅ | OCI tenancy OCID used for IAM resource creation |
| `policies` | `list(object)` | ❌ | List of OCI IAM policies to create |
| `dynamic_group` | `object` | ❌ | Optional dynamic group definition |
| `enabled` | `bool` | ❌ | Whether the module should create IAM resources |

### Dynamic group object schema

```hcl
dynamic_group = object({
  name          = string
  description   = string
  matching_rule = string
})
```

Set `dynamic_group = null` to skip dynamic group creation.

### Policy object schema

```hcl
policies = list(object({
  name        = string
  description = string
  statements  = list(string)
}))
```

Validation rules:
- Policy names must be unique
- Each policy must include at least one statement

---

## 📤 Outputs

| Output | Description |
|------|-------------|
| `dynamic_group` | Created OCI dynamic group object, or `null` |
| `dynamic_group_id` | Dynamic group OCID, or `null` |
| `policies` | Map of created OCI IAM policies keyed by policy name |
| `policy_ids` | Map of created OCI IAM policy OCIDs keyed by policy name |

---

## 🧩 Examples Overview

| Example | Description |
|-------|-------------|
| `01_policy_only` | Minimal OCI IAM policy deployment without a dynamic group |
| `02_dynamic_group_with_policy` | Dynamic group plus tenancy-level policies for instance-principal style access |

See [`examples/`](examples) for details.

---

## 🧠 Design Philosophy

- Explicit over implicit
- Small IAM modules over monolithic frameworks
- Visible policy statements over generated authorization logic
- Optimized for **learning, reuse, and composition**

This makes the module ideal for:
- OKE autoscaler policies
- OKE virtual node policies
- Instance principal access patterns
- Training material and architecture workshops

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
