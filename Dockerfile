FROM node:20-slim

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Expose the web server port
EXPOSE 80

# Start the application
CMD ["node", "server.js"]