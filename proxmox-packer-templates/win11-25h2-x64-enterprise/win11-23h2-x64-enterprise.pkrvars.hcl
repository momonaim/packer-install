# Template-only overrides for this Win11 build.
# Proxmox credentials/connection vars should come from proxmox.auto.pkrvars.hcl.
iso_checksum = "sha256:a61adeab895ef5a4db436e0a7011c92a2ff17bb0357f58b13bbc4062e535e7b9"
os           = "win11"
iso_url      = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
vm_cpu_cores = "2"
vm_disk_size = "40G"
vm_memory    = "8096"
vm_name      = "win11-25h2-x64-enterprise-template"
winrm_password = "password"
winrm_username = "localuser"
