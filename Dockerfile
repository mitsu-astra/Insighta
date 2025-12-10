# Main entry point Dockerfile for Railway
# This triggers Dockerfile build mode instead of npm mode
# Actual services are defined in railway.toml

FROM node:20-alpine

WORKDIR /app

# Copy server dependencies
COPY server/package*.json ./server/

# Install server dependencies
RUN cd server && npm install --omit=dev

# Copy server code
COPY server/ ./server/

# Create logs directory
RUN mkdir -p logs

# Set environment
ENV NODE_ENV=production
ENV PORT=4000

EXPOSE 4000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:4000/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" || exit 1

# Start server directly (this Dockerfile is only used for Railway detection)
CMD ["node", "server/server.js"]
