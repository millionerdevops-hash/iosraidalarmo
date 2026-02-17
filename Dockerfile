FROM node:20

WORKDIR /app

# Full node image usually includes python3/make/g++, but let's be safe.
# We also don't need to install them manually if we use the full image, usually.
# But just in case, we update.
RUN apt-get update && apt-get install -y python3 make g++

# Install dependencies
COPY server/package.json ./
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
