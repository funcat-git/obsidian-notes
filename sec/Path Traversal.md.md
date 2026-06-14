# 路径遍历（Path Traversal）

## 原理

路径遍历漏洞的本质是：

> 用户可控文件路径 + 程序未限制访问范围 + 操作系统解析 `../` 目录跳转 = 访问到非预期文件

正常情况下，程序只允许访问某个固定目录（如 uploads）：

```
/uploads/a.txt
```

但如果用户输入：

```
../../etc/passwd
```

并被拼接进路径：

```
/uploads/../../etc/passwd
```

系统路径解析后变成：

```
/etc/passwd
```

从而访问到敏感文件。

---

## 常见场景

路径遍历常见于文件读取相关功能：

- 文件下载（download）
- 图片/头像访问（image/avatar）
- 文件预览（pdf/doc）
- 日志查看（log）
- 附件下载（attachment）
- 模板加载（template）
- 配置读取（config）
- 报表导出

---

## 常见特征

### 1. 文件相关参数

```
file
path
filename
filepath
img
image
dir
folder
download
template
log
```

---

### 2. 行为像读取文件

- 返回文件内容
- 返回图片/文件流
- 返回 file not found
- 返回路径错误

---

### 3. 错误泄露路径

```
No such file:
/var/www/html/uploads/test.txt
```

---

### 4. 参数修改响应变化明显

```
file=a.txt → 正常
file=../a.txt → 报错
file=../../etc/passwd → 响应变化
```

---

## 验证方法

核心思路：

> 判断是否能控制文件路径并突破目录限制

---

### Payload

基础测试：

```
../
../../
../../../
```

访问系统文件：

```
../../../../../../etc/passwd
```

Windows：

```
..\..\..\..\Windows\win.ini
```

---

### 响应特征

- 返回文件内容（成功）
- 文件不存在
- 权限拒绝
- 路径错误
- 返回系统路径（高危信息泄露）

---

## 影响

路径遍历可能导致：

- 读取系统敏感文件
- 泄露配置文件（数据库密码）
- 泄露源码文件
- 泄露日志
- 配合其他漏洞导致RCE
- 用户隐私泄露

---

## 修复方案

### 1. 白名单机制（推荐）

只允许合法文件：

```
report.pdf
1.png
```

---

### 2. 路径规范化 + 目录限制

核心逻辑：

```python
full_path = os.path.realpath(base_dir + user_input)

if not full_path.startswith(base_dir):
    reject()
```

---

### 3. 使用文件ID替代路径

```
/download?id=12345
```

后端映射真实文件。

---

### 4. 禁止拼接用户输入

错误：

```text
readFile("/uploads/" + file)
```

---

### 5. 关闭错误回显

避免泄露真实路径。

---

## SRC视角

### 常见参数

```
file
path
filename
filepath
img
image
url
dir
folder
download
template
log
```

---

### 常见功能点

- 文件下载
- 图片访问
- 头像接口
- 文件预览
- 日志查看
- 报表导出
- 模板渲染

---

### 排查思路

1. 找文件相关接口
2. 修改参数观察响应
3. 测试不存在文件
4. 尝试 ../ 跳转
5. 判断是否突破目录
6. 尝试访问系统文件
7. 判断漏洞危害

---

## 关联知识

- 文件包含（LFI）
- URL编码绕过（%2e%2e%2f）
- 路径规范化（realpath）
- Linux文件系统结构
- Web文件读取机制

---

## 标签

`路径遍历` `文件读取` `WEB安全` `SRC漏洞` `OWASP` `中高危漏洞`