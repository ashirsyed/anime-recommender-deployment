# Deployment Requirements & Changes Summary

## Project Requirements Analysis

### ✅ Current Requirements

#### 1. **Python Dependencies** (from `requirements.txt`)
- `langchain` - LLM framework
- `langchain-community` - Community integrations
- `langchain_groq` - Groq API integration
- `chromadb` - Vector database
- `streamlit` - Web framework
- `pandas` - Data processing
- `python-dotenv` - Environment variable management
- `sentence-transformers` - Embeddings
- `langchain_huggingface` - HuggingFace integration

#### 2. **System Requirements**
- **Python**: 3.10 or higher (as per Dockerfile)
- **OS**: Ubuntu 22.04 LTS or 24.04 LTS (recommended)
- **RAM**: Minimum 8GB, Recommended 16GB
- **Storage**: Minimum 20GB (50GB recommended for models)
- **Network**: Port 8501 must be open

#### 3. **Environment Variables**
- `GROQ_API_KEY` (Required) - Get from https://console.groq.com/
- `HUGGINGFACEHUB_API_TOKEN` (Optional) - Only if downloading private models

#### 4. **Data Files**
- `data/anime_updated.csv` - Processed anime data
- `data/anime_with_synopsis.csv` - Original anime data
- `chroma_db/` - Pre-built vector database (must be included in deployment)

#### 5. **Application Configuration**
- **Port**: 8501
- **Address**: 0.0.0.0 (to accept external connections)
- **Framework**: Streamlit

---

## Changes Made for GCP VM Deployment

### ✅ Files Created

1. **`.env.example`** - Template for environment variables
   - Provides structure for required API keys
   - Prevents accidental commit of sensitive data

2. **`deploy.sh`** - Automated deployment script
   - Creates Python virtual environment
   - Installs all dependencies
   - Verifies setup
   - Checks for required files

3. **`start.sh`** - Application startup script
   - Activates virtual environment
   - Validates .env file exists
   - Starts Streamlit with correct parameters

4. **`GCP_VM_DEPLOYMENT.md`** - Comprehensive deployment guide
   - Step-by-step instructions
   - Troubleshooting section
   - Security recommendations
   - Auto-start configuration

5. **`DEPLOYMENT_QUICK_START.md`** - Quick reference guide
   - Condensed deployment steps
   - Common commands
   - Quick troubleshooting

6. **`DEPLOYMENT_REQUIREMENTS.md`** - This file
   - Requirements summary
   - Changes documentation

### ✅ Code Changes Required

**NONE** - The existing code is already compatible with VM deployment:
- ✅ `app.py` uses Streamlit (works on any platform)
- ✅ Environment variables loaded via `python-dotenv`
- ✅ ChromaDB uses local persistence (works on VM)
- ✅ No hardcoded paths or platform-specific code

### ⚠️ Configuration Notes

1. **Streamlit Server Configuration**
   - The Dockerfile shows: `--server.address=0.0.0.0`
   - This is **required** for VM deployment to accept external connections
   - Included in `start.sh` script

2. **ChromaDB Persistence**
   - The `chroma_db/` directory must be included in deployment
   - If missing, the vector store will need to be rebuilt
   - Ensure the directory is committed to Git or transferred to VM

3. **Data Files**
   - CSV files in `data/` directory must be present
   - These are used by the pipeline

---

## Pre-Deployment Checklist

### Before Deploying to GCP VM:

- [ ] **Code is pushed to Git repository**
  - All source files committed
  - `chroma_db/` directory included (or plan to rebuild)
  - `data/` directory included

- [ ] **Environment variables prepared**
  - Groq API key obtained
  - `.env.example` reviewed
  - Ready to create `.env` on VM

- [ ] **GCP Account ready**
  - Billing enabled
  - Project created
  - Compute Engine API enabled

- [ ] **VM specifications decided**
  - Machine type selected (e2-standard-4 recommended)
  - Region/zone chosen
  - Firewall rules planned

---

## Deployment Architecture

```
┌─────────────────────────────────────┐
│         GCP VM Instance             │
│  ┌───────────────────────────────┐  │
│  │   Ubuntu 22.04/24.04 LTS      │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  Python 3.10+           │  │  │
│  │  │  ┌───────────────────┐  │  │  │
│  │  │  │ Virtual Env        │  │  │  │
│  │  │  │ - Dependencies     │  │  │  │
│  │  │  │ - Application      │  │  │  │
│  │  │  └───────────────────┘  │  │  │
│  │  └─────────────────────────┘  │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  Streamlit App          │  │  │
│  │  │  Port: 8501             │  │  │
│  │  │  Address: 0.0.0.0       │  │  │
│  │  └─────────────────────────┘  │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  ChromaDB               │  │  │
│  │  │  (Local Persistence)    │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
         │
         │ Port 8501
         ▼
┌─────────────────────────────────────┐
│      Internet / Users                │
│  http://VM_EXTERNAL_IP:8501          │
└─────────────────────────────────────┘
```

---

## Security Considerations

### ⚠️ Important Security Notes

1. **Firewall Configuration**
   - Default: Port 8501 open to `0.0.0.0/0` (all IPs)
   - **Recommended**: Restrict to specific IP ranges
   - Consider using Cloud Load Balancer with SSL

2. **Environment Variables**
   - `.env` file contains sensitive API keys
   - Ensure `.env` is in `.gitignore`
   - Use file permissions: `chmod 600 .env`

3. **HTTPS/SSL**
   - Current setup uses HTTP only
   - For production, set up reverse proxy (nginx) with SSL
   - Consider using Cloud Load Balancer

4. **VM Access**
   - Use SSH keys instead of passwords
   - Restrict SSH access to specific IPs
   - Regularly update system packages

---

## Cost Estimation (Approximate)

### VM Instance Costs (US regions)
- **e2-standard-2** (2 vCPU, 8GB): ~$50/month
- **e2-standard-4** (4 vCPU, 16GB): ~$100/month
- **Storage** (50GB): ~$8/month
- **Network**: First 1TB free, then $0.12/GB

### Total Estimated Cost
- **Development/Testing**: ~$60-70/month
- **Production**: ~$110-120/month

*Note: Costs vary by region and usage. Use GCP Pricing Calculator for accurate estimates.*

---

## Monitoring Recommendations

1. **Application Logs**
   - Streamlit logs: Check console output or log files
   - Use `journalctl` if using systemd service

2. **Resource Monitoring**
   - GCP Console → Monitoring
   - Track CPU, memory, disk usage
   - Set up alerts for high usage

3. **Application Health**
   - Monitor response times
   - Track error rates
   - Set up uptime monitoring

---

## Next Steps After Deployment

1. **Test the Application**
   - Verify it's accessible via external IP
   - Test recommendation functionality
   - Check logs for errors

2. **Set Up Auto-Start**
   - Configure systemd service (see deployment guide)
   - Ensure app restarts on VM reboot

3. **Monitor Performance**
   - Check resource usage
   - Optimize VM size if needed
   - Review application logs

4. **Security Hardening**
   - Restrict firewall rules
   - Set up SSL/HTTPS
   - Regular security updates

---

## Support & Troubleshooting

For detailed troubleshooting, see:
- `GCP_VM_DEPLOYMENT.md` - Section "Troubleshooting"
- `DEPLOYMENT_QUICK_START.md` - Quick fixes

Common issues:
- Port not accessible → Check firewall rules
- App not starting → Check logs and dependencies
- API errors → Verify `.env` file and API keys
- ChromaDB errors → Ensure `chroma_db/` directory exists

---

**Last Updated**: Based on current project structure
**Compatibility**: Python 3.10+, Ubuntu 22.04/24.04 LTS

