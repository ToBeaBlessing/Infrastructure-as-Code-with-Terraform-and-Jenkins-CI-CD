#!/bin/bash

# 1. Wait for Ubuntu background updates to finish
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   echo "Waiting for other software managers to finish..."
   sleep 5
done

# 2. Update and Install Java 17
sudo apt-get update -y
sudo apt-get install -y fontconfig openjdk-17-jre wget

# 3. Download Jenkins directly as .deb package (bypass repository issues)
echo "Downloading Jenkins .deb package..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y

# 4. Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# 5. Fix any dependency issues
sudo apt-get install -f -y

# 6. Start Jenkins
echo "Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 7. Wait for Jenkins to fully start
echo "Waiting for Jenkins to start (60 seconds)..."
sleep 60

# 8. Display initial admin password
echo "========================================="
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Jenkins still starting, wait another minute"
echo "========================================="

# 9. Install Terraform
echo "Installing Terraform..."
sudo apt-get install -y unzip
wget -q https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip
unzip -q 'terraform*.zip'
sudo mv terraform /usr/local/bin/
terraform --version

echo "========================================="
echo "Setup complete!"
echo "========================================="