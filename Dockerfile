# 使用 Node 18 作为基础镜像
FROM node:18

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 lock 文件
COPY package*.json ./
# 如果你使用的是 pnpm/yarn，可以改成相应命令
# COPY pnpm-lock.yaml ./

# 先安装依赖（忽略 workspace 问题）
RUN npm install --legacy-peer-deps || true

# 复制全部代码
COPY . .

# 构建 Remotion（可选）
RUN npm run build || echo "No build script"

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npx", "remotion", "preview", "--port=3000"]
