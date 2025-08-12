#!/bin/bash

# Simple deployment script for EC2 + Docker Compose
set -e

# Configuration
EC2_KEY_PATH=${EC2_KEY_PATH:-"~/.ssh/aws-ec2-key.pem"}
EC2_USER="ec2-user"
EC2_HOST=${EC2_HOST:-""}

if [ -z "$EC2_HOST" ]; then
    echo "❌ EC2_HOST environment variable is required"
    echo "Usage: EC2_HOST=your-ec2-ip ./scripts/deploy-to-ec2.sh"
    exit 1
fi

echo "🚀 Starting deployment to EC2..."
echo "Host: $EC2_HOST"
echo "Key: $EC2_KEY_PATH"

# Create deployment package
echo "📦 Creating deployment package..."
rm -rf /tmp/aws-ec2-deploy
mkdir -p /tmp/aws-ec2-deploy

# Copy application files - preserve app directory structure
cp -r app /tmp/aws-ec2-deploy/app
cp package*.json /tmp/aws-ec2-deploy/
cp docker-compose.yml /tmp/aws-ec2-deploy/
cp Dockerfile /tmp/aws-ec2-deploy/

# Upload files to EC2
echo "⬆️  Uploading files to EC2..."
ssh -i "$EC2_KEY_PATH" "$EC2_USER@$EC2_HOST" "mkdir -p /home/ec2-user/aws-ec2"
scp -i "$EC2_KEY_PATH" -r /tmp/aws-ec2-deploy/* "$EC2_USER@$EC2_HOST:/home/ec2-user/aws-ec2/"

# Restart services using Docker
echo "🔄 Restarting services using Docker..."
ssh -i "$EC2_KEY_PATH" "$EC2_USER@$EC2_HOST" << 'EOF'
cd /home/ec2-user/aws-ec2
docker-compose down
docker-compose up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Tables are created automatically when the app starts
echo "✅ App will create database tables automatically on startup"
EOF

echo "✅ Deployment completed!"
echo "🌐 Application available at: http://$EC2_HOST:3000"
echo "📋 API docs at: http://$EC2_HOST:3000/api-docs"
echo "❤️  Health check at: http://$EC2_HOST:3000/health"

# Cleanup
rm -rf /tmp/aws-ec2-deploy