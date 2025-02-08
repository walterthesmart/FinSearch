#!/bin/bash

# setup.sh
echo "🚀 Setting up FinSearch project..."

# Create main project directory
mkdir finsearch
cd finsearch

# Create README
echo "# FinSearch
An AI-powered financial research tool using Next.js, FastAPI, and Hugging Face models.

## Setup
1. Run \`./setup.sh\`
2. Navigate to frontend: \`cd frontend\` and run \`npm run dev\`
3. Navigate to backend: \`cd backend\` and run \`uvicorn app.main:app --reload\`

## Features
- Real-time sentiment analysis
- Financial news aggregation
- Stock data visualization
- AI-powered market insights" > README.md

# Initialize frontend
echo "📦 Setting up frontend..."
npx create-next-app@latest frontend --typescript --tailwind --eslint --no-git
cd frontend

# Install additional frontend dependencies
npm install react-icons @types/react-icons recharts @radix-ui/react-tabs lucide-react

# Create frontend directory structure
mkdir -p src/components/ui/{dashboard,common,forms}
mkdir -p src/lib src/types

# Create basic component files
cd src/components/ui
mkdir -p dashboard common forms

cd dashboard
echo "export { default as Dashboard } from './Dashboard';" > index.ts
echo "export { default as SentimentChart } from './SentimentChart';" > SentimentChart.tsx
echo "export { default as StockInfo } from './StockInfo';" > StockInfo.tsx
echo "export { default as NewsFeeds } from './NewsFeeds';" > NewsFeeds.tsx

cd ../common
echo "export { default as Navbar } from './Navbar';" > index.ts
echo "export { default as Sidebar } from './Sidebar';" > Sidebar.tsx
echo "export { default as Loading } from './Loading';" > Loading.tsx

cd ../forms
echo "export { default as SearchForm } from './SearchForm';" > index.ts

cd ../../../..

# Initialize backend
echo "🐍 Setting up backend..."
mkdir backend
cd backend

# Create Python virtual environment
python -m venv venv
source venv/bin/activate  # On Windows, use: venv\Scripts\activate

# Install backend dependencies
pip install fastapi uvicorn transformers torch pandas yfinance python-dotenv httpx pytest

# Create backend directory structure
mkdir -p app/{api/{endpoints,},core,models,services} tests

# Create __init__.py files
touch app/__init__.py
touch app/api/__init__.py
touch app/api/endpoints/__init__.py
touch app/core/__init__.py
touch app/models/__init__.py
touch app/services/__init__.py
touch tests/__init__.py

# Create requirements.txt
pip freeze > requirements.txt

cd ..

# Create Docker configuration
echo "🐳 Setting up Docker configuration..."
mkdir docker
cd docker

# Create docker-compose.yml
echo "version: '3.8'

services:
  frontend:
    build:
      context: ../frontend
      dockerfile: ./frontend.Dockerfile
    ports:
      - '3000:3000'
    environment:
      - NEXT_PUBLIC_API_URL=http://backend:8000/api
    depends_on:
      - backend

  backend:
    build:
      context: ../backend
      dockerfile: ./backend.Dockerfile
    ports:
      - '8000:8000'
    environment:
      - MODEL_PATH=/app/models
      - ENVIRONMENT=production" > docker-compose.yml

# Create Dockerfiles
echo "FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ['npm', 'start']" > frontend.Dockerfile

echo "FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ['uvicorn', 'app.main:app', '--host', '0.0.0.0', '--port', '8000']" > backend.Dockerfile

cd ..

# Create .gitignore
echo "# Dependencies
node_modules/
__pycache__/
venv/

# Environment
.env
.env.local

# Build
.next/
dist/
build/

# IDE
.vscode/
.idea/

# Misc
.DS_Store" > .gitignore

# Initialize git repository
git init
git add .
git commit -m "Initial commit: Project setup"

echo "✨ FinSearch project setup complete! ✨

Next steps:
1. cd frontend && npm run dev     # Start frontend development server
2. cd backend && uvicorn app.main:app --reload  # Start backend server

To push to GitHub:
1. Create a new repository at https://github.com/new
2. git remote add origin YOUR_REPO_URL
3. git push -u origin main"