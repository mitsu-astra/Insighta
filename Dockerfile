# Multi-stage build for Railway deployment
# This Dockerfile builds and runs the entire stack

FROM node:20-alpine as base

WORKDIR /app

# Copy root package.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy all source code
COPY . .

# Build client
WORKDIR /app/client
RUN npm install && npm run build

# Set up server
WORKDIR /app/server
RUN npm install --production

# Set up feedback-pipeline
WORKDIR /app/feedback-pipeline
RUN npm install --production

# Final stage
FROM node:20-alpine

WORKDIR /app

# Copy entire application from build stage
COPY --from=base /app /app

# Create a startup script
RUN echo '#!/bin/sh\n\
set -e\n\
echo "Starting Insighta services..."\n\
cd /app/server\n\
npm start &\n\
SERVER_PID=$!\n\
cd /app/feedback-pipeline\n\
npm run start:api &\n\
API_PID=$!\n\
npm run start:worker &\n\
WORKER_PID=$!\n\
wait $SERVER_PID $API_PID $WORKER_PID\n\
' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

EXPOSE 4000 3005 3006 80

# Run the startup script
CMD ["/app/entrypoint.sh"]
