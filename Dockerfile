FROM node:18-alpine

WORKDIR /app

# Install dependencies
COPY server/package.json server/package-lock.json ./
RUN npm install

# Copy source code
COPY server/ .

# Create data directory for persistence (if volume mounted)
RUN mkdir -p /data

# Set environment variables
ENV PORT=8080
ENV DB_PATH=/data/database.sqlite

EXPOSE 8080

CMD ["node", "index.js"]
