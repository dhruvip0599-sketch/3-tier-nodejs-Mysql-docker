# Use an alpine Node.js runtime as a parent image
FROM node:14-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy and install dependencies for the client
WORKDIR /usr/src/app/client
COPY client/package*.json ./

# Ensure webpack is installed (if not part of package.json)
RUN npm install && npm install webpack webpack-cli --save-dev

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
EXPOSE 8080

# Start the server
CMD ["npm", "start"]
