# renovate: datasource=custom.ubuntuLinuxRelease
name           = "ubuntu-24.04-desktop-ansible-template"
cpu_sockets    = 1
cpu_cores      = 2
memory         = 4096
disk_size      = "32G"
iso_file       = "ubuntu-24.04.4-desktop-amd64.iso"
iso_url        = "https://releases.ubuntu.com/24.04.4/ubuntu-24.04.4-desktop-amd64.iso"
iso_checksum   = "file:https://releases.ubuntu.com/24.04.4/SHA256SUMS"
iso_download   = false
http_directory = "./http/ubuntu-24.04-ansible"
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
  "apt-get update",
  "DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-guest-agent openssh-server python3 python3-apt sudo",
  "systemctl enable qemu-guest-agent",
  "systemctl enable ssh",
  "cloud-init clean",
  "rm -f /etc/cloud/cloud.cfg.d/*"
]
