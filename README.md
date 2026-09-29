# vault 分支 —— new-project-init 的私密文件仓库

> ⚠️ **先读这三条**
> 1. **本分支在公开仓库里。** 它是 `warm-flame-core/new-project-init` 的一个分支，任何人 `git fetch origin vault` 都能拿到这里的密文。**这是「假隔离」，不是保密**——安全边界只有那把 32 位口令。
> 2. **密文用 AES-256-GCM + PBKDF2-SHA256（100k 迭代）** 加密，口令不在此仓库的任何地方（明文形式）。
> 3. **旧密文仍留在 `main` 的历史对象里**（本分支迁移**不改写历史**）。想真正拿走，必须改写 `main` 历史——本项目明确不做。

## 这里有什么

| 文件 | 内容 |
|------|------|
| `_private/ISSUES.md.enc` | 迭代输入源（项目使用中发现的问题记录） |
| `_private/ROADMAP.md.enc` | 仓库打磨路线 |
| `_private/DEVELOPER.md.enc` | 双机工作流手册（含口令同步说明） |
| `_private/上架-*.enc` | DSH 插件市场上架材料 |
| `_private/module-018-*.enc` | 历史分析文档与样板压缩包 |

**没有**：明文 `.md`、口令文件 `.secret`——它们被本分支的 `.gitignore` 挡在外面。

## 怎么用

### 第一次拿密文（新电脑）

```powershell
git clone https://github.com/warm-flame-core/new-project-init.git "<路径>\new-project-init"
cd "<路径>\new-project-init"

# 方式一（推荐）：把 vault 挂成一个并列工作区
git worktree add "<路径>\new-project-init-vault" vault

# 方式二：不用 worktree，只取密文目录
git fetch origin vault
git checkout vault -- _private
```

### 日常维护（改了私密文档之后）

```powershell
cd "<路径>\new-project-init"          # 主工作区：明文在这里（被 .gitignore 排除）
pwsh -File scripts/secret.ps1 -Action decrypt -Path _private   # 若还没有明文
# …改 _private/*.md…

# 加密并直接落到 vault 工作区（-OutDir，v11.4 起支持）
pwsh -File scripts/secret.ps1 -Action encrypt -Path _private -OutDir "<路径>\new-project-init-vault\_private"

cd "<路径>\new-project-init-vault"
git add -A
git commit -m "vault: <改了什么>"
git push origin vault
```

> `scripts/publish.ps1 -VaultPath "<路径>\new-project-init-vault"` 会一并校验「主工作区明文 ↔ vault 密文」是否同步、以及本分支里**有没有明文混入**。

## 为什么单独开分支

`main` 是给使用者看的（skill 正文 + 模板 + 平台适配），一次 `git clone` 就能直接用；私密文件（迭代输入源、路线图、双机手册）对使用者无用。

放在 `main` 上的问题是：**默认克隆、网页浏览、代码搜索都会带上它们**（哪怕是密文，每次 diff 也会刷新，噪音很大）。
放到 `vault` 分支后，`main` 的 `_private/` 被彻底忽略，默认克隆不再出现这些文件。

## 迁移记录

- **2026-09-30（v11.4）**：由 `main` 迁出。此前 10 个 `.enc` 直接跟在 `main` 上（`main` 的 `.gitignore` 用 `_private/*` + `!_private/*.enc` 豁免密文）；迁移后 `main` 整目录忽略 `_private/`，本分支承接全部密文。
- 迁移时的口径：**tag 跟 npm 版本号**；本分支不参与 npm 打包（`package.json` 的 `files` 白名单本来就不含 `_private`）。
