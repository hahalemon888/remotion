# 使用 Node.js 18 版本（Remotion 官方推荐）
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制所有 package.json（包括 workspace 子包）
COPY package.json package-lock.json* ./
COPY packages/studio-server/package.json ./packages/studio-server/

# 安装依赖（包括 remotion）
RUN npm install remotion @remotion/renderer --legacy-peer-deps

# 复制整个项目（包括源代码）
COPY . .

# 设置工作目录到 studio-server
WORKDIR /app/packages/studio-server

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "../../node_modules/remotion/cli/index.js", "studio", "--port=3000"]
