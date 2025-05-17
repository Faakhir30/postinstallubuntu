#!/bin/bash

# Function to exit on failure
exit_on_failure() {
  echo "Error occurred during installation. Exiting..."
  exit 1
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y || exit_on_failure

# Install basic dependencies
echo "Installing dependencies..."
sudo apt install -y wget curl gnupg lsb-release apt-transport-https ca-certificates software-properties-common || exit_on_failure

# 1. Install Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || exit_on_failure
sudo dpkg -i google-chrome-stable_current_amd64.deb || exit_on_failure
sudo apt --fix-broken install -y || exit_on_failure

# 2. Install Cursor (AppImage)
echo "Installing Cursor..."
wget https://downloads.cursor.com/production/8ea935e79a50a02da912a034bbeda84a6d3d355d/linux/x64/Cursor-0.50.4-x86_64.AppImage -O cursor.AppImage || exit_on_failure
chmod +x cursor.AppImage || exit_on_failure
sudo mv cursor.AppImage /usr/local/bin/cursor || exit_on_failure

# 3. Install Git
echo "Installing Git..."
sudo apt install -y git || exit_on_failure

# 4. Install npm
echo "Installing npm..."
sudo apt install -y npm || exit_on_failure

# 5. Install Node Version Manager (n) and Node.js
echo "Installing Node Version Manager (n) and Node.js..."
sudo npm install -g n || exit_on_failure
sudo n stable || exit_on_failure

# 6. Install Golang (Go)
echo "Installing Go (Golang)..."
sudo apt install -y golang-go || exit_on_failure

# 7. Install Docker
echo "Installing Docker..."

# Add Docker's official GPG key
sudo apt-get update || exit_on_failure
sudo apt-get install -y ca-certificates curl || exit_on_failure
sudo install -m 0755 -d /etc/apt/keyrings || exit_on_failure
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || exit_on_failure
sudo chmod a+r /etc/apt/keyrings/docker.asc || exit_on_failure

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || exit_on_failure
sudo apt-get update || exit_on_failure
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || exit_on_failure
sudo service docker start || exit_on_failure
sudo groupadd docker || exit_on_failure
sudo usermod -aG docker $USER || exit_on_failure
newgrp docker || exit_on_failure

# 8. Install Minikube
echo "Installing Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64 || exit_on_failure
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64 || exit_on_failure

# 9. Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl" || exit_on_failure
sudo mv kubectl /usr/local/bin/ || exit_on_failure
sudo chmod +x /usr/local/bin/kubectl || exit_on_failure

# 10. Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo snap install code --classic || exit_on_failure

# 11. Install GitHub CLI (gh)
echo "Installing GitHub CLI (gh)..."
sudo snap install gh || exit_on_failure

# 12. Install Spotify
echo "Installing Spotify..."
sudo snap install spotify || exit_on_failure

# 13. Install Helm
echo "Installing Helm..."
sudo snap install helm --classic || exit_on_failure

# 14. Install k9s
echo "Installing k9s..."
wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb || exit_on_failure
sudo apt install ./k9s_linux_amd64.deb || exit_on_failure
rm k9s_linux_amd64.deb || exit_on_failure

# Clean up the downloaded files
echo "Cleaning up..."
rm google-chrome-stable_current_amd64.deb || exit_on_failure

# Verify installations
echo "Verifying installations..."

google-chrome-stable --version
git --version
node -v
npm -v
go version
docker --version
minikube version
kubectl version --client
code --version
gh --version
spotify --version
helm version
k9s version

echo "Installation complete!"

