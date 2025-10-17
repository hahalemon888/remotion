# 使用 Node 18 官方镜像（Remotion 兼容）
FROM node:18-bullseye

# 设置工作目录
WORKDIR /app

# 复制 package 文件以便缓存依赖层
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目所有文件
COPY . .

# 暴露端口 3000（ClawCloud 用）
EXPOSE 3000

# 启动 Remotion Render Server
CMD ["npx", "remotion", "render-server", "--port=3000"]
