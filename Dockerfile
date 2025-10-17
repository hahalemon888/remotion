# ---- 基础镜像 ----
FROM node:18-alpine

# 安装必要工具（确保 remotion 命令可运行）
RUN apk add --no-cache bash git ffmpeg

# ---- 设置工作目录 ----
WORKDIR /app

# ---- 拷贝依赖清单 ----
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# ---- 安装依赖 ----
RUN npm install

# ---- 拷贝完整代码 ----
COPY . .

# ---- 切换到 studio-server 子包 ----
WORKDIR /app/packages/studio-server

# ---- 构建（如果有） ----
RUN npm run build || echo "no build step, skipping"

# ---- 暴露端口 ----
EXPOSE 3000

# ---- 启动 Remotion Studio ----
CMD ["npm", "start"]
