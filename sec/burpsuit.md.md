# 工具名称

Burp Suite（BP）

## 学习时间

2026-06-07

## 工具简介

Burp Suite 是 Web 安全测试中最常用的抓包和改包工具，可以拦截浏览器与服务器之间的 HTTP/HTTPS 请求，查看请求和响应内容，并对数据进行修改后重新发送。

在后续学习 SQL 注入、越权、文件上传、路径遍历等漏洞时，Burp Suite 都是核心工具。

## 主要功能

### Proxy（代理抓包）

用于拦截浏览器与服务器之间的请求和响应。

常用操作：

- 开启代理
- 拦截请求
- 查看请求内容
- 修改请求内容

### Repeater（重发模块）

用于重复发送请求并观察响应。

常用操作：

- 修改参数
- 重发请求
- 对比响应
- 测试漏洞

### HTTP History（历史记录）

记录所有经过 Burp 的请求。

作用：

- 查找目标请求
- 回溯测试过程
- 分析网站功能

## 常见操作

### 抓包

开启 Intercept 后访问网站：

```http
GET /index.php?id=1 HTTP/1.1
Host: test.com
```

Burp 会拦截该请求。

### 放行请求

点击：

```text
Forward
```

请求继续发送到服务器。

### 丢弃请求

点击：

```text
Drop
```

请求不会发送到服务器。

### 修改请求

例如：

原参数：

```http
id=1
```

修改为：

```http
id=2
```

然后发送观察响应。

### 发送到 Repeater

右键请求：

```text
Send to Repeater
```

或者：

```text
Ctrl + R
```

进入 Repeater 后可反复修改并发送请求。

## 重点观察内容

### URL 参数

```http
?id=1
```

### POST 参数

```http
username=admin
```

### Cookie

```http
Cookie: session=abc123
```

### 请求头

```http
User-Agent
Referer
X-Forwarded-For
```

## 响应分析

重点关注：

### 状态码

```http
200 OK
```

请求成功。

```http
403 Forbidden
```

权限不足。

```http
404 Not Found
```

资源不存在。

```http
500 Internal Server Error
```

服务器异常。

### 返回内容

成功：

```json
{
  "username":"admin"
}
```

失败：

```json
{
  "error":"permission denied"
}
```

### 响应长度

如果修改参数后响应长度明显变化：

```text
5820
5821
5819
9200
```

则可能存在有价值的信息，需要进一步分析。

## 在漏洞测试中的作用

### SQL 注入

修改参数并观察报错或页面变化。

### 越权漏洞

修改用户 ID、订单 ID 等参数。

### 文件上传

修改文件名、后缀、Content-Type。

### 路径遍历

修改文件路径参数。

## 学习总结

目前掌握：

- 抓包
- 放包
- 丢包
- 改包
- Repeater 重发
- 查看响应

后续重点学习各类漏洞，通过漏洞场景掌握具体应该修改哪些参数以及如何判断漏洞是否存在。