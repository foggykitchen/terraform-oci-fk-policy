# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_data "oci_identity_region_subscriptions" {
    defaults = { "id" = "MOCK_OCID_SUBSCRIPTIONS", "region_subscriptions" = [{ "is_home_region" = true, "region_key" = "FRA", "region_name" = "eu-frankfurt-1", "state" = "AVAILABLE", "tenancy_id" = "MOCK_OCID_MOCK", "status" = "READY" }] }
  }
  mock_resource "oci_identity_dynamic_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "inactive_state" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_identity_policy" {
    defaults = { "ETag" = "mock-value", "id" = "MOCK_OCID_POLICY", "inactive_state" = "mock-value", "lastUpdateETag" = "mock-value", "policyHash" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
mock_provider "oci" {
  alias = "targetregion"
  mock_data "oci_identity_region_subscriptions" {
    defaults = { "id" = "MOCK_OCID_SUBSCRIPTIONS", "region_subscriptions" = [{ "is_home_region" = true, "region_key" = "FRA", "region_name" = "eu-frankfurt-1", "state" = "AVAILABLE", "tenancy_id" = "MOCK_OCID_MOCK", "status" = "READY" }] }
  }
  mock_resource "oci_identity_dynamic_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "inactive_state" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_identity_policy" {
    defaults = { "ETag" = "mock-value", "id" = "MOCK_OCID_POLICY", "inactive_state" = "mock-value", "lastUpdateETag" = "mock-value", "policyHash" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
mock_provider "oci" {
  alias = "homeregion"
  mock_data "oci_identity_region_subscriptions" {
    defaults = { "id" = "MOCK_OCID_SUBSCRIPTIONS", "region_subscriptions" = [{ "is_home_region" = true, "region_key" = "FRA", "region_name" = "eu-frankfurt-1", "state" = "AVAILABLE", "tenancy_id" = "MOCK_OCID_MOCK", "status" = "READY" }] }
  }
  mock_resource "oci_identity_dynamic_group" {
    defaults = { "id" = "MOCK_OCID_GROUP", "inactive_state" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_identity_policy" {
    defaults = { "ETag" = "mock-value", "id" = "MOCK_OCID_POLICY", "inactive_state" = "mock-value", "lastUpdateETag" = "mock-value", "policyHash" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
variables {
  tenancy_ocid     = "MOCK_OCID_TENANCY"
  user_ocid        = "MOCK_OCID_MOCK"
  fingerprint      = "compatibility"
  private_key_path = "/unused-by-mock"
  region           = "eu-frankfurt-1"
}

run "oci9_plan" {
  command   = plan
  providers = { oci = oci, oci.targetregion = oci.targetregion, oci.homeregion = oci.homeregion }
}
