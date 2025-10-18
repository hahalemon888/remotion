# 使用 Node 18 Alpine 版本
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 创建 package.json
RUN echo '{"name":"remotion-api-server","version":"1.0.0","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.18.0"}}' > package.json

# 创建稳定的测试服务器
RUN echo 'const express = require("express");console.log("Starting Remotion API Server...");const app = express();app.use(express.json());console.log("Express app created");app.get("/health", (req, res) => {console.log("Health check requested");res.json({status: "ok", message: "Remotion API Server is running", timestamp: new Date().toISOString(), memory: process.memoryUsage()});});app.post("/api/tasks", (req, res) => {console.log("Render task requested:", req.body);try {const { fileName, outputLocation, composition, prone } = req.body;console.log("Task parameters:", { fileName, outputLocation, composition, prone });const outputPath = `${outputLocation}/${fileName}`;console.log("Output path:", outputPath);res.json({success: true, message: "Task received successfully (test mode)", taskId: Date.now(), fileName, outputPath, composition, prone, note: "This is a test response - no actual rendering performed"});} catch (error) {console.error("Task error:", error);res.status(500).json({error: error.message});}});console.log("Routes defined");const PORT = process.env.PORT || 3000;app.listen(PORT, () => {console.log(`Remotion API Server running on port ${PORT}`);console.log(`Available endpoints:`);console.log(`- GET /health`);console.log(`- POST /api/tasks`);console.log(`Memory usage: ${JSON.stringify(process.memoryUsage())}`);});console.log("Server setup complete");' > server.js

# 验证文件
RUN ls -la
RUN cat package.json
RUN cat server.js

# 安装依赖
RUN npm install --production

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
