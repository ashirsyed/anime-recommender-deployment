# API Keys Quick Reference

## Required Keys

### 🔑 GROQ_API_KEY (REQUIRED)
```
Get from: https://console.groq.com/
Format: GROQ_API_KEY=gsk_xxxxxxxxxxxxx
Status: ⚠️ REQUIRED - App won't work without this
```

## Optional Keys

### 🔑 HUGGINGFACEHUB_API_TOKEN (OPTIONAL)
```
Get from: https://huggingface.co/settings/tokens
Format: HUGGINGFACEHUB_API_TOKEN=hf_xxxxxxxxxxxxx
Status: ✅ OPTIONAL - Only needed for private models or rate limit avoidance
```

## Quick Setup

```bash
# 1. Copy template
cp .env.example .env

# 2. Edit and add your keys
nano .env

# 3. Set secure permissions
chmod 600 .env

# 4. Verify (should show "SET")
python3 -c "from dotenv import load_dotenv; import os; load_dotenv(); print('GROQ_API_KEY:', 'SET' if os.getenv('GROQ_API_KEY') else 'NOT SET')"
```

## .env File Template

```env
GROQ_API_KEY=your_groq_api_key_here
# HUGGINGFACEHUB_API_TOKEN=your_huggingface_token_here  # Optional
```

For detailed instructions, see `ENV_SETUP_GUIDE.md`

