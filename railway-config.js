#!/usr/bin/env node
/**
 * Railway Deployment Configuration Helper
 * This script helps validate and set up environment variables for Railway deployment
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const requiredVariables = {
  server: [
    'MONGO_URI',
    'JWT_SECRET',
    'CLIENT_URL',
    'REDIS_HOST',
    'REDIS_PORT'
  ],
  client: [
    'VITE_API_URL'
  ],
  'feedback-pipeline': [
    'MONGO_URI',
    'REDIS_HOST',
    'REDIS_PORT',
    'AI_API_KEY'
  ]
};

const optionalVariables = {
  server: [
    'SMTP_USER',
    'SMTP_PASS',
    'SENDER_EMAIL',
    'NODE_ENV',
    'PORT'
  ],
  client: [
    'VITE_APP_NAME'
  ],
  'feedback-pipeline': [
    'AI_API_URL',
    'WORKER_CONCURRENCY',
    'JOB_TIMEOUT_MS',
    'MAX_RETRIES',
    'API_PORT',
    'WORKER_METRICS_PORT',
    'REDIS_PASSWORD'
  ]
};

function checkEnvironment() {
  console.log('🔍 Checking Railway Deployment Configuration...\n');

  let allGood = true;

  for (const [service, variables] of Object.entries(requiredVariables)) {
    console.log(`📦 Service: ${service}`);
    console.log(`   Required Variables:`);
    
    variables.forEach(variable => {
      const value = process.env[variable];
      if (value) {
        const masked = variable.includes('PASSWORD') || variable.includes('SECRET') || variable.includes('KEY') 
          ? '*'.repeat(Math.max(3, value.length - 4)) + value.slice(-4)
          : value;
        console.log(`   ✅ ${variable} = ${masked}`);
      } else {
        console.log(`   ❌ ${variable} = NOT SET`);
        allGood = false;
      }
    });
    console.log('');
  }

  if (!allGood) {
    console.log('⚠️  Some required variables are missing!\n');
    console.log('Set them using:');
    console.log('railway variables set <KEY> <VALUE>\n');
  } else {
    console.log('✅ All required variables are configured!\n');
  }

  console.log('Optional Variables:');
  for (const [service, variables] of Object.entries(optionalVariables)) {
    variables.forEach(variable => {
      const value = process.env[variable];
      if (value) {
        console.log(`✅ ${variable} is set`);
      }
    });
  }
}

function generateTemplate() {
  const template = `
# ============================================
# Railway Deployment Configuration Template
# ============================================

# --- SERVER (.env or Railway variables) ---
# MongoDB Atlas connection string
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/database_name

# JWT secret for token encryption (generate: openssl rand -base64 32)
JWT_SECRET=your-super-secret-jwt-key-here

# Frontend URL
CLIENT_URL=https://your-app-url.railway.app

# Redis configuration
REDIS_HOST=redis-host.railway.app
REDIS_PORT=6379
REDIS_PASSWORD=                    # Leave empty if no auth

# Optional: Email configuration
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-specific-password
SENDER_EMAIL=your-email@gmail.com

# Node environment
NODE_ENV=production
PORT=4000

# --- CLIENT (.env or Railway variables) ---
# API endpoint URL
VITE_API_URL=https://your-api-url.railway.app
VITE_APP_NAME=AI CRM Feedback

# --- FEEDBACK PIPELINE (.env or Railway variables) ---
# MongoDB (same as server)
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/database_name
MONGO_DB=feedback_pipeline

# Redis (same as server)
REDIS_HOST=redis-host.railway.app
REDIS_PORT=6379
REDIS_PASSWORD=

# AI/ML Configuration
AI_API_KEY=hf_your-huggingface-api-key-here
AI_API_URL=https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest

# Worker settings
WORKER_CONCURRENCY=5
JOB_TIMEOUT_MS=30000
MAX_RETRIES=3

# Ports
API_PORT=3005
WORKER_METRICS_PORT=3006
`;

  return template.trim();
}

function main() {
  const command = process.argv[2];

  if (command === 'check') {
    checkEnvironment();
  } else if (command === 'template') {
    console.log(generateTemplate());
  } else {
    console.log(`
Railway Configuration Helper

Usage:
  node railway-config.js check      Check current environment variables
  node railway-config.js template   Generate .env template

Examples:
  # Check what's configured
  node railway-config.js check

  # View the template
  node railway-config.js template > .env.railway

  # Set variables in Railway
  railway variables set MONGO_URI "mongodb+srv://..."
    `);
  }
}

main();
