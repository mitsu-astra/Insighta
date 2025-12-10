# Production-ready Server Dockerfile for Railway
# v3 - Fixed dependencies installation

FROM node:20-alpine

# Set working directory to project root
WORKDIR /app

# Copy server package files ONLY
COPY server/package*.json ./server/

# Install server dependencies only
RUN cd server && npm install --omit=dev

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
