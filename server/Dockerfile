# Production-ready Server Dockerfile for Railway

FROM node:20-alpine

# Set working directory to project root
WORKDIR /app

# Copy all package files from root and server
COPY package*.json ./
COPY server/package*.json ./server/

# Install root dependencies and server dependencies
RUN npm install --omit=dev && \
    cd server && npm install --omit=dev && \
    cd ..

# Copy all source code
COPY server/ ./server/

# Create necessary directories
RUN mkdir -p logs

# Set environment variables
ENV NODE_ENV=production
ENV PORT=4000

# Expose port
EXPOSE 4000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:4000/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" || exit 1

# Start server directly
CMD ["node", "server/server.js"]
