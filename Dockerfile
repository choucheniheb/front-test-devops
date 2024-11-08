# Stage 1: Build the Angular app
FROM node:22.11.0 AS build

WORKDIR /app

# Copy the package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the Angular project files
COPY . .

# Build the Angular project
RUN npm run build --prod

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the built app from the previous stage
COPY --from=build /app/dist/iheb-front /usr/share/nginx/html

# Expose the port Nginx will run on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
