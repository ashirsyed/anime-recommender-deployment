# Environment Variables Setup Guide

## Required Environment Variables

### 1. GROQ_API_KEY (REQUIRED) ⚠️

**Purpose**: Used to authenticate with Groq API for LLM inference (ChatGroq)

**How to Get:**
1. Visit [Groq Console](https://console.groq.com/)
2. Sign up or log in to your account
3. Navigate to **API Keys** section (usually in account settings)
4. Click **"Create API Key"** or **"Generate New Key"**
5. Copy the generated API key
6. **Important**: Save it immediately - you won't be able to see it again!

**Format**: 
```
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Where it's used:**
- `config/config.py` - Loaded from environment
- `pipeline/pipeline.py` - Passed to AnimeRecommender
- `src/recommender.py` - Used to initialize ChatGroq LLM

**Note**: Without this key, the application will fail to start or generate recommendations.

---

## Optional Environment Variables

### 2. HUGGINGFACEHUB_API_TOKEN (OPTIONAL)

**Purpose**: Used for downloading HuggingFace models (embeddings)

**When you need it:**
- ✅ If you want to avoid rate limits when downloading models
- ✅ If you're using private HuggingFace models
- ✅ If you're rebuilding the vector store from scratch
- ❌ **NOT required** for normal operation (the model `all-MiniLM-L6-v2` is public)

**How to Get:**
1. Visit [HuggingFace](https://huggingface.co/)
2. Sign up or log in
3. Go to **Settings** → **Access Tokens**
4. Click **"New token"**
5. Give it a name (e.g., "anime-recommender")
6. Select **"Read"** permission (sufficient for public models)
7. Click **"Generate token"**
8. Copy the token

**Format**:
```
HUGGINGFACEHUB_API_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Where it's used:**
- `src/vector_store.py` - Used by HuggingFaceEmbeddings (if token is set)

**Note**: The application works without this token since `all-MiniLM-L6-v2` is a public model.

---

## Setup Instructions

### Step 1: Create .env File

```bash
# Copy the example file
cp .env.example .env

# Edit the file
nano .env
# or
vim .env
```

### Step 2: Add Your API Keys

Open `.env` and replace the placeholder values:

```env
GROQ_API_KEY=gsk_your_actual_key_here
# HUGGINGFACEHUB_API_TOKEN=hf_your_actual_token_here  # Uncomment if needed
```

### Step 3: Verify Setup

```bash
# Check if .env file exists
ls -la .env

# Verify it's not committed to git (should be ignored)
git status  # .env should not appear

# Test loading (Python)
python3 -c "from dotenv import load_dotenv; import os; load_dotenv(); print('GROQ_API_KEY:', 'SET' if os.getenv('GROQ_API_KEY') else 'NOT SET')"
```

---

## Security Best Practices

### ✅ DO:
- ✅ Keep `.env` file in `.gitignore` (already configured)
- ✅ Use file permissions: `chmod 600 .env`
- ✅ Never commit `.env` to version control
- ✅ Use different API keys for development and production
- ✅ Rotate API keys periodically
- ✅ Store production keys securely (use GCP Secret Manager for production)

### ❌ DON'T:
- ❌ Share `.env` file in chat, email, or public repositories
- ❌ Hardcode API keys in source code
- ❌ Commit `.env` to Git
- ❌ Use production keys in development

---

## Troubleshooting

### Issue: "GROQ_API_KEY not found"
**Solution:**
1. Verify `.env` file exists in project root
2. Check that key is spelled correctly: `GROQ_API_KEY` (not `GROQ_API` or `GROQ_KEY`)
3. Ensure no extra spaces: `GROQ_API_KEY=your_key` (not `GROQ_API_KEY = your_key`)
4. Restart the application after creating/updating `.env`

### Issue: "Invalid API key" or "Authentication failed"
**Solution:**
1. Verify the API key is correct (copy-paste again from Groq Console)
2. Check if the key has expired or been revoked
3. Ensure you're using the correct key format (starts with `gsk_`)
4. Check your Groq account has sufficient credits/quota

### Issue: "Model download rate limit"
**Solution:**
1. Add `HUGGINGFACEHUB_API_TOKEN` to `.env`
2. Or wait for rate limit to reset
3. Or use a VPN/proxy (if allowed by your organization)

### Issue: Application works locally but not on VM
**Solution:**
1. Ensure `.env` file is copied to VM
2. Check file permissions: `chmod 600 .env`
3. Verify the file is in the correct location (project root)
4. Check if `python-dotenv` is installed: `pip list | grep python-dotenv`

---

## Example .env File

```env
# Required
GROQ_API_KEY=gsk_abc123def456ghi789jkl012mno345pqr678stu901vwx234yz

# Optional (uncomment if needed)
# HUGGINGFACEHUB_API_TOKEN=hf_xyz789abc123def456ghi789jkl012mno345pqr
```

---

## Quick Reference

| Variable | Required | Purpose | Get From |
|----------|----------|---------|----------|
| `GROQ_API_KEY` | ✅ Yes | LLM API access | https://console.groq.com/ |
| `HUGGINGFACEHUB_API_TOKEN` | ❌ No | Model downloads | https://huggingface.co/settings/tokens |

---

## Next Steps

After setting up your `.env` file:
1. ✅ Verify keys are loaded: Run the test command above
2. ✅ Start the application: `./start.sh` or `streamlit run app/app.py`
3. ✅ Test a recommendation to ensure API key works
4. ✅ Deploy to GCP VM (see `GCP_VM_DEPLOYMENT.md`)

---

**Need Help?**
- Groq API Issues: https://console.groq.com/docs
- HuggingFace Issues: https://huggingface.co/docs
- Project Issues: Check `GCP_VM_DEPLOYMENT.md` troubleshooting section

