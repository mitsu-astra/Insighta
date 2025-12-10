# Production-ready Server Dockerfile for Railway

FROM node:20-alpine

# Set working directory to project root
WORKDIR /app

# Copy all package files from root and server
COPY package*.json ./
COPY server/package*.json ./server/

# Install root dependencies and server dependencies
RUN npm install && \
    cd server && npm install && \
    cd ..

# Copy all source code
COPY server/ ./server/
COPY . .

# Create necessary directories
RUN mkdir -p logs

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:' + (process.env.PORT || 4000) + '/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Expose port
ENV NODE_ENV=production
ENV PORT=${PORT:-4000}
EXPOSE ${PORT}

# Start server using root package.json script
CMD ["npm", "start"]

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
