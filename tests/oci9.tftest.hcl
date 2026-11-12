# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_identity_dynamic_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "inactive_state" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_identity_policy" {
    defaults = { "ETag" = "mock-value", "id" = "MOCK_OCID_POLICY", "inactive_state" = "mock-value", "lastUpdateETag" = "mock-value", "policyHash" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
variables {
  tenancy_ocid = "MOCK_OCID_TENANCY"
}

run "oci9_plan" {
  command = plan
}
