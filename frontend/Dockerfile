# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Copy the build output to the Nginx html directory
COPY index.html /usr/share/nginx/html/

# rev proxy config
COPY nginx.conf /etc/nginx/conf.d/default.conf

#COPY styles.css /usr/share/nginx/html/
#COPY script.js /usr/share/nginx/html/
#ARG BACKEND_URL
#ENV BACKEND_URL=$BACKEND_URL

# Expose port 80
EXPOSE 80
