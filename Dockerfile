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
    NODE_OPTIONS="--max-old-space-size=256"

# 设置工作目录
WORKDIR /app

# 创建简单的 package.json
RUN echo '{ \
  "name": "remotion-api-server", \
  "version": "1.0.0", \
  "scripts": { \
    "start": "node server.js" \
  }, \
  "dependencies": { \
    "remotion": "^4.0.0", \
    "@remotion/renderer": "^4.0.0", \
    "react": "^18.0.0", \
    "react-dom": "^18.0.0", \
    "express": "^4.18.0" \
  } \
}' > package.json

# 创建简单的 Express 服务器
RUN echo 'const express = require("express"); \
const { renderMedia } = require("@remotion/renderer"); \
const path = require("path"); \
 \
const app = express(); \
app.use(express.json()); \
 \
// 健康检查端点 \
app.get("/health", (req, res) => { \
  res.json({ status: "ok", message: "Remotion API Server is running" }); \
}); \
 \
// 渲染端点 \
app.post("/render", async (req, res) => { \
  try { \
    const { compositionId = "MyComposition", outputPath = "/tmp/output.mp4" } = req.body; \
     \
    await renderMedia({ \
      composition: { \
        id: compositionId, \
        width: 1920, \
        height: 1080, \
        fps: 30, \
        durationInFrames: 30, \
      }, \
      serveUrl: "http://localhost:3000", \
      codec: "h264", \
      outputLocation: outputPath, \
      inputProps: {}, \
    }); \
     \
    res.json({ success: true, outputPath }); \
  } catch (error) { \
    console.error("Render error:", error); \
    res.status(500).json({ error: error.message }); \
  } \
}); \
 \
const PORT = process.env.PORT || 3000; \
app.listen(PORT, () => { \
  console.log(`Remotion API Server running on port ${PORT}`); \
});' > server.js

# 安装依赖
RUN npm install --legacy-peer-deps --production

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
