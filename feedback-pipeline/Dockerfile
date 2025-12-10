# Production-ready Worker Dockerfile for Railway

FROM node:20-alpine

WORKDIR /app/feedback-pipeline

# Copy package files from feedback-pipeline directory
COPY feedback-pipeline/package*.json ./

# Install all dependencies
RUN npm install

# Copy source code
COPY feedback-pipeline/ .

# Create non-root user
USER node

# Expose metrics port
EXPOSE 3005 3006

# Default to worker, can be overridden with start:api
CMD ["npm", "run", "start:worker"]
