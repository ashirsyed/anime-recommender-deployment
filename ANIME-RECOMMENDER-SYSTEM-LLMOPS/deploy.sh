#!/bin/bash

# Anime Recommender System - GCP VM Deployment Script
# This script automates the deployment process on a GCP VM instance

set -e  # Exit on error

echo "========================================="
echo "Anime Recommender System - Deployment"
echo "========================================="

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Installing Python 3..."
    echo "This requires sudo privileges..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip python3-venv git
else
    echo "Python 3 is already installed: $(python3 --version)"
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Install the package
echo "Installing the package..."
pip install -e .

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "WARNING: .env file not found!"
    echo "Please create a .env file with your GROQ_API_KEY"
    echo "You can copy .env.example to .env and update it:"
    echo "  cp .env.example .env"
    echo "  nano .env"
    exit 1
fi

echo "========================================="
echo "Deployment setup complete!"
echo "========================================="
echo ""
echo "To start the application, run:"
echo "  source venv/bin/activate"
echo "  streamlit run app/app.py --server.port=8501 --server.address=0.0.0.0"
echo ""
echo "Or use the start.sh script:"
echo "  ./start.sh"
echo ""

