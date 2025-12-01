# GCP VM Deployment Guide - Anime Recommender System

This guide provides step-by-step instructions to deploy the Anime Recommender System on a Google Cloud Platform (GCP) VM instance.

## Prerequisites

1. **GCP Account**: Active Google Cloud Platform account
2. **Groq API Key**: Get your API key from [Groq Console](https://console.groq.com/)
3. **GitHub Repository**: Your code should be pushed to a GitHub repository (or you can use other methods to transfer files)

---

## Step 1: Create GCP VM Instance

### 1.1 Navigate to Compute Engine
- Go to [Google Cloud Console](https://console.cloud.google.com/)
- Navigate to **Compute Engine** > **VM instances**
- Click **"Create Instance"**

### 1.2 Configure VM Instance

**Basic Settings:**
- **Name**: `anime-recommender-vm` (or your preferred name)
- **Region**: Choose a region close to your users
- **Zone**: Select any available zone

**Machine Configuration:**
- **Machine Type**: 
  - Series: `E2` or `N1`
  - Preset: `Standard`
  - **Recommended**: `e2-standard-4` (4 vCPUs, 16 GB RAM) or higher
  - **Minimum**: `e2-standard-2` (2 vCPUs, 8 GB RAM)

**Boot Disk:**
- **Operating System**: Ubuntu
- **Version**: Ubuntu 22.04 LTS or Ubuntu 24.04 LTS
- **Boot disk type**: Standard Persistent Disk
- **Size**: 50 GB (minimum) - 100 GB recommended

**Firewall:**
- ✅ **Allow HTTP traffic**
- ✅ **Allow HTTPS traffic**
- ⚠️ **Note**: We'll configure firewall rules for port 8501 separately

### 1.3 Create the Instance
- Click **"Create"** and wait for the instance to be ready

---

## Step 2: Configure Firewall Rules

### 2.1 Create Firewall Rule for Streamlit
- Go to **VPC network** > **Firewall**
- Click **"Create Firewall Rule"**
- **Name**: `allow-streamlit`
- **Direction**: Ingress
- **Targets**: All instances in the network
- **Source IP ranges**: `0.0.0.0/0` (or restrict to specific IPs for security)
- **Protocols and ports**: 
  - Select **TCP**
  - Port: `8501`
- Click **"Create"**

---

## Step 3: Connect to VM Instance

### 3.1 SSH into VM
- In the VM instances list, click **"SSH"** next to your instance
- This opens a browser-based SSH terminal

**Alternative (using gcloud CLI):**
```bash
gcloud compute ssh anime-recommender-vm --zone=YOUR_ZONE
```

---

## Step 4: Set Up VM Environment

### 4.1 Update System Packages
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 4.2 Install Python and Required Tools
```bash
sudo apt-get install -y python3 python3-pip python3-venv git
```

**Note**: This is the ONLY manual installation step required. The `deploy.sh` script will handle everything else automatically (dependencies, virtual environment, etc.).

**⚠️ Important**: You do NOT need to install:
- ❌ Docker (not needed for direct VM deployment)
- ❌ kubectl (not needed for direct VM deployment)
- ❌ Minikube (not needed for direct VM deployment)

These are only needed if you want to deploy using Kubernetes (more complex setup). For simple VM deployment, Python is sufficient.

### 4.3 Verify Python Installation
```bash
python3 --version
pip3 --version
```

---

## Step 5: Clone and Set Up Project

### 5.1 Clone Your Repository
```bash
# Replace with your repository URL
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

**Alternative: Upload Files via SCP**
```bash
# From your local machine
gcloud compute scp --recurse . anime-recommender-vm:~/anime-recommender --zone=YOUR_ZONE
```

### 5.2 Navigate to Project Directory
```bash
cd ANIME-RECOMMENDER-SYSTEM-LLMOPS
# or the name of your project directory
```

---

## Step 6: Configure Environment Variables

### 6.1 Create .env File
```bash
# Copy the example file
cp .env.example .env

# Edit the .env file
nano .env
```

### 6.2 Add Your API Keys
```env
GROQ_API_KEY=your_actual_groq_api_key_here
```

**Save and exit** (Ctrl+X, then Y, then Enter)

---

## Step 7: Deploy the Application

### 7.1 Make Scripts Executable
```bash
chmod +x deploy.sh start.sh
```

### 7.2 Run Deployment Script
```bash
./deploy.sh
```

This script will:
- Create a Python virtual environment
- Install all dependencies
- Install the package
- Verify the setup

**Manual Installation (if script fails):**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

# Install the package
pip install -e .
```

---

## Step 8: Start the Application

### 8.1 Start the Application
```bash
# Option 1: Use the start script
./start.sh

# Option 2: Manual start
source venv/bin/activate
streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0
```

### 8.2 Keep Application Running (Background)
To run the application in the background, use `nohup` or `screen`:

**Using nohup:**
```bash
nohup streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0 > app.log 2>&1 &
```

**Using screen (recommended):**
```bash
# Install screen
sudo apt-get install -y screen

# Start a new screen session
screen -S anime-app

# Run the application
source venv/bin/activate
streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0

# Detach from screen: Press Ctrl+A, then D
# Reattach: screen -r anime-app
```

---

## Step 9: Access the Application

### 9.1 Get VM External IP
- Go to **Compute Engine** > **VM instances**
- Note the **External IP** address of your VM

### 9.2 Access the Application
Open your browser and navigate to:
```
http://YOUR_VM_EXTERNAL_IP:8501
```

**Example:**
```
http://34.123.45.67:8501
```

---

## Step 10: Set Up Auto-Start (Optional)

### 10.1 Create Systemd Service
```bash
sudo nano /etc/systemd/system/anime-recommender.service
```

### 10.2 Add Service Configuration
```ini
[Unit]
Description=Anime Recommender System
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/YOUR_PROJECT_DIR
Environment="PATH=/home/YOUR_USERNAME/YOUR_PROJECT_DIR/venv/bin"
ExecStart=/home/YOUR_USERNAME/YOUR_PROJECT_DIR/venv/bin/streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Replace:**
- `YOUR_USERNAME` with your VM username
- `YOUR_PROJECT_DIR` with your project directory path

### 10.3 Enable and Start Service
```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable anime-recommender.service

# Start the service
sudo systemctl start anime-recommender.service

# Check status
sudo systemctl status anime-recommender.service
```

---

## Troubleshooting

### Issue: Cannot access the application
1. **Check Firewall Rules**: Ensure port 8501 is open
2. **Check Application Status**: Verify the app is running
   ```bash
   ps aux | grep streamlit
   ```
3. **Check Logs**: Review application logs
   ```bash
   tail -f app.log  # if using nohup
   ```

### Issue: Port already in use
```bash
# Find process using port 8501
sudo lsof -i :8501

# Kill the process
sudo kill -9 <PID>
```

### Issue: ChromaDB not found
- Ensure the `chroma_db` directory exists in your project
- If missing, you may need to rebuild the vector store

### Issue: API Key errors
- Verify `.env` file exists and contains correct `GROQ_API_KEY`
- Check file permissions: `chmod 600 .env`

### Issue: Dependencies installation fails
```bash
# Update pip and try again
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

---

## Security Recommendations

1. **Restrict Firewall**: Instead of `0.0.0.0/0`, restrict to specific IP ranges
2. **Use HTTPS**: Set up a reverse proxy (nginx) with SSL certificate
3. **Environment Variables**: Keep `.env` file secure, never commit it to Git
4. **Regular Updates**: Keep system and dependencies updated
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

---

## Monitoring and Maintenance

### Check Application Logs
```bash
# If using systemd
sudo journalctl -u anime-recommender.service -f

# If using nohup
tail -f app.log
```

### Restart Application
```bash
# If using systemd
sudo systemctl restart anime-recommender.service

# If using screen
screen -r anime-app
# Then restart manually
```

### Update Application
```bash
# Pull latest changes
git pull origin main

# Reinstall dependencies if requirements.txt changed
source venv/bin/activate
pip install -r requirements.txt

# Restart application
```

---

## Cost Optimization

1. **Use Preemptible VMs**: For development/testing (up to 80% cost savings)
2. **Stop VM when not in use**: Stop the VM when not needed to avoid charges
3. **Right-size VM**: Monitor resource usage and adjust VM size accordingly

---

## Additional Resources

- [GCP Compute Engine Documentation](https://cloud.google.com/compute/docs)
- [Streamlit Deployment Guide](https://docs.streamlit.io/deploy)
- [Groq API Documentation](https://console.groq.com/docs)

---

## Summary Checklist

- [ ] GCP VM instance created
- [ ] Firewall rule for port 8501 configured
- [ ] SSH connection established
- [ ] Python and dependencies installed
- [ ] Project cloned/uploaded
- [ ] `.env` file created with API keys
- [ ] Virtual environment created and dependencies installed
- [ ] Application started successfully
- [ ] Application accessible via external IP
- [ ] Auto-start service configured (optional)

---

**Need Help?** Check the troubleshooting section or review the application logs for error messages.

