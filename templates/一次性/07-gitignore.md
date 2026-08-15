# .gitignore 章节模板（模板 07）
> 🗂️ **产出模式**：一次性文档（skill 特化即正式文件，后续修改=更新式：改内容+变更记录+署名）；模板目录：templates/一次性/（v10.0 目录规整）
> 📍 **变更记录方向**：新行追加底部（有人看；见 SKILL.md 文档维护规则第 9 条）

> **必产**（一次性文档）。按「git 3 层」问询答案生成；示例=常见分组结构，agents 按实际技术栈增删。
> 生成后**第 3 层兜底核对**：clone 能否编译？该上没上（锁文件）？不该上的上了（密钥）？

---

## 第一部分：章节结构一览

```
.gitignore
├── # 编译产物/依赖     ← target/ node_modules/ dist/ *.class *.jar
├── # IDE/系统          ← .idea/ .vscode/ .DS_Store Thumbs.db
├── # 环境/密钥          ← .env .env.local *.pem（绝不上传）
├── # 日志/临时          ← *.log .tmp-*/ .tmp-xxx/
├── # 本地保留项（问询决定） ← memory/ CLAUDE.md tools/ 内部手册（GIT-1/T4）
├── # 部署产物           ← deploy/backend/ deploy/frontend/（如有）
└── # 注意不忽略         ← 锁文件 package-lock.json / pom.xml / docker-compose.yml
```

## 第二部分：详细规格

- **第 1 层（不问，直接写）**：编译产物、依赖目录、密钥环境（.env/私钥）、临时文件 → 不上。
- **第 2 层（按问询答案）**：
  - GIT-1 memory/、CLAUDE.md、内部手册 → 仅本地（`.gitignore` 加行）或入库
  - GIT-2 IDE 配置 → 不上（或共享配置上）
  - GIT-3 种子/测试数据 → 原样 / 脱敏 / 不上
  - GIT-4 大二进制 → 不上 / Git LFS
- **T4 工具**：含凭据的工具（如 db-query 带连接串）→ `tools/` 整体排除，**绝不上传**。
- **第 3 层兜底核对（必做）**：
  - clone 后能否编译（锁文件/父 POM 是否被误忽略）
  - 该上的上了没（锁文件 package-lock.json / pom.xml）
  - 不该上的上了没（密钥/内网配置/凭据）
- **注释**：每组加 `# 中文注释` 说明为何忽略（避免后人误删规则）。

### 示例（结构示范）
```gitignore
# Compiled class file
*.class

# Maven
target/

# Node
node_modules/
dist/

# IDE
.idea/
.vscode/

# OS
.DS_Store
Thumbs.db

# Env（密钥不上传）
.env
.env.local

# 临时文件（agent 开发用）
.tmp-*/

# 记忆库（仅本地留存，不入库；agent 排查/防幻觉查证用）
memory/

# 开发工具（全部本地保留；db-query 含共享库连接凭据）
tools/

# 本地工作规范（仅本地保留，不推送）
CLAUDE.md
```


## 变更记录

| 日期时间 | 变更内容 | 署名 |
|----------|----------|------|
| 2026-08-15 | v10.0：模板目录按产出模式规整（一次性/多次-单文件/多次-含文件夹）；头部补产出模式标注 | Reasonix（skill 迭代） |
| 2026-08-15 | v10.5：变更记录方向标注统一为「新行追加底部（有人看）」（SKILL.md 第 9 条 v10.5）+ 存量行序规整 | Reasonix（skill 迭代） |
