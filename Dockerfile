# 使用 Node 18（Debian 版更稳定，Alpine 有时 glibc 缺失导致 ffmpeg/chromium 崩溃）
FROM node:18-bullseye-slim

# 设置工作目录
WORKDIR /app

# 拷贝依赖文件
COPY package*.json ./
COPY packages/studio-server/package*.json packages/studio-server/

# 安装所有依赖（包含 workspace），确保 remotion CLI 及相关依赖齐全
RUN npm ci --legacy-peer-deps

# 拷贝全部源代码
COPY . .

# 构建项目（如果有 build 步骤）
RUN npm run build --workspace packages/studio-server || echo "no build step"

# 暴露端口
EXPOSE 3000

# 切换到 studio-server 目录
WORKDIR /app/packages/studio-server

# 启动服务（直接执行 remotion CLI，不依赖 npx）
CMD ["npm", "start"]
