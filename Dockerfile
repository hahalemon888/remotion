# 使用 Node 18 Alpine 版本 - 版本 3.0
FROM node:18-alpine

# 安装更新的 Chromium
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    xvfb \
    dbus

# 设置环境变量
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=128" \
    DISPLAY=:99

# 设置工作目录
WORKDIR /app

# 创建 package.json
RUN echo '{"name":"remotion-api-server-v3","version":"3.0.0","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.18.0","remotion":"^4.0.0","@remotion/renderer":"^4.0.0","react":"^18.0.0","react-dom":"^18.0.0"}}' > package.json

# 安装依赖
RUN npm install --legacy-peer-deps --production

# 创建使用 chrome-headless-shell 的 API 服务器
RUN echo 'const express = require("express");const { renderMedia } = require("@remotion/renderer");console.log("Starting Remotion API Server v3.0...");const app = express();app.use(express.json());console.log("Express app created");app.get("/health", (req, res) => {console.log("Health check requested");res.json({status: "ok", message: "Remotion API Server v3.0 is running", timestamp: new Date().toISOString(), memory: process.memoryUsage()});});app.post("/api/tasks", async (req, res) => {console.log("Render task requested:", req.body);const timeoutId = setTimeout(() => {console.log("Request timeout - sending response");if (!res.headersSent) {res.status(408).json({error: "Request timeout", message: "Render task took too long to complete"});}}, 60000);try {const { fileName, outputLocation, composition, prone } = req.body;console.log("Task parameters:", { fileName, outputLocation, composition, prone });const outputPath = `/tmp/${fileName}`;console.log("Output path:", outputPath);const compositionConfig = {id: composition || "MyComposition", width: 640, height: 360, fps: 15, durationInFrames: 30};console.log("Starting render with composition:", compositionConfig);console.log("Using chrome-headless-shell approach");await renderMedia({composition: compositionConfig, serveUrl: "http://localhost:3000", codec: "h264", outputLocation: outputPath, inputProps: { prone: prone || 0 }, browserExecutable: "/usr/bin/chromium-browser", chromiumOptions: { args: ["--headless=new", "--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--disable-accelerated-2d-canvas", "--no-first-run", "--no-zygote", "--single-process", "--disable-gpu", "--disable-web-security", "--disable-features=VizDisplayCompositor", "--disable-background-timer-throttling", "--disable-backgrounding-occluded-windows", "--disable-renderer-backgrounding", "--disable-ipc-flooding-protection", "--disable-extensions", "--disable-plugins", "--disable-images", "--disable-javascript", "--disable-default-apps", "--disable-sync", "--disable-translate", "--hide-scrollbars", "--mute-audio", "--no-default-browser-check", "--disable-logging", "--disable-gpu-logging", "--silent", "--disable-background-networking", "--disable-component-extensions-with-background-pages", "--disable-client-side-phishing-detection", "--disable-hang-monitor", "--disable-prompt-on-repost", "--disable-domain-reliability", "--disable-features=TranslateUI", "--disable-ipc-flooding-protection", "--disable-renderer-backgrounding", "--disable-backgrounding-occluded-windows", "--disable-background-timer-throttling", "--disable-field-trial-config", "--disable-back-forward-cache", "--disable-features=VizDisplayCompositor,VizHitTestSurfaceLayer", "--run-all-compositor-stages-before-draw", "--disable-new-content-rendering-timeout", "--disable-threaded-compositing", "--disable-threaded-scrolling", "--disable-checker-imaging", "--disable-new-tab-first-run", "--disable-component-update", "--disable-default-apps", "--disable-sync-preferences", "--disable-web-resources", "--disable-features=VizDisplayCompositor", "--disable-gpu-sandbox", "--disable-software-rasterizer", "--disable-gpu-memory-buffer-video-frames", "--disable-gpu-memory-buffer-compositor-resources", "--disable-gpu-memory-buffer-video-frames", "--disable-gpu-rasterization", "--disable-zero-copy", "--disable-gpu-debugging", "--disable-gpu-watchdog", "--disable-gpu-process-crash-limit"] }});clearTimeout(timeoutId);if (!res.headersSent) {console.log("Render completed successfully");res.json({success: true, message: "Video rendered successfully", taskId: Date.now(), fileName, outputPath, composition: compositionConfig});}} catch (error) {clearTimeout(timeoutId);console.error("Render error:", error);if (!res.headersSent) {res.status(500).json({error: error.message, stack: error.stack});}}});console.log("Routes defined");const PORT = process.env.PORT || 3000;app.listen(PORT, () => {console.log(`Remotion API Server v3.0 running on port ${PORT}`);console.log(`Available endpoints:`);console.log(`- GET /health`);console.log(`- POST /api/tasks`);console.log(`Memory usage: ${JSON.stringify(process.memoryUsage())}`);});console.log("Server setup complete");' > server.js

# 验证文件
RUN ls -la
RUN cat package.json
RUN cat server.js

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
