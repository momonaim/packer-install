name         = "windows-10-template"
iso_file     = "19044.1288.211006-0501.21h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_url      = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum = "none"
disk_size    = "20G"
additional_iso_files = [
  {
    iso_file     = "virtio-win-0.1.285.iso"
    iso_url      = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/virtio-win-0.1.285.iso"
    iso_checksum = "e14cf2b94492c3e925f0070ba7fdfedeb2048c91eea9c5a5afb30232a3976331"
  }
]
unattended_content = {
  "/Autounattend.xml" = {
    template = "./http/windows/Autounattend-win10.xml.pkrtpl"
    vars = {
      driver_version  = "w10"
      image_name      = "Windows 10 Enterprise Evaluation"
    }
  }
}
additional_cd_files = [
  {
    type = "sata"
    index = 3
    files  = ["./http/windows-scripts/*"]
  }
]
os             = "win10"
communicator   = "winrm"
http_directory = ""
cloud_init   = false
boot_command   = []
provisioner    = []
