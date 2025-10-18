# 使用 Node 18（Remotion 推荐版本）
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制依赖文件
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装子包依赖（确保 remotion 安装在 studio-server 内部）
RUN cd packages/studio-server && npm install --legacy-peer-deps

# 拷贝源代码
COPY . .

# 切换到 studio-server 目录
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
