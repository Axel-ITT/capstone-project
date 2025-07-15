#!/bin/bash
# Run as root

yum update -y
yum clean metadata
yum install -y nginx --skip-broken
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
  pm2 start \$(which node-red) -- -v
  pm2 save
  pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -1 > /tmp/pm2-startup.sh
"

# Run the pm2 startup command printed from above
bash /tmp/pm2-startup.sh



