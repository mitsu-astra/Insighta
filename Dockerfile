# Main Dockerfile - Force rebuild with timestamp
# Build timestamp: 2025-01-01T00:00:00Z

FROM node:20-alpine

WORKDIR /app

# Only copy server package.json
COPY ./server/package*.json /app/server/

# Install dependencies in server
RUN cd /app/server && npm ci --omit=dev

# Copy server source
COPY ./server /app/server

ENV NODE_ENV=production
ENV PORT=4000

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:4000/api/public/stats', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" || exit 1

CMD ["node", "/app/server/server.js"]

