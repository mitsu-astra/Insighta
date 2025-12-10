# Multi-stage build - Client + Server
# Stage 1: Build React frontend
FROM node:18-alpine as client-build

WORKDIR /app

COPY client/package*.json ./client/

RUN cd client && npm ci

COPY client/ ./client/

# Build with API URL - use Railway URL in production
ARG VITE_API_URL=https://insighta.up.railway.app/api
ENV VITE_API_URL=$VITE_API_URL

RUN cd client && npm run build

# Stage 2: Build and run Server
FROM node:20-alpine

WORKDIR /app

# Copy server dependencies
COPY server/package*.json ./server/

RUN cd /app/server && npm ci --omit=dev

# Copy server source
COPY server/ /app/server/

# Copy built client from stage 1
COPY --from=client-build /app/client/dist /app/public/dist

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:8080/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" || exit 1

CMD ["node", "/app/server/server.js"]

