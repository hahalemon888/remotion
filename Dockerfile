# 使用 Node 18
FROM node:18-alpine

# 安装 bun（官方安装脚本）
RUN apk add --no-cache curl bash \
    && curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun/bin/bun /usr/local/bin/bun \
    && mv /root/.bun/bin/bunx /usr/local/bin/bunx

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

# 暴露端口（改成 Crawcloud 要的 3000）
EXPOSE 3000

# 启动服务（改端口）
CMD ["bunx", "remotion", "studio-server", "--port=3000"]
