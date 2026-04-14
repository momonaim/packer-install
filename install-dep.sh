#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${GREEN}=== Mise à jour du système ===${NC}"
apt update && apt upgrade -y

echo -e "${GREEN}=== Installation des dépendances ===${NC}"
apt install -y curl wget gnupg jq unzip openssh-client python3-pip

# ---------------------- JENKINS ----------------------
echo -e "${GREEN}=== Installation de Jenkins ===${NC}"
rm -f /etc/apt/sources.list.d/jenkins.list /usr/share/keyrings/jenkins-keyring.* 2>/dev/null || true

# Importer la clé GPG correctement
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

# Ajouter le repository avec la clé correctement référencée
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update
apt install -y fontconfig openjdk-17-jre jenkins
systemctl enable --now jenkins
echo -e "${YELLOW}Jenkins installé. Mot de passe : /var/lib/jenkins/secrets/initialAdminPassword${NC}"

# ---------------------- TERRAFORM ----------------------
echo -e "${GREEN}=== Installation de Terraform ===${NC}"
TERRAFORM_VERSION="1.7.5"
wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
mv terraform /usr/local/bin/
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# ---------------------- ANSIBLE (via pip) ----------------------
echo -e "${GREEN}=== Installation de Ansible (via pip) ===${NC}"
pip3 install --upgrade ansible

# ---------------------- KUBECTL ----------------------
echo -e "${GREEN}=== Installation de kubectl ===${NC}"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

# ---------------------- CLÉ SSH ----------------------
SSH_KEY_PATH="/var/lib/jenkins/.ssh/id_rsa_jenkins"
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo -e "${GREEN}=== Génération clé SSH Jenkins ===${NC}"
    mkdir -p /var/lib/jenkins/.ssh
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "jenkins-control-node"
    chown -R jenkins:jenkins /var/lib/jenkins/.ssh
    chmod 700 /var/lib/jenkins/.ssh
    chmod 600 "$SSH_KEY_PATH"
    echo -e "${YELLOW}Clé publique (à copier dans terraform.tfvars) :${NC}"
    cat "${SSH_KEY_PATH}.pub"
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation terminée !${NC}"
echo "Mot de passe Jenkins : $(cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo 'Non trouvé')"