# HTTP 基础

## 什么是 HTTP

HTTP（HyperText Transfer Protocol，超文本传输协议）是浏览器与服务器之间通信的协议。

简单理解：

浏览器 ←→ HTTP ←→ 服务器

访问网页时，本质上就是浏览器发送 HTTP 请求，服务器返回 HTTP 响应。

---

# HTTP 请求结构

一个完整请求：

```http
POST /login HTTP/1.1
Host: test.com
Cookie: uid=1001

username=admin&password=123456
```

HTTP 请求由四部分组成：

## 1. 请求行

```http
POST /login HTTP/1.1
```

包含：

- 请求方法
- 请求路径
- HTTP版本

常见方法：

| 方法 | 作用 |
|--------|--------|
| GET | 获取数据 |
| POST | 提交数据 |
| PUT | 修改数据 |
| DELETE | 删除数据 |

重点掌握：

```text
GET
POST
```

---

## 2. 请求头 Header

例如：

```http
Host: test.com
Cookie: uid=1001
User-Agent: Chrome
```

常见重要字段：

### Host

```http
Host: test.com
```

表示请求发送给哪个网站。

---

### Cookie

```http
Cookie: uid=1001
```

保存用户身份信息。

后续越权测试重点关注。

---

### User-Agent

```http
User-Agent: Chrome
```

浏览器信息。

---

### Referer

```http
Referer: https://test.com
```

请求来源页面。

---

## 3. 空行

请求头与请求体之间必须有空行。

---

## 4. 请求体 Body

POST 参数一般放在这里：

```http
username=admin&password=123456
```

也可能是：

```json
{
    "username":"admin",
    "password":"123456"
}
```

---

# HTTP 响应结构

示例：

```http
HTTP/1.1 200 OK
Content-Type: text/html

<html>
...
</html>
```

响应包含：

## 状态行

```http
HTTP/1.1 200 OK
```

包含：

- HTTP版本
- 状态码
- 状态描述

---

## 响应头

例如：

```http
Content-Type: text/html
Set-Cookie: uid=1001
```

---

## 响应体

服务器返回的数据内容。

例如：

```html
<html>Hello</html>
```

或者：

```json
{
    "code":0,
    "msg":"success"
}
```

---

# 常见状态码

| 状态码 | 含义 |
|---------|---------|
| 200 | 请求成功 |
| 301 | 永久重定向 |
| 302 | 临时重定向 |
| 403 | 禁止访问 |
| 404 | 页面不存在 |
| 500 | 服务器错误 |

重点：

```text
200
302
403
500
```

---

# GET 与 POST

## GET

参数位于 URL：

```http
GET /user?id=1 HTTP/1.1
```

特点：

- 参数直接显示在 URL
- 常用于查询数据

---

## POST

参数位于 Body：

```http
POST /login HTTP/1.1

username=admin&password=123456
```

特点：

- 参数在请求体中
- 常用于提交数据

---

注意：

```text
GET ≠ 不安全
POST ≠ 安全
```

两者都可能存在：

- SQL注入
- XSS
- 越权

---

# SRC 视角重点关注位置

抓到一个包优先看：

## 1. URL 参数

例如：

```http
GET /user?id=1
```

关注：

```text
id
uid
userId
orderId
```

可能出现：

- SQL注入
- 越权

---

## 2. POST 参数

例如：

```http
username=admin
password=123
```

可能出现：

- SQL注入
- XSS
- 业务逻辑漏洞

---

## 3. Cookie

例如：

```http
Cookie: uid=1001
```

关注：

```text
uid
userid
role
token
jwt
```

可能出现：

- 越权
- 身份认证缺陷

---

## 4. Header

重点：

```http
Authorization:
X-Forwarded-For:
Referer:
Origin:
```

可能出现：

- 权限绕过
- IP绕过

---

## 5. 响应包

重点观察：

- 状态码
- 响应长度
- 错误信息
- 用户ID
- 权限字段

---

# Burp 抓包分析流程

拿到请求后：

第一步：

找参数

```text
GET
POST
JSON
```

第二步：

找身份

```text
Cookie
Token
JWT
```

第三步：

找资源

```text
id
uid
orderId
fileId
```

第四步：

观察响应

```text
状态码
响应内容
长度变化
```
