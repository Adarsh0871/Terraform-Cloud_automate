# terraform.tfvars

# Tenancy OCID (from Identity → Tenancy details)
tenancy_ocid   = "ocid1.tenancy.oc1..aaaaaaaalw76oyclxv5ixb7qqwnoau6k2jba7meuby6gap5h56ghq6r2lxta"

# User OCID (from Identity → Users → Your user → Copy OCID)
user_ocid      = "ocid1.user.oc1..aaaaaaaakz6s27gbm55nuwplgz2dipcviym46ohbxs6ndz63xmdld7mxjwkq"

# Compartment OCID (from Identity → Compartments → Your compartment → Copy OCID)
compartment_ocid = "ocid1.tenancy.oc1..aaaaaaaalw76oyclxv5ixb7qqwnoau6k2jba7meuby6gap5h56ghq6r2lxta"

# Region (choose from OCI region list, e.g. ap-mumbai-1, us-ashburn-1, etc.)
region         = "ap-mumbai-1"

# Fingerprint (shown in console after uploading your public key)
fingerprint    = "10:5d:a6:d1:03:39:99:f9:93:b4:cc:3a:c5:28:5d:01"

# Path to your private key file (.pem downloaded earlier)
private_key_path = "/home/adarsh/Downloads/adarshkr0851@gmail.com-2025-09-10T16_31_22.084Z.pem"

# Path to your SSH public key (for instance login, usually from ~/.ssh/id_rsa.pub or generate new one)
ssh_public_key = "/home/adarsh/.ssh/id_rsa.pub"

