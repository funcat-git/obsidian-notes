# SQL注入（SQL Injection）

## 学习时间

2026-06-07

---

## 漏洞原理

应用程序将用户可控数据直接拼接到SQL语句中执行，导致攻击者能够改变原有SQL语句逻辑，从而实现绕过认证、查询敏感数据甚至控制数据库等操作。

简单理解：

攻击者输入的内容本来应该是数据，但被数据库当成了SQL语句的一部分执行。

---

## 产生原因

开发人员将用户输入直接拼接到SQL语句中，没有进行严格过滤或参数化处理。

例如：

```php
$id = $_GET['id'];

$sql = "SELECT * FROM users WHERE id=$id";
```

如果用户控制了$id，就可能修改SQL语句逻辑。

---

## 常见场景

- 登录功能
- 搜索功能
- 文章详情页
- 用户信息查询
- 订单查询
- 后台管理系统
- APP接口(API)
- 老旧CMS系统

---

## 常见特征

### 前端表现

- 页面出现数据库报错
- 页面内容异常变化
- 页面长度明显变化
- 查询结果异常增多或减少
- 页面响应时间异常变长

### 源码特征

危险代码：

```php
$sql = "SELECT * FROM users WHERE id=".$id;
```

```php
$sql = "SELECT * FROM users WHERE username='$user'";
```

```php
$sql = "SELECT * FROM users WHERE id=$_GET[id]";
```

安全代码：

```php
$stmt = $pdo->prepare(
    "SELECT * FROM users WHERE id=?"
);

$stmt->execute([$id]);
```

---

## 验证方法

### 测试思路

1. 找到可控参数
2. 测试单引号
3. 测试真假条件
4. 比较响应差异
5. 测试时间延迟
6. 判断是否存在SQL注入

### 测试Payload

#### 报错测试

```text
'     有报错是字符型，无报错是数字型或被过滤
```

#### 布尔测试

```text
1 AND 1=1
```

```text
1 AND 1=2
```

#### 时间测试（MySQL）

```text
1 AND SLEEP(5)
```

### 响应特征

#### 报错注入

出现：

```text
SQL syntax
mysql error
mysqli error
database error
```

#### 布尔盲注

```text
1 AND 1=1
```

页面正常

```text
1 AND 1=2
```

页面异常或无数据

#### 时间盲注

```text
SLEEP(5)
```

页面明显延迟约5秒返回

---

## 利用方式

### 登录绕过

```text
' OR '1'='1
```

### 查询更多数据

通过构造新的查询条件获取额外数据。

### 获取数据库信息

例如：

- 数据库名
- 表名
- 字段名

### 敏感数据泄露

例如：

- 用户名
- 手机号
- 邮箱
- 密码哈希

---

## 修复方案

### 参数化查询（推荐）

```php
$stmt = $pdo->prepare(
    "SELECT * FROM users WHERE id=?"
);
```

### 使用ORM框架

避免手写SQL拼接。

### 输入过滤

对特殊字符进行严格校验。

### 最小权限原则

数据库账户仅授予必要权限。

---

## SRC视角关注点

### 常见参数

```text
id=
uid=
userid=
aid=
cid=
pid=
page=
keyword=
search=
order=
sort=
```

### 高危功能点

- 登录接口
- 搜索接口
- 用户信息查询
- 订单查询
- 后台管理系统
- APP API接口

### 排查思路

1. 抓包观察参数
2. 找到可控输入点
3. 使用Repeater测试
4. 测试单引号
5. 测试真假条件
6. 测试时间延迟
7. 判断是否存在SQL注入

---

## Payload备忘录

```text
'

"

1 AND 1=1

1 AND 1=2

1' AND '1'='1

1' AND '1'='2

1 AND SLEEP(5)

1' AND SLEEP(5)--+
```

---

## 关联知识

[[HTTP]]
[[BurpSuite]]
[[数据库基础]]
[[SQL语法]]

---

## 标签

#Web安全 #SQL注入 #SQLi #漏洞学习