#!/usr/bin/env node

import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const services = [
  {
    name: 'Server',
    cwd: path.join(__dirname, 'server'),
    command: 'npm',
    args: ['start'],
    port: process.env.PORT || 4000
  },
  {
    name: 'Feedback Pipeline API',
    cwd: path.join(__dirname, 'feedback-pipeline'),
    command: 'npm',
    args: ['run', 'start:api'],
    port: process.env.API_PORT || 3005
  },
  {
    name: 'Feedback Pipeline Worker',
    cwd: path.join(__dirname, 'feedback-pipeline'),
    command: 'npm',
    args: ['run', 'start:worker'],
    port: process.env.WORKER_METRICS_PORT || 3006
  }
];

let processCount = 0;

console.log('🚀 Starting Insighta services...\n');

services.forEach(service => {
  console.log(`Starting ${service.name} on port ${service.port}...`);
  
  const proc = spawn(service.command, service.args, {
    cwd: service.cwd,
    stdio: 'inherit',
    shell: true,
    env: { ...process.env }
  });

  proc.on('error', (err) => {
    console.error(`❌ Error starting ${service.name}:`, err);
  });

  proc.on('close', (code) => {
    console.log(`${service.name} exited with code ${code}`);
  });
});

// Handle graceful shutdown
process.on('SIGTERM', () => {
  console.log('\n📍 Received SIGTERM, shutting down gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('\n📍 Received SIGINT, shutting down gracefully...');
  process.exit(0);
});

console.log('\n✅ All services started. Press Ctrl+C to stop.\n');
