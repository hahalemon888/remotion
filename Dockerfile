# 使用 Node 18
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 拷贝依赖清单
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装依赖
RUN npm install

# 拷贝全部源代码
COPY . .

# 切换工作目录到 studio-server
WORKDIR /app/packages/studio-server

# 构建项目（如果需要）
RUN npm run build || echo "no build step, skipping"

# 启动服务
CMD ["npm", "start"]
