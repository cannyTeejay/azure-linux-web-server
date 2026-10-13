#!/bin/bash

set -e

echo "======================================"
echo " Azure Linux Web Server Setup"
echo "======================================"

echo ""
echo "[1/6] Updating package lists..."
sudo apt update

echo ""
echo "[2/6] Installing Nginx..."
sudo apt install -y nginx

echo ""
echo "[3/6] Configuring UFW..."

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp

echo ""
echo "[4/6] Enabling services..."

sudo systemctl enable nginx
sudo systemctl start nginx

echo ""
echo "[5/6] Checking Nginx..."

if systemctl is-active --quiet nginx; then
    echo "Nginx is running."
else
    echo "ERROR: Nginx is not running."
    exit 1
fi

echo ""
echo "[6/6] Checking firewall..."

sudo ufw status

echo ""
echo "======================================"
echo " Server setup completed successfully"
echo "======================================"