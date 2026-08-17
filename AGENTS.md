# AGENTS.md —— new-project-init 开发者入口

> 本文件供**开发者（人类 + AI agent）**快速上手本仓库：布局、开发工作流、发布、迭代。
> 使用者（只想用 skill 的人）请看 `README.md`。

## 这是什么

`new-project-init` 是一个「项目文档体系初始化」skill：**以存量完善为核心**（优化已有项目文档/规范、固化 AI 分角色协作工作流），同时覆盖中途加入补建体系与新项目开工前。提问驱动落实，26 个模板 + 四场景验证走查。

**架构理念**：skill 本体（SKILL.md + templates/ + testing/）平台无关；多平台适配按平台名分目录放在 `platforms/<平台>/`，像项目管理一样规整。

## 目录结构

```
new-project-init/
├── SKILL.md                  # ★ skill 本体（平台无关主文件，位置固定——各平台发现机制依赖）
├── AGENTS.md                 # 本文件（开发者入口）
├── README.md                 # 对外介绍（含各平台安装说明）
├── LICENSE / CONTRIBUTING.md / package.json / .gitignore
├── templates/                # 26 个模板，按产出模式分 3 目录（平台无关核心资产）
├── testing/                  # 四个场景验证走查（全新/中途/存量/模板）
├── platforms/                # ★ 多平台适配，按平台分目录
│   ├── reasonix/adaptation.md        # Reasonix 能力映射全文
│   ├── dsh/adaptation.md             # DSH 能力映射全文
│   └── dsh/cordis.patch.yml          # DSH bundle patch（npm 不再维护，GitHub 安装仍用）
├── docs/
│   └── CREATION-LOG.md       # 完整版本演进历史
├── lib/
│   └── index.js              # DSH 插件入口（skill provider）
├── scripts/
│   ├── secret.ps1            # 私密文件 AES 加解密（零依赖）
│   └── publish.ps1           # 发布前检查（GitHub 直接 push 即发布）
└── _private/                 # 私密文件（明文不入库，*.enc 密文入库）
    ├── ISSUES.md             # 迭代输入源（项目使用中发现的问题）
    ├── ROADMAP.md            # 仓库打磨路线
    ├── DEVELOPER.md          # 双机工作流手册（含口令同步说明）
    └── *.enc                 # 以上文件的加密产物（提交入库）
```

## 开发工作流（任意一台电脑）

```powershell
cd D:\software\Reasonix\Reasonix_Skill_Ds\new-project-init

# 1) 拉取最新
git pull origin main

# 2) 解密私密文件（口令：-Passphrase / 环境变量 NPI_SECRET / _private/.secret）
pwsh -File scripts/secret.ps1 -Action decrypt -Path _private

# 3) 改文件（SKILL.md / templates / platforms / docs 等）
#    —— 遵循 SKILL.md「skill 迭代大前提」：至少升小版本 + docs/CREATION-LOG.md 顶部追加记录

# 4) 重新加密私密文件
pwsh -File scripts/secret.ps1 -Action encrypt -Path _private

# 5) 提交 + 推送（GitHub 即发布）
git add -A
git commit -m "..."
git push origin main
```

> ⚠️ **私密纪律（硬规则）**：`_private/*.md` 明文与 `_private/.secret` 口令被 `.gitignore` 排除、绝不入库；只有 `*.enc` 密文入库。发布前跑 `scripts/publish.ps1` 做泄露检查。**口令只在两台电脑间同步，不要写进任何入库文件。**

## 发布

- **GitHub（唯一发布渠道）**：push 即发布。安装方式在 README 中说明（Reasonix：`~/.reasonix/skills/` junction 或 `reasonix.toml` `[skills] paths`；DSH：`dsh plugin --profile web add github:warm-flame-core/new-project-init` 或 customSkillDirs 指向；Claude Code：技能目录）。
- ~~**npm**：不再维护~~（历史 v10.8-v10.9 曾发布 npm 1.0.1；后续版本仅 GitHub 安装，README 已用删除线标注）。
- 发布前检查：`pwsh -File scripts/publish.ps1`（校验 `_private` 无明文泄露、密文与明文同步、版本号一致）。

## 迭代（优化本 skill）

1. **输入源**：`_private/ISSUES.md`（解密后）——记录项目使用中发现的待迭代问题（ISSUE-XXX，追加式）。
2. **方法论**：加载 `superpowers-writing-skills`（`D:\software\Reasonix\Reasonix_Skill_Ds\superpowers-reasonix`），按 RED-GREEN-REFACTOR（TDD for process docs）：压力场景 → 无 skill 基线失败 → 最小修复 → 复测堵漏洞。
3. **收尾**：SKILL.md 版本表 + `docs/CREATION-LOG.md` 顶部记录；`testing/` 走查受影响场景。
4. **跨电脑/跨工作区**：改前先 `git pull`；改后加密 + push；另一台电脑 pull + 解密。

## 平台适配开发（新增平台）

- 平台无关内容进 `SKILL.md` / `templates/` / `testing/`（唯一出处）。
- 平台特定映射写 `platforms/<平台>/adaptation.md`（如 `platforms/reasonix/`、`platforms/dsh/`），并在 SKILL.md「平台适配」节 + README 各平台节登记。
- 该平台的适配最好在该平台的电脑/工作区实测开发（如 Reasonix 适配在 Reasonix 环境、DSH 适配在 DSH 环境）。
