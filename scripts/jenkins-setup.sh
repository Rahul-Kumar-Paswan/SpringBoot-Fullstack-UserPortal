#!/bin/bash
set -euxo pipefail

# --- Update system ---
echo "🔄 Updating system..."
apt update -y
apt install -y wget curl gnupg lsb-release ca-certificates apt-transport-https unzip software-properties-common

# --- Install OpenJDK 21 ---
echo "☕ Installing OpenJDK 21..."
apt install -y openjdk-21-jdk-headless

# --- Install Docker ---
echo "🐳 Installing Docker..."
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu || true
sudo usermod -aG docker ubuntu || true
sudo usermod -aG docker jenkins || true

# --- Install Docker Compose ---
DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker-cli-plugins}
mkdir -p $DOCKER_CONFIG
curl -SL "https://github.com/docker/compose/releases/download/v2.38.2/docker-compose-linux-x86_64" \
  -o "$DOCKER_CONFIG/docker-compose"
chmod +x "$DOCKER_CONFIG/docker-compose"
ln -s $DOCKER_CONFIG/docker-compose /usr/local/bin/docker-compose || true

# --- Install Jenkins ---
echo "🧩 Installing Jenkins..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# --- Install Gitleaks ---
echo "🔒 Installing Gitleaks..."
GITLEAKS_VERSION="8.18.4"
wget -q "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
tar -xzf "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
mv gitleaks /usr/local/bin/
rm -f "gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"

# --- Install Trivy ---
echo "🛡️ Installing Trivy..."
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | tee /etc/apt/sources.list.d/trivy.list > /dev/null
apt update -y
apt install -y trivy

# --- Install kubectl ---
echo "⚙️ Installing kubectl..."
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# --- Install AWS CLI v2 ---
echo "☁️ Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# --- Verify installations ---
echo "🧪 Verifying installed tools..."
for tool in java gitleaks trivy docker docker-compose kubectl aws; do
  if ! command -v "$tool" &>/dev/null; then
    echo "❌ $tool is missing!"
  else
    case "$tool" in
      java)      echo "✅ $tool found: $(java -version 2>&1 | head -n 1)" ;;
      docker)    echo "✅ $tool found: $(docker --version)" ;;
      docker-compose) echo "✅ $tool found: $(docker-compose --version)" ;;
      aws)       echo "✅ $tool found: $(aws --version)" ;;
      trivy)     echo "✅ $tool found: $(trivy version | head -n 1)" ;;
      kubectl)   echo "✅ $tool found: $(kubectl version --client --short)" ;;
      gitleaks)  echo "✅ $tool found: $(gitleaks version)" ;;
    esac
  fi
done

echo "🎉 Jenkins + tools setup completed successfully!"
