# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

ARG API_KEY

ENV API_KEY=$API_KEY

# Expose the port your app runs on
EXPOSE 5000

# Define the command to run your application
CMD [ "node", "backend_axios.js" ]