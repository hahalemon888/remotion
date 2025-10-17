# 使用 Node 18
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 拷贝依赖文件
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装依赖
RUN npm install --workspace packages/studio-server

# 拷贝源代码
COPY . .

# 切换工作目录到 studio-server
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动服务
CMD ["npm", "start"]
