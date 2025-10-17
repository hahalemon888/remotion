# ---------- 构建阶段 ----------
FROM node:18 AS builder

WORKDIR /app

# 复制依赖文件并安装
COPY package*.json ./
RUN npm install

# 复制所有项目文件
COPY . .

# 构建项目
RUN npm run build

# ---------- 运行阶段 ----------
FROM node:18-slim

WORKDIR /app

# 仅复制运行所需文件
COPY --from=builder /app /app

# 安装生产依赖（可选）
RUN npm install --omit=dev

# 暴露 Remotion 端口
EXPOSE 3000

# 启动 Remotion Render Server
CMD ["npm", "start"]
