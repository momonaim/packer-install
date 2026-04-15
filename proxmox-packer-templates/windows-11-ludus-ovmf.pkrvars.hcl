name         = "win11-25h2-x64-enterprise-template"
iso_file     = "26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_url      = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
iso_checksum = "a61adeab895ef5a4db436e0a7011c92a2ff17bb0357f58b13bbc4062e535e7b9"

disk_size       = "40G"
disk_type       = "virtio"
scsi_controller = "virtio-scsi-single"
cpu_type        = "host"
cpu_cores       = 2
memory          = 4096

# Win11 in UEFI mode (aligned with Ludus build)
bios                 = "ovmf"
enable_efi           = true
efi_type             = "4m"
efi_pre_enrolled_keys = true

additional_iso_files = [
  {
    iso_file     = "virtio-win-0.1.240.iso"
    iso_url      = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso"
    iso_checksum = "ebd48258668f7f78e026ed276c28a9d19d83e020ffa080ad69910dc86bbcbcc6"
  }
]

unattended_content = {
  "/Autounattend.xml" = {
    template = "./http/windows/Autounattend-win11-ovmf.xml.pkrtpl"
    vars = {
      driver_version = "w11"
      image_name     = "Windows 11 Enterprise Evaluation"
    }
  }
}

additional_cd_files = [
  {
    type  = "sata"
    index = 3
    files = [
      "./http/windows-scripts/*",
      "./win11-25h2-x64-enterprise/iso/setup-for-ansible.ps1",
      "./win11-25h2-x64-enterprise/iso/windows-common-setup.ps1",
      "./win11-25h2-x64-enterprise/iso/win-updates.ps1"
    ]
  }
]

os             = "win11"
communicator   = "winrm"
winrm_use_ssl  = true
winrm_insecure = true
http_directory = ""
cloud_init     = false
boot_wait      = "0s"
boot_command   = []

provisioner = []
windows_shell_scripts = [
  "./win11-25h2-x64-enterprise/scripts/disablewinupdate.bat"
]
windows_provisioner_scripts = [
  "./win11-25h2-x64-enterprise/scripts/disable-hibernate.ps1",
  "./win11-25h2-x64-enterprise/scripts/install-virtio-drivers.ps1"
]
windows_provisioner = [
  "$sysprep = \"$env:SystemRoot\\System32\\Sysprep\\Sysprep.exe\"",
  "if (!(Test-Path $sysprep)) { throw 'Sysprep.exe not found' }",
  "& $sysprep /oobe /generalize /mode:vm /shutdown /quiet"
]
