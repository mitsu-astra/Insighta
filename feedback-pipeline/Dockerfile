# Production-ready Worker Dockerfile for Railway

FROM node:20-alpine

WORKDIR /app

# Copy all package files
COPY package*.json ./
COPY feedback-pipeline/package*.json ./feedback-pipeline/

# Install dependencies
RUN cd feedback-pipeline && npm install

# Copy source code
COPY feedback-pipeline/ ./feedback-pipeline/
COPY . .

# Create non-root user
USER node

# Expose metrics port
EXPOSE 3005 3006

# Start worker or API (depends on railway.toml startCommand)
CMD ["npm", "run", "start:worker"]

# Create non-root user
USER node

# Expose metrics port
EXPOSE 3005 3006

# Default to worker, can be overridden with start:api
CMD ["npm", "run", "start:worker"]
