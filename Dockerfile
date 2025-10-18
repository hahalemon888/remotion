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
    NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=128"

# 设置工作目录
WORKDIR /app

# 创建 package.json
RUN echo '{"name":"remotion-api-server","version":"1.0.0","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.18.0","remotion":"^4.0.0","@remotion/renderer":"^4.0.0","react":"^18.0.0","react-dom":"^18.0.0"}}' > package.json

# 安装依赖
RUN npm install --legacy-peer-deps --production

# 创建带超时处理的 API 服务器
RUN echo 'const express = require("express");const { renderMedia } = require("@remotion/renderer");console.log("Starting Remotion API Server...");const app = express();app.use(express.json());console.log("Express app created");app.get("/health", (req, res) => {console.log("Health check requested");res.json({status: "ok", message: "Remotion API Server is running", timestamp: new Date().toISOString(), memory: process.memoryUsage()});});app.post("/api/tasks", async (req, res) => {console.log("Render task requested:", req.body);const timeoutId = setTimeout(() => {console.log("Request timeout - sending response");if (!res.headersSent) {res.status(408).json({error: "Request timeout", message: "Render task took too long to complete"});}}, 30000);try {const { fileName, outputLocation, composition, prone } = req.body;console.log("Task parameters:", { fileName, outputLocation, composition, prone });const outputPath = `/tmp/${fileName}`;console.log("Output path:", outputPath);const compositionConfig = {id: composition || "MyComposition", width: 640, height: 360, fps: 15, durationInFrames: 30};console.log("Starting render with composition:", compositionConfig);await renderMedia({composition: compositionConfig, serveUrl: "http://localhost:3000", codec: "h264", outputLocation: outputPath, inputProps: { prone: prone || 0 }, browserExecutable: "/usr/bin/chromium-browser", chromiumOptions: { args: ["--headless=new", "--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--disable-accelerated-2d-canvas", "--no-first-run", "--no-zygote", "--single-process", "--disable-gpu", "--disable-web-security", "--disable-features=VizDisplayCompositor", "--disable-background-timer-throttling", "--disable-backgrounding-occluded-windows", "--disable-renderer-backgrounding", "--disable-ipc-flooding-protection"] }});clearTimeout(timeoutId);if (!res.headersSent) {console.log("Render completed successfully");res.json({success: true, message: "Video rendered successfully", taskId: Date.now(), fileName, outputPath, composition: compositionConfig});}} catch (error) {clearTimeout(timeoutId);console.error("Render error:", error);if (!res.headersSent) {res.status(500).json({error: error.message, stack: error.stack});}}});console.log("Routes defined");const PORT = process.env.PORT || 3000;app.listen(PORT, () => {console.log(`Remotion API Server running on port ${PORT}`);console.log(`Available endpoints:`);console.log(`- GET /health`);console.log(`- POST /api/tasks`);console.log(`Memory usage: ${JSON.stringify(process.memoryUsage())}`);});console.log("Server setup complete");' > server.js

# 验证文件
RUN ls -la
RUN cat package.json
RUN cat server.js

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
