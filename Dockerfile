# Stage 1: Build the Angular application
FROM node:14-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the application with NGINX
FROM nginx:alpine

# Remove default configuration files
RUN rm -rf /etc/nginx/conf.d/*

# Copy the built application from the previous stage
COPY --from=build /app/dist/my-angular-app /usr/share/nginx/html

# Copy NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Check NGINX configuration for errors
RUN nginx -t

# Expose port 80
EXPOSE 80

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]