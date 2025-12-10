# Production-ready Worker Dockerfile for Railway

FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm install --production

# Copy source code
COPY . .

# Create non-root user
USER node

# Expose metrics port
EXPOSE 3005 3006

# Default to worker, can be overridden with start:api
CMD ["npm", "run", "start:worker"]
