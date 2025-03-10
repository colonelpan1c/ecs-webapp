# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Copy the build output to the Nginx html directory
COPY index.html /usr/share/nginx/html/

# rev proxy config
COPY nginx.conf /etc/nginx/conf.d/default.conf


ARG BACKEND_URL

ENV BACKEND_URL=$BACKEND_URL

# Expose port 80
EXPOSE 80
EXPOSE 443
