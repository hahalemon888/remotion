# 使用 Node 18（Remotion 推荐版本）
FROM node:18-alpine

# 安装必要的系统依赖
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# 设置 Puppeteer 使用系统 Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 设置工作目录
WORKDIR /app

# 复制 package.json 文件
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装依赖
RUN npm install --legacy-peer-deps

# 复制源代码
COPY . .

# 构建项目（如果需要）
RUN npm run build || echo "No build script found, skipping..."

# 切换到 studio-server 目录
WORKDIR /app/packages/studio-server

# 验证 remotion CLI 是否正确安装
RUN ls -la node_modules/.bin/ | grep remotion || echo "Remotion CLI not found in .bin"

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
