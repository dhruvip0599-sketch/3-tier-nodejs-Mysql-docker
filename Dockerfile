# ============================
# Stage 1: Build client
# ============================
FROM node:14-alpine AS client-build

# Install dependencies required for building
RUN apk add --no-cache python3 make g++ bash

# Set working directory
WORKDIR /usr/src/app/client

# Copy package files and install dependencies
COPY client/package*.json ./
RUN npm install

# Ensure webpack tools are installed
RUN npm install webpack webpack-cli --save-dev

# Copy remaining source files
COPY client/ ./

# Ensure webpack binary is executable
RUN chmod +x node_modules/.bin/webpack

# Run the build
RUN npx webpack --mode production


# ============================
# Stage 2: Build server
# ============================
FROM node:14-alpine AS server-build

RUN apk add --no-cache python3 make g++

WORKDIR /usr/src/app/server

COPY server/package*.json ./
RUN npm install

COPY server/ ./

# Copy built client from previous stage
COPY --from=client-build /usr/src/app/client/dist ./public

EXPOSE 5000

CMD ["npm", "start"]
