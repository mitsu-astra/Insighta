# Production-ready Worker/API Dockerfile for Railway

FROM node:20-alpine

WORKDIR /app

# Copy all package files
COPY package*.json ./
COPY feedback-pipeline/package*.json ./feedback-pipeline/

# Install dependencies  
RUN npm install && \
    cd feedback-pipeline && npm install && \
    cd ..

# Copy source code
COPY feedback-pipeline/ ./feedback-pipeline/

# Create non-root user
RUN addgroup -g 1000 node && adduser -D -u 1000 -G node node
USER node

# Expose metrics ports
EXPOSE 3005 3006

# Start worker or API (depends on railway.toml startCommand)
CMD ["npm", "run", "start:worker"]
