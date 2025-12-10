# Production-ready Client Dockerfile for Railway

FROM node:18-alpine as build

WORKDIR /app/client

# Copy package files from client directory
COPY client/package*.json ./

# Install dependencies
RUN npm install

# Copy client source code
COPY client/ .

# Build the application
RUN npm run build

# Nginx stage
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/index.html || exit 1

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
