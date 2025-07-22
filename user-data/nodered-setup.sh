#!/bin/bash
# Run as root

yum update -y
yum clean metadata

# Install Nginx
sudo amazon-linux-extras install nginx1.12 -y
sudo yum install -y nginx

# Configure Nginx to redirect traffic from port 80 to port 8080 (node-red)
cat <<EOT > /etc/nginx/conf.d/redirect.conf
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOT

# Start and enable Nginx
sudo systemctl enable nginx
sudo systemctl start nginx


# Install NVM as ec2-user
su - ec2-user -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"

# Load NVM and install Node, PM2, Node-RED
su - ec2-user -c "
  export NVM_DIR=\"/home/ec2-user/.nvm\"
  source \$NVM_DIR/nvm.sh
  nvm install node
  npm install -g npm@latest
  npm install -g pm2
  npm install -g multer
  npm install -g --unsafe-perm node-red
  npm install -g @flowfuse/node-red-dashboard
  pm2 start \$(which node-red) -- -v
  pm2 save
  pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -1 > /tmp/pm2-startup.sh
"

# Run the pm2 startup command printed from above
bash /tmp/pm2-startup.sh



