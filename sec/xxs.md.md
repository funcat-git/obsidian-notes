# 漏洞名称

XSS（Cross Site Scripting，跨站脚本攻击）

---

## 原理

应用程序将用户可控输入直接输出到页面中，且未进行安全过滤或编码处理。

当浏览器解析页面时，会将恶意输入当作 JavaScript 代码执行，从而导致攻击者控制受害者浏览器执行指定脚本。

本质：

```text
用户输入
↓
进入页面
↓
浏览器解析执行
```

---

## 常见场景

### 反射型 XSS

用户输入后立即回显。

常见位置：

- 搜索框
- URL 参数
- 错误提示页面
- 跳转页面

流程：

```text
输入
↓
服务器处理
↓
立即回显
↓
执行
```

### 存储型 XSS

恶意内容被保存到数据库。

常见位置：

- 评论区
- 留言板
- 用户昵称
- 用户简介
- 发帖内容

流程：

```text
输入
↓
数据库存储
↓
用户访问
↓
执行
```

### DOM XSS

前端 JavaScript 不安全处理用户输入。

常见位置：

- location.hash
- location.search
- document.URL
- postMessage

流程：

```text
输入
↓
前端JS读取
↓
写入DOM
↓
执行
```

---

## 常见特征

- 输入内容出现在页面中
- URL 参数存在回显
- 评论区可输入 HTML
- 用户资料可展示
- 页面使用富文本编辑器
- 前端存在危险 DOM 操作

危险函数：

```javascript
document.write()
innerHTML
outerHTML
eval()
setTimeout()
setInterval()
```

---

## 验证方法

### Payload

基础验证：

```html
<script>alert(1)</script>
```

常见验证：

```html
<img src=x onerror=alert(1)>
```

SVG：

```html
<svg onload=alert(1)>
```

### 响应特征

成功：

- 出现 alert 弹窗
- 标签被浏览器解析
- 页面结构发生变化
- JavaScript 被执行

失败：

```html
&lt;script&gt;alert(1)&lt;/script&gt;
```

说明进行了 HTML 编码。

---

## 影响

### 用户影响

- 页面内容被篡改
- 浏览器执行恶意脚本
- 敏感信息泄露

### 业务影响

- 用户身份被冒用
- 管理员账户受影响
- 网站信誉受损
- 可配合其他漏洞进一步攻击

---

## 修复方案

### 输出编码

将特殊字符编码：

```html
<
>
"
'
&
```

转换为：

```html
&lt;
&gt;
&quot;
&#39;
&amp;
```

### 使用安全 API

避免：

```javascript
innerHTML
document.write()
```

推荐：

```javascript
textContent
innerText
```

### 输入过滤

过滤危险标签：

```html
<script>
<iframe>
<svg>
```

### CSP

配置：

```http
Content-Security-Policy: script-src 'self'
```

---

## SRC视角

### 常见参数

GET：

```http
?id=
?search=
?q=
?keyword=
?name=
```

POST：

```http
username=
nickname=
content=
comment=
message=
description=
title=
```

### 常见功能点

高频功能：

- 搜索
- 评论
- 发帖
- 留言板
- 用户资料修改
- 用户昵称修改
- 工单系统

中频功能：

- 公告系统
- 活动报名
- 联系我们
- 用户反馈

### 排查思路

#### 第一步：找输入点

关注：

- GET 参数
- POST 参数
- 富文本编辑器
- 用户资料

#### 第二步：找回显点

观察：

```text
输入内容最终显示在哪里
```

例如：

```text
搜索词 → 搜索结果页
昵称 → 用户主页
评论 → 文章详情页
简介 → 个人主页
```

#### 第三步：测试 Payload

```html
<script>alert(1)</script>
```

```html
<img src=x onerror=alert(1)>
```

#### 第四步：判断类型

```text
反射型：
输入 → 回显 → 执行

存储型：
输入 → 数据库 → 执行

DOM型：
输入 → JS处理 → 执行
```

---

## 关联知识

前置：

- HTTP
- HTML
- JavaScript
- 浏览器渲染机制
- Cookie

后续：

- CSP
- DOM 安全
- CSRF
- JWT
- 同源策略
- 浏览器安全机制

---

## 标签

#Web安全

#XSS

#反射型XSS

#存储型XSS

#DOMXSS

#漏洞挖掘

#BurpSuite

#SRC

#前端安全

#JavaScript