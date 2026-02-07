#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Social Media Backend - Quick Setup                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check for Node.js
echo -e "${YELLOW}Checking Node.js installation...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js is not installed. Please install Node.js v16 or higher.${NC}"
    exit 1
fi
NODE_VERSION=$(node -v)
echo -e "${GREEN}✓ Node.js $NODE_VERSION found${NC}"

# Check for npm
echo -e "${YELLOW}Checking npm installation...${NC}"
if ! command -v npm &> /dev/null; then
    echo -e "${RED}✗ npm is not installed.${NC}"
    exit 1
fi
NPM_VERSION=$(npm -v)
echo -e "${GREEN}✓ npm $NPM_VERSION found${NC}"

# Install dependencies
echo -e "\n${YELLOW}Installing dependencies...${NC}"
npm install
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dependencies installed successfully${NC}"
else
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi

# Check for .env file
echo -e "\n${YELLOW}Checking environment configuration...${NC}"
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo -e "${YELLOW}⚠ Please update .env with your database credentials${NC}"
else
    echo -e "${GREEN}✓ .env file already exists${NC}"
fi

# Check for Docker
echo -e "\n${YELLOW}Checking for Docker (optional)...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker found${NC}"
    echo -e "${BLUE}You can run 'docker-compose up -d' to start PostgreSQL${NC}"
else
    echo -e "${YELLOW}⚠ Docker not found. Please install PostgreSQL manually.${NC}"
fi

echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                Setup Complete!                           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo -e "1. Start PostgreSQL:"
echo -e "   ${BLUE}docker-compose up -d${NC} (if using Docker)"
echo -e "   or start your local PostgreSQL server"
echo ""
echo -e "2. Run migrations:"
echo -e "   ${BLUE}npm run migration:run${NC}"
echo ""
echo -e "3. Start the development server:"
echo -e "   ${BLUE}npm run dev${NC}"
echo ""
echo -e "4. Run tests:"
echo -e "   ${BLUE}./test.sh${NC}"
echo ""
