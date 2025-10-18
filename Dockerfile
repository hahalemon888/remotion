# 使用 Node 18 Alpine 版本
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 创建 package.json
RUN echo '{"name":"remotion-test","version":"1.0.0","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.18.0"}}' > package.json

# 创建 server.js
RUN echo 'const express = require("express");console.log("Starting server...");const app = express();app.use(express.json());console.log("Express app created");app.get("/health", (req, res) => {console.log("Health check requested");res.json({status: "ok", message: "Server is running", timestamp: new Date().toISOString()});});console.log("Routes defined");const PORT = process.env.PORT || 3000;app.listen(PORT, () => {console.log(`Server running on port ${PORT}`);console.log(`Memory usage: ${JSON.stringify(process.memoryUsage())}`);});console.log("Server setup complete");' > server.js

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
