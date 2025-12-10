# Production-ready Server Dockerfile for Railway

FROM node:20-alpine

WORKDIR /app/server

# Copy package files from server directory
COPY server/package*.json ./

# Install all dependencies
RUN npm install

# Copy server source code
COPY server/ .

# Create necessary directories
RUN mkdir -p logs

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:' + (process.env.PORT || 4000) + '/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Expose port
ENV PORT=${PORT:-4000}
EXPOSE ${PORT}

# Start server
CMD ["npm", "start"]
