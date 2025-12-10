# Production-ready Client Dockerfile for Railway

FROM node:18-alpine as build

WORKDIR /app

# Copy all package files
COPY package*.json ./
COPY client/package*.json ./client/

# Install dependencies
RUN npm install && \
    cd client && npm install && \
    cd ..

# Copy client source code
COPY client/ ./client/

# Build the application
RUN cd client && npm run build

# Nginx stage
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/client/dist /usr/share/nginx/html

# Copy nginx configuration
COPY client/nginx.conf /etc/nginx/conf.d/default.conf

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/index.html || exit 1

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
