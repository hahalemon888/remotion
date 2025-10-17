# Use Bun as base image (includes bunx)
FROM oven/bun:latest

WORKDIR /app

# Copy everything from current repo
COPY . .

# Install dependencies using Bun
RUN bun install

# Expose the Remotion Render Server port
EXPOSE 3000

# Start Remotion Render Server
CMD ["bunx", "remotion", "render-server"]
