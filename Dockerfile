# Stage 1: Build the Angular application
FROM node:22.11.0 AS build

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

# Copy the built application from the previous stage
COPY --from=build /app/dist/iheb-front /usr/share/nginx/html

# Copy NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf
RUN ls -la /etc/nginx/conf.d/
RUN cat /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]