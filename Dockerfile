# 使用 Node 18 Alpine 版本
FROM node:18-alpine

# 安装最小必要的系统依赖
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
    NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=128"

# 设置工作目录
WORKDIR /app

# 创建最简单的 package.json
RUN echo '{ \
  "name": "remotion-test", \
  "version": "1.0.0", \
  "scripts": { \
    "start": "node server.js" \
  }, \
  "dependencies": { \
    "express": "^4.18.0" \
  } \
}' > package.json

# 创建最简单的测试服务器
RUN echo 'const express = require("express"); \
 \
const app = express(); \
app.use(express.json()); \
 \
// 健康检查端点 \
app.get("/health", (req, res) => { \
  res.json({ \
    status: "ok", \
    message: "Remotion Test Server is running", \
    timestamp: new Date().toISOString() \
  }); \
}); \
 \
// 测试端点 \
app.get("/test", (req, res) => { \
  res.json({ \
    message: "Test endpoint working", \
    memory: process.memoryUsage(), \
    uptime: process.uptime() \
  }); \
}); \
 \
const PORT = process.env.PORT || 3000; \
app.listen(PORT, () => { \
  console.log(`Test server running on port ${PORT}`); \
  console.log(`Memory usage: ${JSON.stringify(process.memoryUsage())}`); \
});' > server.js

# 安装依赖
RUN npm install --production

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
