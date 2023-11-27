# 使用官方的 Golang 镜像作为构建环境
FROM golang:1.17 AS builder

# 设置工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum 文件
COPY go.mod go.sum ./

# 下载依赖（你可以选择不下载依赖，直接在下面的构建步骤中下载）
RUN go mod download

# 复制源代码到容器中
COPY . .

# 构建应用程序
# 这里假设你的 main.go 文件在根目录，如果不是请相应更改路径
RUN CGO_ENABLED=0 GOOS=linux go build -v -o myapp .

# 使用 scratch 作为最小运行环境
FROM alpine:3.18.4

# 从构建环境复制构建好的应用程序
COPY --from=builder /app/myapp /myapp

# 运行应用程序
CMD ["/myapp"]
