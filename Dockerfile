FROM node:18-alpine

WORKDIR /app

# Install build dependencies for sqlite3 (native module)
RUN apk add --no-cache python3 make g++

# Install dependencies
COPY server/package.json server/package-lock.json ./
RUN npm install
# better-sqlite3 compiles automatically during install

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
