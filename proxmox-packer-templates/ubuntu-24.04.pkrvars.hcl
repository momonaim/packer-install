# renovate: datasource=custom.ubuntuLinuxRelease
name           = "ubuntu-24.04-template"
iso_file       = "ubuntu-24.04.4-desktop-amd64.iso"
iso_url        = "https://releases.ubuntu.com/24.04.4/ubuntu-24.04.4-desktop-amd64.iso"
iso_checksum   = "file:https://releases.ubuntu.com/24.04.4/SHA256SUMS"
iso_download   = false
http_directory = "./http/ubuntu-24.04"
boot_wait      = "15s"
boot_command = [
  "c<wait><wait>",
  "linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ---<enter><wait><wait><wait>",
  "initrd /casper/initrd<enter><wait><wait><wait>",
  "boot<enter>"
]
ssh_username = "ubuntu"
ssh_password = "ubuntu"
ssh_timeout  = "40m"
provisioner = [
  "cloud-init clean",
  "rm /etc/cloud/cloud.cfg.d/*"
]
