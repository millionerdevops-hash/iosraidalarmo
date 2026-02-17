FROM node:18-slim

WORKDIR /app

# Install build dependencies for native modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY server/package.json ./
# Delete package-lock.json if it exists (force fresh install for Linux)
# We do this by NOT copying it, or ignoring it.
# Better: Just copy package.json and run install
RUN npm install

# Copy source code
COPY server/ .

# Create data directory for persistence
RUN mkdir -p /data

# Set environment variables
ENV PORT=8080
ENV DB_PATH=/data/database.sqlite
ENV NODE_ENV=production

EXPOSE 8080

CMD ["node", "index.js"]
