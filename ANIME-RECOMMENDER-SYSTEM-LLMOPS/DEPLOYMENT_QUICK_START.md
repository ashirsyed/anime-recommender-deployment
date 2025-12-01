# Quick Start - GCP VM Deployment

## Prerequisites Checklist
- [ ] GCP account with billing enabled
- [ ] Groq API key from https://console.groq.com/
- [ ] GitHub repository with your code (or SCP access)

**⚠️ Important**: You do NOT need Docker, kubectl, or Minikube for this deployment method!
These are only needed for Kubernetes deployment (see `DEPLOYMENT_COMPARISON.md` for details).

## Quick Deployment Steps

### 1. Create VM (5 minutes)
```
GCP Console → Compute Engine → Create Instance
- Machine: e2-standard-4 (4 vCPU, 16GB RAM)
- OS: Ubuntu 22.04 LTS
- Boot Disk: 50GB
- Firewall: Allow HTTP/HTTPS
```

### 2. Configure Firewall
```
VPC Network → Firewall → Create Rule
- Name: allow-streamlit
- Port: 8501
- Protocol: TCP
- Source: 0.0.0.0/0 (or restrict for security)
```

### 3. SSH into VM
```
Click "SSH" button in GCP Console
```

### 4. One-Command Setup
```bash
# Clone your repo
git clone YOUR_REPO_URL
cd ANIME-RECOMMENDER-SYSTEM-LLMOPS

# Install Python (if not already installed - usually pre-installed on Ubuntu)
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv git

# Make scripts executable
chmod +x deploy.sh start.sh

# Run deployment (automatically installs all dependencies!)
./deploy.sh

# Create .env file
cp .env.example .env
nano .env  # Add your GROQ_API_KEY

# Start application
./start.sh
```

**Note**: The `deploy.sh` script handles everything automatically:
- ✅ Creates virtual environment
- ✅ Installs all Python dependencies
- ✅ Sets up the application
- ❌ No Docker, kubectl, or Minikube needed!

### 5. Access Application
```
http://YOUR_VM_EXTERNAL_IP:8501
```

## Running in Background

### Option 1: Screen (Recommended)
```bash
screen -S anime-app
./start.sh
# Press Ctrl+A then D to detach
# Reattach: screen -r anime-app
```

### Option 2: Nohup
```bash
nohup ./start.sh > app.log 2>&1 &
```

### Option 3: Systemd Service
See `GCP_VM_DEPLOYMENT.md` Step 10 for detailed instructions.

## Troubleshooting

**Can't access app?**
- Check firewall: `gcloud compute firewall-rules list`
- Check if app is running: `ps aux | grep streamlit`
- Check logs: `tail -f app.log`

**Port in use?**
```bash
sudo lsof -i :8501
sudo kill -9 <PID>
```

**Missing dependencies?**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

## Important Files
- `.env` - Contains API keys (NEVER commit to Git)
- `requirements.txt` - Python dependencies
- `deploy.sh` - Automated deployment script
- `start.sh` - Application startup script

## Next Steps
For detailed instructions, see `GCP_VM_DEPLOYMENT.md`

