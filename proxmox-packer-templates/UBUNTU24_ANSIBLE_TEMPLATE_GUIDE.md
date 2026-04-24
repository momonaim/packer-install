## Ubuntu 24 Desktop Ansible Template - Build & First Playbook Guide

This guide walks you through building the new Ansible-ready Ubuntu 24 Desktop Packer template and executing your first Ansible playbook.

---

## Part 1: Build the Packer Template

### Prerequisites

- Packer installed and initialized: `packer init config.pkr.hcl`
- Proxmox credentials and environment variables set (or passed via `-var` flags)
- ISO download enabled or already cached in Proxmox storage

### Build Command

From `proxmox-packer-templates/` directory, run:

```bash
packer build -var-file="ubuntu-24.04-ansible-template.pkrvars.hcl" -var-file="proxmox.auto.pkrvars.hcl" .
```

**Expected output:**

- Packer downloads Ubuntu 24.04 desktop ISO
- Cloud-init autoinstalls OS with `ubuntu`/`ubuntu` credentials
- Python 3, Ansible prerequisites, and SSH server installed
- Template created in Proxmox as: `ubuntu-24-04-desktop-ansible-template`

**Build time:** ~20–30 minutes (depending on network/Proxmox performance)

---

## Part 2: Clone & Boot the Template

1. **In Proxmox UI**, clone the template:
   - Select template `ubuntu-24-04-desktop-ansible-template`
   - Clone as full copy (not linked)
   - Set VM ID and name (e.g., `lab-ansible-01`)
   - Boot the VM

2. **Get the VM's IP address** once it boots. Note it for inventory setup (e.g., `192.168.1.50`)

---

## Part 3: Update Ansible Inventory

Edit the generated inventory file:  
`devops/ansible/inventory/ubuntu24-ansible-template-hosts.ini`

Replace the placeholder IP with your actual VM IP:

```ini
[all:vars]
ansible_user=ubuntu
ansible_password=ubuntu
ansible_become=true
ansible_become_method=sudo
ansible_port=22
ansible_python_interpreter=/usr/bin/python3

[ubuntu24_desktop]
ubuntu24-ansible-01 ansible_host=YOUR_VM_IP_HERE
```

---

## Part 4: Run First Playbook (Software Installation)

### Option A: Command-Line Install (Single Command)

From `devops/ansible/` directory:

```bash
ansible-playbook \
  -i inventory/ubuntu24-ansible-template-hosts.ini \
  playbooks/ubuntu24_desktop_software.yml \
  -e "selected_packages=['docker.io','terraform','ansible','git','python3']"
```

### Option B: Using Pre-Configured Vars File

From `devops/ansible/` directory:

```bash
ansible-playbook \
  -i inventory/ubuntu24-ansible-template-hosts.ini \
  playbooks/ubuntu24_desktop_software.yml \
  -e "@vars/ubuntu24_first_lab_software.yml"
```

This uses the pre-built software selection: **Docker, Terraform, Ansible, Git, Python3**

### Verify Connectivity Before Running

Test SSH and Ansible connectivity first:

```bash
# Test SSH
ssh -v ubuntu@YOUR_VM_IP

# Test Ansible ping
ansible -i inventory/ubuntu24-ansible-template-hosts.ini ubuntu24_desktop -m ping
```

Expected output:

```
ubuntu24-ansible-01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

## Part 5: Customize Software Selection

To install different software from the catalog, use catalog labels:

**Available labels** (from `SoftwareCatalogService`):

- **Development:** Python, Node.js, Java, Go, Rust, Git, Maven, Gradle, npm, pip, Make, Vim, Nano, Emacs
- **Cloud:** Docker, Docker Compose, Terraform, Ansible
- **Networking:** curl, wget, netcat, tcpdump, Wireshark, Nginx, Apache, OpenSSH
- **Security:** UFW
- **Database:** PostgreSQL, MySQL, Redis

**Example: Install DevOps Stack**

```bash
ansible-playbook \
  -i inventory/ubuntu24-ansible-template-hosts.ini \
  playbooks/ubuntu24_desktop_software.yml \
  -e "selected_packages=['docker.io','docker-compose-v2','terraform','ansible','postgresql','redis-server']"
```

---

## Part 6: Integration with Backend Template Profile

Once validated, save the template profile via REST API:

**POST** `http://your-laas-backend:8080/api/v1/templates`

```json
{
  "name": "Ubuntu24 Ansible Desktop",
  "osType": "LINUX",
  "osName": "ubuntu24-desktop",
  "osVersion": "24.04",
  "cpu": 4,
  "ram": 8,
  "storage": 64,
  "sshUser": "ubuntu",
  "sshPassword": "ubuntu",
  "softwareLabels": ["Docker", "Terraform", "Ansible", "Git", "Python"]
}
```

---

## Troubleshooting

### Playbook fails: "Permission denied (publickey)"

- Ensure SSH password auth is enabled (cloud-init does this via `allow-pw: true`)
- Check VM has network connectivity: `ping 8.8.8.8`

### Playbook fails: "Python interpreter not found"

- Template will auto-install Python 3 during cloud-init
- If missing, SSH manually and run: `sudo apt-get install python3 python3-apt`

### Ansible host unreachable

- Verify IP in inventory matches actual VM IP: `ip a` on the VM
- Check firewall: `sudo ufw status` (should be inactive by default)
- Test SSH directly: `ssh ubuntu@IP` with password `ubuntu`

### Template build fails in Packer

- Ensure `provisioner` commands in `.pkrvars.hcl` run without errors
- Check Proxmox storage and ISO paths configured correctly
- Review Packer logs: `PACKER_LOG=1 packer build ...`

---

## Files Created/Modified

| File                                            | Purpose                                                       |
| ----------------------------------------------- | ------------------------------------------------------------- |
| `ubuntu-24.04-ansible-template.pkrvars.hcl`     | Packer vars for Ansible-ready template build                  |
| `http/ubuntu-24.04-ansible/user-data`           | Cloud-init config: SSH, Python, sudo setup                    |
| `http/ubuntu-24.04-ansible/meta-data`           | Cloud-init metadata                                           |
| `inventory/ubuntu24-ansible-template-hosts.ini` | Sample Ansible inventory for template VM                      |
| `vars/ubuntu24_first_lab_software.yml`          | Pre-selected software list (Docker, TF, Ansible, Git, Python) |

---

## Next Steps

1. ✅ Build Packer template
2. ✅ Clone and boot VM
3. ✅ Run first playbook (software install)
4. ✅ Verify installation: `docker --version`, `terraform --version`, `ansible --version`
5. Create additional template profiles for other lab scenarios
6. Integrate with your Lab-As-A-Service backend scheduling
