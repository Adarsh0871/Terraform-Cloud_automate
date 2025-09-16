provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key          = var.private_key # or use private_key_content var
  region               = var.region
}

# ---------------- Variables ----------------
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {
  description = "PEM formatted private key contents"
  sensitive   = true
}
variable "compartment_ocid" {}
variable "region" {}
variable "ssh_public_key" {}
variable "dbname" {
  default = "hbdemo01"
}

# ---------------- Provider ----------------
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key      = var.private_key
  # ✅ Alternative (safer): use private_key_path if you want to upload the key file
  # private_key_path = var.private_key_path
}

# ---------------- Region Mapping ----------------
variable "ad_region_mapping" {
  type = map(string)
  default = {
    uk-london-1 = 1
    ap-mumbai-1 = 1
  }
}

variable "images" {
  type = map(string)
  default = {
    uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaaskspfz56rlcmtfbr2milotcxqcpitly63zipmn4joygm44qs7hua"
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaa6axdosyr74xbitjbwdwp7bmjvjfj5rkym6juttbjvi5fj3xiurna"
  }
}

# ---------------- Networking ----------------
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.ad_region_mapping[var.region]
}

resource "oci_core_virtual_network" "test_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "testVCN"
  dns_label      = "testvcn"
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "testSubnet"
  dns_label         = "testsubnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.test_vcn.id
  route_table_id    = oci_core_route_table.test_route_table.id
  dhcp_options_id   = oci_core_virtual_network.test_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "testIG"
  vcn_id         = oci_core_virtual_network.test_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_security_list" "test_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 3000
      max = 3000
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 3005
      max = 3005
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }
}

# ---------------- Images ----------------
data "oci_core_images" "test_images" {
  compartment_id = var.compartment_ocid
  shape          = "VM.Standard.A1.Flex"
}

# ---------------- Autonomous DB ----------------
data "oci_database_autonomous_databases" "test_autonomous_databases" {
  compartment_id = var.compartment_ocid
  db_workload    = "OLTP"
  is_free_tier   = true
}

resource "oci_database_autonomous_database" "test_autonomous_database" {
  admin_password           = "Testalwaysfree1"
  compartment_id           = var.compartment_ocid
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_name                  = var.dbname
  db_workload              = "OLTP"
  display_name             = var.dbname
  is_auto_scaling_enabled  = false
  license_model            = "LICENSE_INCLUDED"
  is_free_tier             = true

  freeform_tags = {
    Department = "Finance"
  }
}
