# 使用 Node 18 作为基础镜像
FROM node:18

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 安装依赖
RUN npm install

# 构建 Remotion（可选）
RUN npm run build || echo "No build script"

# 暴露端口（ClawCloud 用这个访问）
EXPOSE 3000

# 启动命令
CMD ["npx", "remotion", "preview", "--port=3000"]
