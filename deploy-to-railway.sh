#!/bin/bash
# Railway Deployment Script for Insighta

echo "🚀 Insighta Railway Deployment Setup"
echo "====================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if Railway CLI is installed
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! npm list -g @railway/cli &> /dev/null; then
    echo -e "${RED}❌ Railway CLI not found. Installing...${NC}"
    npm install -g @railway/cli
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install Railway CLI${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✅ Railway CLI is installed${NC}\n"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git repository not initialized${NC}"
    read -p "Initialize git? (y/n) " git_init
    if [ "$git_init" = "y" ]; then
        git init
        git add .
        git commit -m "Initial commit for Railway deployment"
    fi
fi

# Login to Railway
echo -e "${YELLOW}🔐 Authenticating with Railway...${NC}"
railway login
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to login to Railway${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Successfully logged in to Railway\n${NC}"

# Initialize Railway project
echo -e "${YELLOW}⚙️  Initializing Railway project...${NC}"
read -p "Enter project name (default: insighta): " project_name
project_name=${project_name:-insighta}

railway init --name "$project_name"
echo -e "${GREEN}✅ Railway project initialized\n${NC}"

# Display environment variables template
echo -e "${CYAN}📝 Environment Variables Required${NC}"
echo "===================================="
echo ""
echo -e "${YELLOW}Please set these environment variables in Railway Dashboard:\n${NC}"

echo -e "${GREEN}Server Variables:${NC}"
echo "  MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net"
echo "  JWT_SECRET=<generate-random-string>"
echo "  CLIENT_URL=https://your-app-url.railway.app"
echo "  REDIS_HOST=<railway-redis-host>"
echo "  REDIS_PORT=6379"
echo "  NODE_ENV=production"
echo "  PORT=4000"

echo ""
echo -e "${GREEN}Client Variables:${NC}"
echo "  VITE_API_URL=https://your-api-url.railway.app"
echo "  VITE_APP_NAME=AI CRM Feedback"

echo ""
echo -e "${GREEN}Feedback Pipeline Variables:${NC}"
echo "  MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net"
echo "  MONGO_DB=feedback_pipeline"
echo "  REDIS_HOST=<railway-redis-host>"
echo "  REDIS_PORT=6379"
echo "  AI_API_KEY=<huggingface-api-key>"
echo "  WORKER_CONCURRENCY=5"
echo "  API_PORT=3005"
echo "  WORKER_METRICS_PORT=3006"

# Display next steps
echo ""
echo -e "${CYAN}📋 Next Steps:${NC}"
echo "===================================="
echo ""

echo -e "${GREEN}1. Set environment variables:${NC}"
echo "   railway variables set <KEY> <VALUE>"
echo ""

echo -e "${GREEN}2. Push to GitHub:${NC}"
echo "   git add ."
echo "   git commit -m 'Setup Railway deployment'"
echo "   git push origin main"
echo ""

echo -e "${GREEN}3. Monitor deployment:${NC}"
echo "   railway logs"
echo ""

echo -e "${GREEN}4. View project:${NC}"
echo "   railway open"
echo ""

echo -e "${GREEN}5. Initialize database:${NC}"
echo "   railway run npm run seed:admin"
echo ""

echo -e "${GREEN}✅ Setup complete! Your project is ready for Railway deployment.${NC}"
echo -e "${CYAN}📖 For more info, see: RAILWAY_DEPLOYMENT.md${NC}"
