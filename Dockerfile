# 使用 Node 18 Alpine 版本
FROM node:18-alpine

# 安装系统依赖
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# 设置环境变量
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_ENV=production

# 设置工作目录
WORKDIR /app

# 创建 package.json（简化版本）
RUN echo '{ \
  "name": "remotion-server", \
  "version": "1.0.0", \
  "scripts": { \
    "start": "remotion studio --port=3000" \
  }, \
  "dependencies": { \
    "remotion": "^4.0.0", \
    "@remotion/cli": "^4.0.0", \
    "@remotion/renderer": "^4.0.0" \
  } \
}' > package.json

# 安装依赖
RUN npm install --legacy-peer-deps

# 复制源代码（如果需要）
COPY . .

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npx", "remotion", "studio", "--port=3000"]
