# Production-ready Worker/API Dockerfile for Railway
# v3 - Fixed dependencies installation

FROM node:20-alpine

WORKDIR /app

# Copy feedback-pipeline package files ONLY
COPY feedback-pipeline/package*.json ./feedback-pipeline/

# Install dependencies  
RUN cd feedback-pipeline && npm install --omit=dev

# Copy source code
COPY feedback-pipeline/ ./feedback-pipeline/

# Create non-root user
RUN addgroup -g 1000 node && adduser -D -u 1000 -G node node
USER node

# Expose metrics ports
EXPOSE 3005 3006

# Start worker or API (determined by startCommand in railway.toml)
# Default to worker if not overridden
CMD ["node", "feedback-pipeline/worker.js"]
