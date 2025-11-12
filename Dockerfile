# Use an alpine Node.js runtime as a parent image
FROM node:14-alpine

# Set working directory
WORKDIR /usr/src/app/client

# Install system dependencies (needed for some npm builds)
RUN apk add --no-cache python3 make g++

# Copy and install dependencies for the client

COPY client/package*.json ./

# Ensure webpack is installed (if not part of package.json)
RUN npm install
RUN npm install webpack webpack-cli --save-dev

# Copy the rest of the client source
COPY client/ ./

# Give permission to webpack binary just in case
RUN chmod +x node_modules/.bin/webpack

# Build the client app
RUN npm run build

# Switch to the server
WORKDIR /usr/src/app/server
COPY server/package*.json ./
RUN npm install

# Copy server files
COPY server/ ./

# Expose port
EXPOSE 5000

# Start the server
CMD ["npm", "start"]
