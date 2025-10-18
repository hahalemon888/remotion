# 使用 Node 18（Alpine 体积小）
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 拷贝依赖文件（仅拷贝必要文件以利用 Docker 缓存）
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装全部依赖（包含 workspace 提升的依赖）
RUN npm install --legacy-peer-deps

# 拷贝源代码
COPY . .

# 切换到 studio-server 目录
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["npm", "start"]
