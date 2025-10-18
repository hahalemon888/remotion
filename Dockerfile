# 使用 Node 18（推荐 Debian 版而非 Alpine，Remotion 用 Chromium）
FROM node:18-bullseye-slim

# 设置工作目录
WORKDIR /app

# 拷贝 studio-server 的依赖文件
COPY packages/studio-server/package*.json ./packages/studio-server/

# 进入 workspace 并安装依赖
WORKDIR /app/packages/studio-server
RUN npm install --legacy-peer-deps

# 拷贝全部代码
WORKDIR /app
COPY . .

# 切回 studio-server
WORKDIR /app/packages/studio-server

# 构建（如果没有 build 脚本会跳过）
RUN npm run build || echo "no build step"

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["npm", "start"]
