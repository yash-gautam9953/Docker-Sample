# 🚀 Start with Node.js 20 (latest stable version) on lightweight Alpine Linux
FROM node:20-alpine

# 📁 Create and set our app folder inside the container
WORKDIR /app

# 📋 Copy only package files first (this makes rebuilds faster!)
# When you change your code, Docker won't re-install all packages
COPY package*.json ./

# 📦 Install only the packages we need for production (saves space and time)
# Also clean up npm cache to make the image smaller
RUN npm ci --only=production && npm cache clean --force

# 📂 Now copy all your application code
COPY . .

# 🔒 Create a regular user (not root) for better security
# Root users in containers can be a security risk
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 👤 Give ownership of our app folder to the nodejs user and switch to it
RUN chown -R nodejs:nodejs /app
USER nodejs

# 🌐 Tell Docker that our app uses port 3000
# This doesn't actually open the port, just documents it
EXPOSE 3000

# 🏥 Add a health check so Docker knows if our app is working
# Every 30 seconds, try to connect to our app
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# 🎯 Start our app! Using 'node' directly is better than 'npm start'
# This helps with stopping the container properly
CMD ["node", "index.js"]