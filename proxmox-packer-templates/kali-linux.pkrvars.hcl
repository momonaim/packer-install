# renovate: datasource=custom.kaliLinuxRelease
name           = "kali-linux-template"
iso_file       = "kali-linux-2026.1-installer-netinst-amd64.iso"
iso_url        = "https://cdimage.kali.org/current/kali-linux-2026.1-installer-netinst-amd64.iso"
iso_checksum   = "file:https://cdimage.kali.org/current/SHA256SUMS"
http_directory = "./http/kali"
boot_command = [
  "<esc><wait>",
  "install ",
  " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
  "auto ", "locale=en_US.UTF-8 ",
  "kbd-chooser/method=us ",
  "keyboard-configuration/xkb-keymap=us ",
  "netcfg/get_hostname=kali ",
  "netcfg/get_domain=local ",
  "fb=false ",
  "debconf/frontend=noninteractive ",
  "console-setup/ask_detect=false ",
  "console-keymaps-at/keymap=us ",
  "grub-installer/bootdev=/dev/sda ",
  "passwd/username=packer ",
  "passwd/user-fullname=packer ",
  "passwd/user-password=packer ",
  "passwd/user-password-again=packer ",
  "<enter>"
]
provisioner = [
  "apt update && apt install -y sudo qemu-guest-agent kali-desktop-xfce",
  "systemctl enable qemu-guest-agent",
  "systemctl enable lightdm",
  "userdel --remove --force packer"
]
