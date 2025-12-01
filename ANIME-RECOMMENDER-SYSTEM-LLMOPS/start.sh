#!/bin/bash

# Start script for Anime Recommender System

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
else
    echo "Virtual environment not found. Please run deploy.sh first."
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file not found!"
    echo "Please create a .env file with your GROQ_API_KEY"
    exit 1
fi

# Start Streamlit app
echo "Starting Anime Recommender System..."
echo "Access the app at: http://<VM_EXTERNAL_IP>:8501"
echo ""
streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0

