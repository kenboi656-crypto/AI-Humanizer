#!/bin/bash

# AI-HUMANIZER HOSTINGER DEPLOYMENT SCRIPT
# Run this on your Hostinger server via SSH

echo "🚀 Starting AI-Humanizer Hostinger Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js 18...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs npm
else
    echo -e "${GREEN}✓ Node.js $(node -v) already installed${NC}"
fi

# Navigate to public_html or your domain directory
echo -e "${YELLOW}Setting up project directory...${NC}"

if [ -z "$1" ]; then
    DOMAIN_DIR="$HOME/public_html"
else
    DOMAIN_DIR="$1"
fi

echo "Using directory: $DOMAIN_DIR"

# Create directory if it doesn't exist
if [ ! -d "$DOMAIN_DIR" ]; then
    mkdir -p "$DOMAIN_DIR"
    echo -e "${GREEN}✓ Created $DOMAIN_DIR${NC}"
fi

cd "$DOMAIN_DIR"

# Initialize git if needed
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Cloning repository...${NC}"
    git clone https://github.com/kenboi656-crypto/AI-Humanizer.git .
else
    echo -e "${YELLOW}Updating existing repository...${NC}"
    git pull origin main
fi

# Install dependencies
echo -e "${YELLOW}Installing npm dependencies...${NC}"
npm install

# Create .env file
echo -e "${YELLOW}Setting up environment variables...${NC}"

if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠️  IMPORTANT: Edit .env with your GEMINI_API_KEY${NC}"
    echo -e "${YELLOW}Run: nano .env${NC}"
    echo ""
    read -p "Press Enter after setting GEMINI_API_KEY in .env"
fi

# Build the application
echo -e "${YELLOW}Building application...${NC}"
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build successful${NC}"

# Setup SSL certificate (if not exists)
echo -e "${YELLOW}Setting up SSL certificate...${NC}"
echo "SSL certificates are automatically managed by Hostinger."
echo "Ensure your domain points to this server in Hostinger hPanel."

# Create startup script
echo -e "${YELLOW}Creating startup script...${NC}"

cat > start-app.sh << 'EOF'
#!/bin/bash
cd "$HOME/public_html"
export NODE_ENV=production
node server.js
EOF

chmod +x start-app.sh

echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo "1. Edit .env file with your GEMINI_API_KEY (if not done)"
echo "   nano .env"
echo ""
echo "2. Start the application:"
echo "   node server.js"
echo ""
echo "3. Or use PM2 (recommended):"
echo "   npm install -g pm2"
echo "   pm2 start server.js --name 'ai-humanizer'"
echo "   pm2 startup"
echo "   pm2 save"
echo ""
echo "4. Test your deployment:"
echo "   curl https://your-domain.com/api/health"
echo ""
echo -e "${GREEN}Deployment configuration complete!${NC}"