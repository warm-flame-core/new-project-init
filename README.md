# new-project-init（项目文档体系初始化 · 提问驱动）

> 🦸 **「项目文档乱成一团？换个 AI 就不知道项目在干嘛？」——这个 skill 帮你把项目的文档、规矩、AI 协作流程一次性立起来。**

**用大白话说**：你项目里有一堆文档要**建、要整理、要立规矩**，还要让 AI 以后**按规矩帮你干活**——用这个 skill，AI 会先问清楚你的项目情况（技术栈、团队、习惯……问到你烦为止，答不上来它会给默认），再按你的答案生成一套规范文件（CLAUDE.md、AI 记忆库、docs 文档、模块流程等），以后**每个 AI 进场都知道先读什么、怎么干活、怎么留记录**。**重点场景是「存量完善」：项目跑了一半、文档已经有点乱的**——不乱动你的代码，只把文档和流程理顺（只记录不重构）。

A question-driven skill focused on **optimizing existing project docs & AI-collaboration workflows** (存量完善) — and scaffolding new projects, or joining one mid-way. **v11.3：五件套颗粒度标尺机制 + 流程 gate 一批 + ZCode 适配**; **adapted for DeepSeek Harness (DSH), Reasonix and ZCode**, also works with Claude Code and other skill-capable agents. Design methodology inspired by [superpowers](https://github.com/obra/superpowers) & [superpowers-zh](https://github.com/jnMetaCode/superpowers-zh).

[![作者 warm-flame-core](https://img.shields.io/badge/👤_作者-warm--flame--core-blue)](https://github.com/warm-flame-core)
[![DSH 适配](https://img.shields.io/badge/DeepSeek_Harness-深度适配-4F46E5)](https://github.com/deepseek-ai/deepseek-harness)
[![Reasonix 适配](https://img.shields.io/badge/Reasonix-深度适配-1E8E3E)](https://reasonix.io/skills/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

---

## 📊 项目规模

| 📦 模板 | 🎯 适用场景 | 📄 产出物 | 🧪 验证走查 |
|:---:|:---:|:---:|:---:|
| **31 个**（v11.0：26 基础 + 27~31 可装配，按产出模式分 3 目录） | **存量完善 / 中途加入 / 全新项目**（以存量完善为核心） | **CLAUDE.md/AGENTS.md（平台入口映射定名）+ memory 三件套 + docs + specs 五件套** | **4 个场景走查**（skill 自身迭代验证） |

---

## 🆚 效果对比（为什么值得用）

**没有这个 skill：**
```
你：给项目建一套文档和 AI 协作规范
AI：好的，我来写 CLAUDE.md……（直接开始，不知道你项目是干啥的）
你：等等，这是 Java 项目你写 Python 规范干嘛？技术栈也没问……
→ 文档和实际脱节，AI 协作没有规矩，跑一段时间文档就开始乱
```

**用了这个 skill：**
```
你：用 new-project-init 初始化项目
AI：开始前先问几个问题——
  1. 产品形态？（Web/小程序/嵌入式/后端…）
  2. 技术栈？（Java/C++/前端…，附权衡）
  3. 团队协作方式？（单人/多 agent，决定精简 or 完整模式）
  → 每份规范文件产出前先确认，产出即按你的项目特化
```

**核心差异**：不是「套模板」，是「**提问驱动落实**」——每个规范文件先问清你的规划，按答案特化生成；答不上来给推荐默认。**先设计后动手**，每份文件确认后才做下一份。

---

## 🧩 同类工具与推荐（superpowers 生态）

本 skill 不是凭空产生的——**其设计方法论深受 superpowers 启发**。如果你还没接触过，或想对照使用，推荐先看以下几个**真实存在**的项目：

| 项目 | 定位 | 说明 |
|------|------|------|
| [obra/superpowers](https://github.com/obra/superpowers)（英文原版 · 原作者 obra） | **Claude Code 生态 · 原生态** | superpowers 最早发布形态：一套「纪律型 process skill」——先写测试、根据证据调试、先写计划再编码、完成前先验证。**注意：它面向 Claude Code，对「存量完善已有项目文档」适配不佳**——这正是本 skill（以存量完善为核心、跨平台）的差异化定位 |
| [jnMetaCode/superpowers-zh](https://github.com/jnMetaCode/superpowers-zh)（中文增强版） | 跨平台 · 中文 | superpowers 中文版，跨 AI 工具可用；触发条件式描述、完成前验证、集成选项交给用户等思想的来源之一 |
| superpowers-reasonix | **Reasonix / DeepSeek 移植版** | obra/superpowers 针对 Reasonix（DeepSeek-Reasonix CLI）工具集与 skill 格式的移植，非 1:1 直译，并按 Reasonix 的 skill 格式重写（本机 skill 目录 `D:\software\Reasonix\Reasonix_Skill_Ds\superpowers-reasonix`） |

> ⚠️ **关于"其他平台适配版"**：superpowers 生态里还有面向其他 AI 工具/语言的移植，但**我们本次未能在线核实到可确认的公开仓库清单**（本环境网络受限，未编造任何未经确认的仓库名）。若你所在平台不在上表，可自行检索 `superpowers-<平台>`（很多是以"obra/superpowers 的 XX 平台移植"形式开源），或先用上表三个已确认项目。

---

## 🖥️ DeepSeek Harness（DSH）适配

本 skill **v10.7 起深度适配 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)**（DSH）——**规则/模板/产出物完全跨平台**，Claude Code 等其他工具照常使用，本适配只是「在 DSH 里怎么落地」的指引。

### 安装（DSH）

**方式一：DSH 插件安装（npm / GitHub）—— 本仓库同时是一个 DSH 插件包（`dsh.bundle`），安装即注册技能**

```sh
# npm 安装（推荐，免生成构建批准；npm 已恢复发布）
dsh plugin --profile web add new-project-init

# 或从 GitHub 安装（备选）
dsh plugin --profile web add github:warm-flame-core/new-project-init
```

> **`--profile <名字>` 决定装给谁用**：插件装进的是该 profile，只有用该 profile 启动的 DSH 才会加载它（桌面版与 `dsh web` 可能是两套 profile，互不通用）。装完重启该 profile，技能即出现在会话技能目录。只想让技能在**所有 profile / 所有会话**可见，用下面的**方式二**更省事。也可以从本地文件夹安装（`dsh plugin --profile web add <仓库路径>`）。

**方式二：本地文件安装（无需插件系统，所有 profile 通用）**

| 方式 | 做法 | 说明 |
|------|------|------|
| **用户级（推荐）** | 把本仓库放进 `$DSH_HOME/skills/`（Windows 默认 `%USERPROFILE%\.dsh\skills\`；可用 **junction 指向本仓库**，保持单一来源） | 所有 profile / 所有会话可见，无需改配置 |
| **多工具共享** | junction 进 `~/.agents/skills/`（DSH 内建约定根，Claude Code / Codex / Cursor / ZCode 等同理共享） | 与上一条**二选一**，同时挂会被发现两次 |
| **项目级** | 放进项目 `.dsh/skills/` | 随仓库分发 |
| **配置指向** | 在 `$DSH_HOME/cordis.patch.yml` 加 `skill-filesystem.customSkillDirs` 指向本仓库 | TUI 等宿主面生效 |

> 完整安装与发现机制（优先级/热重载/验证）见 `platforms/dsh/adaptation.md`「安装与发现」。

### 调用（DSH）

- 对 DSH 说「**用 new-project-init 完善文档** / **初始化项目** / **补建文档体系**」→ agent 自动用 `skill` 工具加载
- 或直接输入「**/new-project-init**」（DSH 用户显式调用）

### 其他平台的使用方式（跨平台）

本 skill 的 `SKILL.md` + frontmatter 是**通用技能格式**，不绑定任何平台：

| 平台 | 使用方式 |
|------|----------|
| **Claude Code** | 把本仓库放进 Claude Code 技能目录：`~/.claude/skills/new-project-init/`（用户级）或项目 `.claude/skills/`（项目级），然后说「用 new-project-init …」 |
| **Reasonix** | 见下文「Reasonix 适配」：`reasonix.toml` 的 `[skills] paths` 指向本仓库，或 junction 进 `~/.reasonix/skills/` |
| **ZCode** | 见下文「ZCode 适配」：junction 进 `~/.agents/skills/`（多工具共享根，推荐）或 `~/.zcode/skills/`，或项目 `.zcode/skills/` |
| **WorkBuddy** | 见下文「WorkBuddy 适配」：junction 进 `~/.workbuddy/skills/`（用户级）或项目 `.workbuddy/skills/`；它认 `AGENTS.md`、**不认** `CLAUDE.md` |
| **Cursor / 其他支持 skills 的 agent** | 同理：把含 `SKILL.md` 的目录放进对应技能的加载目录即可 |
| **任何平台的通用用法** | 直接对 agent 说「用 new-project-init 完善文档 / 初始化项目 / 补建文档体系 / 迭代」——技能正文会指导 agent 按流程执行，无需平台专属配置 |

### DSH 落地映射（skill 概念 → DSH 工具）

| skill 概念 | DSH 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester） | `subagent` / `subagent_fork`（`agents/<role>.md` 直接作 prompt 模板）；大规模并行用 `workflow` |
| 问询（🔴 一次一个 / 🟡 批量） | `ask_user_question` |
| 命令实测（构建/测试，禁止猜） | `pwsh`（Windows）/ `tool-bash` |
| 审批纪律（commit/push、SQL 先确认） | 与 DSH 审批机制（`approval: ask`）天然一致 |

---

## 🧩 Reasonix 适配

本 skill **v10.9 起深度适配 [Reasonix](https://github.com/esengine/DeepSeek-Reasonix)**（Reasonix coding harness）——**规则/模板/产出物完全跨平台**，与 DSH/Claude Code 适配互不冲突，本适配只是「在 Reasonix 里怎么落地」的指引。完整映射见 `platforms/reasonix/adaptation.md`。

### 安装（Reasonix）

**方式一：配置指向（推荐，保持单一来源）**

在 Reasonix 全局配置里加（本机为 `%APPDATA%\reasonix\config.toml`，用 `reasonix setup` 生成）：

```toml
[skills]
paths = ["F:/Software/deepseek-harness/Skill/new-project-init"]
```

**方式二：junction 进全局技能根（Windows 推荐，零 C 盘占用）**

```powershell
mkdir C:\Users\MSI\.reasonix\skills -Force
New-Item -ItemType Junction -Path C:\Users\MSI\.reasonix\skills\new-project-init -Target F:\Software\deepseek-harness\Skill\new-project-init
```

**方式三：放进项目**：复制/链接到 `<项目>/.reasonix/skills/`（Reasonix 也扫描 `.claude/skills/`、`.agents/skills/`）。

### 调用（Reasonix）

- 对 Reasonix 说「**用 new-project-init 完善文档** / **初始化项目** / **补建文档体系**」
- 常驻纪律：把 CLAUDE.md 的核心纪律摘要进项目 `AGENTS.md`（`reasonix init` 会说明），Reasonix 每次会话都会读到

### Reasonix 落地映射（skill 概念 → Reasonix 工具）

| skill 概念 | Reasonix 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester） | 原生 `task` / `review` / `wait` / `explore`；`reasonix subagent` 管理子代理 profile（`agents/<role>.md` 作模板） |
| 问询（🔴 一次一个 / 🟡 批量） | 会话内提问；🔴 关键题单独问 |
| 命令实测（构建/测试，禁止猜） | bash/shell 执行；`reasonix run` |
| 记忆纪律 | memory/ 三件套项目级落地不变；Reasonix 的 `AGENTS.md` 是补充 |
| 审批纪律（commit/push、SQL 先确认） | 与 Reasonix 权限/确认机制对齐 |

### 社区发布（reasonix.io/skills）

本 skill 已在 npm（`new-project-init`）与 GitHub 发布，Reasonix 社区版在 **https://reasonix.io/skills/** 的 **Publish** 表单提交（填 GitHub 仓库 URL 或 SKILL.md 直链）即可。

### 平台适配迭代判据（v11.0，ISSUE-014）

迭代到**平台适配**时，用三判据决定是否回对应平台实测：**①日常迭代（仅改平台无关内容）→ 免实测；②新增平台适配 → 必到该平台实测能力映射；③平台机制有变（DSH 升级 / Reasonix 工具集调整影响已登记映射）→ 回平台复核并同步 `platforms/<平台>/adaptation.md`。**完整判据见 `AGENTS.md`「平台适配开发」节——本 skill 的规则/模板/产出物始终平台无关，判据只作用于"平台落地指引是否需要复核"。

---


## 🧩 Codex 适配

本 skill **v11.1 起深度适配 [Codex](https://openai.com/codex)**（OpenAI Codex coding assistant）——**规则/模板/产出物完全跨平台**，与 DSH/Reasonix/Claude Code 适配互不冲突，本适配只是「在 Codex 里怎么落地」的指引。完整映射见 platforms/codex/adaptation.md。

### 安装（Codex）

**方式一：Junction链接（推荐，保持单一来源）**

创建Junction链接（Windows，不需要管理员权限）：

```powershell
# 创建Junction链接
New-Item -ItemType Junction -Path "$CODEX_HOME/skills/new-project-init" -Target "/path/to/new-project-init"
```

> **优点**：改动自动同步，无需手动复制；不占用额外磁盘空间。

**方式二：复制（简单但需手动同步）**

复制skill到Codex技能目录：

```powershell
# 复制skill
Copy-Item -Path "/path/to/new-project-init" -Destination "$CODEX_HOME/skills/new-project-init" -Recurse
```

> **注意**：后续迭代需要手动同步，建议使用Junction链接。

**方式三：配置指向（高级）**

在Codex全局配置（`$CODEX_HOME/config.toml`）里添加：

```toml
[skills]
paths = ["/path/to/new-project-init"]
```

> **注**：需确认Codex是否支持`[skills]`配置节；若不支持，使用环境变量方案。

**方式四：项目级（工作区豁免）**

把仓库复制/链接到`<项目>/.codex/skills/`（仅该项目可见，豁免全局记忆）。

### 调用（Codex）

- 对 Codex 说「**用 new-project-init 完善文档** / **初始化项目** / **补建文档体系**」
- 常驻纪律：把 CLAUDE.md 的核心纪律摘要进项目 AGENTS.md 或 CLAUDE.md，Codex 每次会话都会读到

### Codex 落地映射（skill 概念 → Codex 工具）

| skill 概念 | Codex 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester） | spawn_agent / send_input / wait_agent（gents/<role>.md 直接作 prompt 模板） |
| 问询（🔴 一次一个 / 🟡 批量） | equest_user_input（支持结构化问题、选项） |
| 命令实测（构建/测试，禁止猜） | shell_command（支持 PowerShell/cmd） |
| 记忆纪律 | memory/ 三件套项目级落地不变；Codex 的会话持久化是补充 |
| 审批纪律（commit/push、SQL 先确认） | 与 Codex 的 sandbox_permissions 机制对齐（equire_escalated 需用户确认） |

### 平台适配迭代判据（v11.0，ISSUE-014）

迭代到**平台适配**时，用三判据决定是否回对应平台实测：**①日常迭代（仅改平台无关内容）→ 免实测；②新增平台适配 → 必到该平台实测能力映射；③平台机制有变（DSH 升级 / Reasonix 工具集调整影响已登记映射）→ 回平台复核并同步 platforms/<平台>/adaptation.md。**完整判据见 AGENTS.md「平台适配开发」节——本 skill 的规则/模板/产出物始终平台无关，判据只作用于"平台落地指引是否需要复核"。

---

## 🧩 ZCode 适配

本 skill **v11.3 起深度适配 ZCode**（ZCode coding harness）——**规则/模板/产出物完全跨平台**，与 DSH/Reasonix/Codex/Claude Code 适配互不冲突，本适配只是「在 ZCode 里怎么落地」的指引。完整映射见 `platforms/zcode/adaptation.md`。

### 安装（ZCode）

**方式一：多工具共享根 junction（推荐，Windows；ZCode 与 Claude/Codex/Cursor 等共享同一份）**

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.agents\skills" -Force | Out-Null
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents\skills\new-project-init" -Target <本仓库路径>
```

> **优点**：改动自动同步、不占额外空间，且**内容实体仍在仓库**（单一来源）；`~/.agents/skills` 是 ZCode 官方「跨工具共享」根。装完**新开一个 ZCode 会话**确认技能出现在技能索引、`/new-project-init` 能触发。**注意**：若同时存在 `~/.zcode/skills/new-project-init`，`.zcode` 会遮蔽 `.agents`（同级 .zcode 先扫）——同一技能只保留一处 junction。

**方式二：ZCode 专属根**：放进 `~/.zcode/skills/new-project-init/`（仅 ZCode 可见，与方式一互斥）。

**方式三：项目级（团队共享）**：放进 `<项目>/.zcode/skills/` 或 `<项目>/.agents/skills/`（随仓库分发，从当前目录向上逐级生效）。

**方式四：插件清单（实验路径）**：仓库根含 `.zcode-plugin/plugin.json`，可在 ZCode「Settings → Plugin Management → Discover → +」尝试以 GitHub 仓库/本地目录添加为插件源；未做完整装机实测，失败请回退方式一。**注**：ZCode 无「任意路径技能根」配置字段（对照 Reasonix 的 `[skills] paths`），多工具共享走 `~/.agents/skills`。

### 调用（ZCode）

- 对 ZCode 说「**用 new-project-init 完善文档** / **初始化项目** / **补建文档体系**」
- 或直接输入「**/new-project-init**」（ZCode 用户显式调用）

### ZCode 落地映射（skill 概念 → ZCode 工具）

| skill 概念 | ZCode 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester） | `Agent` 子代理（独立会话不继承，prompt 含 references 必读行）；`agents/<role>.md` 作模板 |
| 独立审查（ISSUE-020 强制） | `Agent` 派独立审查子代理产 review-report，与开发主代理隔离 |
| 问询（🔴 一次一个 / 🟡 批量） | `AskUserQuestion`（结构化选项，单次最多 4 题） |
| 会话上下文管理 | `ReadSessionContext`（#sess_* 读取）+ memory/handoff/ 交接文档 |
| 规划/迭代讨论 | plan 模式（EnterPlanMode/ExitPlanMode） |
| 命令实测（构建/测试，禁止猜） | `Bash`（Windows 下 Git Bash/pwsh，长任务后台运行） |
| 常驻纪律 | 项目 `AGENTS.md`（ZCode 每次会话自动注入） |

### 平台适配迭代判据（v11.0，ISSUE-014）

迭代到**平台适配**时，用三判据决定是否回对应平台实测：**①日常迭代（仅改平台无关内容）→ 免实测；②新增平台适配 → 必到该平台实测能力映射；③平台机制有变（DSH 升级 / Reasonix 工具集调整影响已登记映射）→ 回平台复核并同步 `platforms/<平台>/adaptation.md`。**完整判据见 `AGENTS.md`「平台适配开发」节——本 skill 的规则/模板/产出物始终平台无关，判据只作用于"平台落地指引是否需要复核"。

---

## 🧩 WorkBuddy 适配（v11.4 新增 · **待实测**）

WorkBuddy 本质上是一个 **Claude Code 风格的 CLI 应用**：技能格式同为 `SKILL.md` + `references/`，常驻指令文件认 **`AGENTS.md`**（**不认** `CLAUDE.md`）。本 skill 的规则/模板/产出物无需改动即可使用。

### 安装（WorkBuddy）

**方式一：用户级 junction（推荐，保持单一来源）**

```powershell
cmd /c mklink /J "%USERPROFILE%\.workbuddy\skills\new-project-init" "<本仓库路径>"
```

**方式二：项目级（团队随仓库共享）**：放进 `<项目>\.workbuddy\skills\new-project-init`。

### WorkBuddy 落地映射（skill 概念 → WorkBuddy 工具）

| skill 概念 | WorkBuddy 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester） | `Agent` 子代理（独立上下文，prompt 含 references 必读行）；`agents/<role>.md` 作模板 |
| 问询（🔴 一次一个 / 🟡 批量） | `AskUserQuestion`（结构化选项） |
| 大规模并行 / 多阶段 | `Workflow` 工具 |
| 规划 / 迭代讨论 | `EnterPlanMode` / `ExitPlanMode` |
| 命令实测（构建/测试，禁止猜） | `PowerShell` / `Bash` |
| 常驻纪律 | 项目 `AGENTS.md`（经 asar 探测确认认 `AGENTS.md`；**自动注入时机待实测**） |

> ⚠️ **本平台适配按「三判据」②属「新增平台适配」，会话级实测尚未跑完**——完整映射与 8 条待实测清单见 [`platforms/workbuddy/adaptation.md`](platforms/workbuddy/adaptation.md)，文件内逐项标注了【实测】/【推断】/【待实测】。

---

## ✨ 核心特性

- **三种场景三分支**：存量完善（4 轮 + 限制规则 R1-R6 + 冲突消解三阶段 + 工作流闭环核查，**核心场景**）/ 中途加入（7 轮，先探索 git/目录/规范）/ 全新项目（11 轮问询）
- **问询轻重分级**：🔴 关键决策一次一个（带推荐+权衡）、🟡 批量带默认（可一键「以上都用默认」快进）
- **三层推进结构**：设计文档 → 推进清单 → 模块五件套，上层未定稿不进入下层，防「颗粒度跳级返工」
- **闭环工作流**：Planner → Developer → Reviewer（独立审查）→ Tester → 收尾回看，签署责任矩阵（谁产出谁签署，禁代签）
- **记忆库纪律**：三件套（project-context / file-index / activity-log）+ logs 细档，触发即写/入场必读/借口自查表
- **文档维护三要素**：内容实时更新 + 变更记录行 + 署名；**变更记录方向两类分法**（纯 AI 看=头插 / 有人看=尾插，防时间乱序）
- **唯一出处原则**：同一规范只在一处定义，其余引用不复制——防「多边维护漂移」
- **信息闭环图**（v10.0）：多边维护信息的唯一出处总图，人+AI 都能看懂
- **对齐 lead 颗粒度**（v10.0/v10.1）：五件套模板内嵌 lead 样板脱敏示例段 + 必填章节核对表
- **多技术栈支持**：Java/Web、C++ 后端、嵌入式（STM32/ESP32）三方向示例片段，按问询答案取用
- **入口文件「常驻 vs 按需」分层**（v11.4）：生成的 `AGENTS.md`/`CLAUDE.md` 只放**无论做什么都要遵守 / 都要知道去哪找**的内容（项目事实速查 + 路线表 + 硬门禁），细则全部外移到独立规范文件——因为平台会**自动注入**入口文件，越长越贵、且有硬上限（Codex 32 KiB / Claude Code 40k 字符 / DSH 64 KiB），**目标 ≤ 8 KB**
- **防「做了事、忘了写文档」**（v11.4）：入口文件常驻一张「**动作 → 必须更新**」表（新增工具/依赖/命令/接口/字段/目录、踩坑…→ 必须同时更新哪个文档），与「回答末尾自检·动作回看」「模块收尾·文档影响清点」三处联动；另配**遗漏型借口自查表**（专治「只是个小脚本」「以后补」这类无自觉的遗漏）
- **踩坑两层沉淀**（v11.4）：`docs/已知坑/`＝索引（规则速查 + 全部坑索引，1–3 KB）＋ 单篇（现象/排查/根因/固定解法/**如何验证已规避**/提炼规则），把「会再犯的模式」沉淀成可查的规则；准入三判据（隐蔽 + 系统性 + 重犯代价高），**新建单篇必须同时补索引**

> 完整设计思想（历史 v1-v9 + v10.0 共 14 条）见 `SKILL.md`「设计思想速览（全版本）」节。

---

## 🗺️ 大白话 × 专业词 对照表

| 大白话 | 专业词 | 是什么意思 |
|--------|--------|-----------|
| 让 AI 分角色干活 | **多 agent 分工 / agents 角色** | 规划、写代码、审查、测试各由一个 AI 扮演，各管一段、互相验收 |
| AI 进场的"项目笔记" | **记忆库三件套（memory/）** | 3 个记录项目「状态/文件/进度」的文件，AI 每次开工前必读，防失忆 |
| 每天的工作流水账 | **logs 细档** | 按角色+日期记录每一步动作、异常、交接 |
| 每个功能的"开工-验收"五张表 | **specs 五件套** | plan/acceptance/changelog/review/test 五份文档，谁产出谁签字 |
| 项目的"宪法" | **CLAUDE.md** | 技术栈/命名/接口/编码规则 + 工作流 + 记忆纪律，人和 AI 都看它 |
| 文档改了要留痕迹 | **变更记录 + 署名** | 每份文档末尾记「什么时候/改了啥/谁改的」，防乱改、可追查 |
| 文档乱了的"存量完善" | **存量完善（核心场景）** | 项目已有文档但乱/不闭环：以你口述为准、在途模块不动、只理顺不重构代码 |

---

## 🎯 三种适用场景

| 场景 | 触发语 | 走什么流程 | 产出什么 |
|------|--------|-----------|----------|
| **已有文档想完善（核心）** | 「用 new-project-init 完善文档」 | 4 轮问询 + 限制规则 R1-R6 + 冲突消解三阶段 + 工作流闭环核查 | 文档规范化 + 工作流补闭环（只记录不重构） |
| **中途加入已有项目** | 「用 new-project-init 补建文档体系」 | 探索先行（git/目录/规范）+ 7 轮问询 | 补建整套规范（已有代码保留演进） |
| **新项目开工前** | 「用 new-project-init 初始化项目」 | 第 0 轮摸底 + 11 轮问询（技术栈/团队/记忆/git/编码/文档…） | CLAUDE.md + memory 三件套 + docs + specs 框架 + .gitignore |
| **迭代本 skill** | 「用 new-project-init 迭代」 | 讨论驱动 + 四原则 + testing/ 走查 | skill 自身改进（版本演进记 CREATION-LOG） |

---

## 📁 目录结构

```
new-project-init/
├── SKILL.md                    # 主文件：总入口/场景骨架/强制规则/附录（34 模板索引，平台无关）
├── references/                 # 场景详细问询题库外置（v11.0 强门禁）：references/场景/*.md 三场景全文题库
├── AGENTS.md                   # 开发者入口（布局/开发工作流/发布/迭代说明）
├── README.md                   # 本文件（对外介绍，含各平台安装说明）
├── LICENSE / CONTRIBUTING.md / package.json / .gitignore
├── platforms/                  # 多平台适配，按平台分目录（v10.10 起）
│   ├── reasonix/adaptation.md  # Reasonix 能力映射全文
│   ├── dsh/adaptation.md       # DSH 能力映射全文
│   ├── codex/adaptation.md     # Codex 能力映射全文（v11.1）
│   ├── zcode/adaptation.md     # ZCode 能力映射全文（v11.3）
│   ├── workbuddy/adaptation.md # WorkBuddy 能力映射全文（v11.4，待会话级实测）
│   └── dsh/cordis.patch.yml    # DSH bundle patch（package.json 的 dsh.bundle 指向）
├── docs/
│   └── CREATION-LOG.md         # 完整版本演进历史（v3 → v11.4）
├── lib/index.js                # DSH 插件：skill provider（把根目录 SKILL.md 注册进技能注册表）
├── scripts/                    # 开发脚本（secret.ps1 私密加解密 / publish.ps1 发布前检查）
├── templates/                  # 34 个模板，按产出模式分 3 目录（v11.0：27~31 可装配；v11.4：32~34 新增）
│   ├── 一次性/                 # 特化即正式文件（CLAUDE.md / docs / 记忆库三件套 / gitignore / 可装配规范 等 24 个）
│   ├── 多次-单文件/            # 复制单模板文件新建（logs 每日 / handoff 交接）
│   └── 多次-含文件夹/          # 复制整个特化模板文件夹新建（specs 五件套 / agents / checklist / 已知坑）
├── testing/                    # 四个验证走查（全新/中途/存量/模板）——skill 迭代者用
├── .zcode-plugin/plugin.json   # ZCode 插件清单（v11.3，支持插件方式安装）
└── _private/                   # 私密文件（明文不入库；*.enc AES-GCM 密文入库，仅维护者解密）
```

## 三种产出模式（skill 用完后）

| 产出模式 | 目录 | 使用方式 |
|----------|------|----------|
| 只创建一次 | `一次性/` | 特化即正式文件；更新式改内容+变更记录+署名 |
| 多次创建-不含文件夹 | `多次-单文件/` | 复制单模板文件新建（如每日日志） |
| 多次创建-含文件夹 | `多次-含文件夹/` | 复制整个特化模板文件夹新建（如 specs/module-XXX/） |

---

## 🚀 快速开始

1. **已有文档想完善规范（核心）**：对 agent 说「用 new-project-init 完善文档」→ 走 4 轮问询 + 限制规则 R1-R6 + 冲突消解三阶段
2. **中途加入已有项目**：对 agent 说「用 new-project-init 补建文档体系」→ 走 7 轮问询（先探索 git/目录/规范）
3. **新项目开工前**：对 agent 说「用 new-project-init 初始化项目」→ 走 11 轮问询 → 产出整套规范文件
4. **想迭代本 skill**：对 agent 说「用 new-project-init 迭代」→ 讨论驱动，多轮讨论定案后才改

> **DSH 用户**：以上触发语照说即可；或在输入框直接输入 `/new-project-init`。技能安装见上文「DSH 适配」。

---

## ❓ FAQ

**Q：这个 skill 是干什么的？说人话。**
A：帮你把项目的「文档 + AI 协作规矩」立起来。AI 先问你项目情况，再按你的答案生成一套规范文件；以后任何 AI 进场，都知道先读什么、怎么干活、怎么留记录。**最擅长救「文档已经有点乱」的项目**。

**Q：这个 skill 和 superpowers 什么关系？**
A：**设计方法论受启发，内容是原创**。触发条件式描述、完成前验证、集成选项交给用户等思想借鉴自 superpowers / superpowers-zh；但模板体系（31 个）、问询流程（三场景）、记忆库纪律、模块五件套闭环均为本 skill 在 PTB-IMP 项目实战沉淀的原创内容。

**Q：文档里说的「本项目」「PTB-IMP」「lead 样板」是什么？**
A：都是**示例项目脱敏指代**（PTB-IMP 是作者实战验证的项目）。你完全可以忽略或用自有项目替换——模板只供结构参考，内容按你的问询答案特化。

**Q：已有项目的文档已经乱了，能救吗？**
A：能。「存量完善」场景专门处理这个：进度以你口述为准、在途模块隔离不改、冲突消解三阶段（差异诊断/唯一出处去重/索引核查）、只记录不重构。

**Q：一定要多 agent 分工吗？**
A：不必。单人 + agent 可选「精简模式」（只要 README + CLAUDE.md + memory 三件套），多 agent 分工才走完整闭环。

**Q：问询会很多吗？**
A：全新场景最多 11 轮，但 🔴 关键题一次一个（附推荐+权衡）、🟡 批量题可一键「以上都用默认」快进——不想答的轮次可以跳过。

**Q：skill 能自己迭代吗？**
A：可以，且是设计目标。对 agent 说「用 new-project-init 迭代」→ 讨论驱动（多轮讨论定案才改）+ 四原则（语言无关/双受众三因素/on-off/唯一出处）+ testing/ 走查验证。

---

## 🤝 贡献

欢迎参与！模板改进、问询优化、新场景支持都可以。

**贡献方向**：符合本 skill 定位的改进——**把 AI 协作工作流固化得更规范、更可操作**。好的贡献应该：
- 教 AI 助手**怎么按规范干活**，而不是某个框架/语言的教程
- 解决实际项目中「文档乱/流程不闭环/多边漂移」的痛点
- 遵守迭代纪律：讨论驱动 + 逐文件三要素（变更记录行）+ 唯一出处原则

---

## 🙏 致谢

- **设计方法论启发**：[obra/superpowers](https://github.com/obra/superpowers)（英文原版）与 [jnMetaCode/superpowers-zh](https://github.com/jnMetaCode/superpowers-zh)（中文增强版）——触发条件式描述、完成前验证、集成选项交给用户等思想
- **实战验证**：PTB-IMP 项目（Spring Boot + Vue3），34 个模板在真实模块开发中迭代沉淀
- **项目团队（PTB-IMP 实战贡献）**：
  - 组长 **white-bai-k** — [gitee.com/white-bai-k](https://gitee.com/white-bai-k)（lead 样板 module-004 五件套产出者）
  - 组员 **ssss_777** — [gitee.com/ssss_777](https://gitee.com/ssss_777)（white 分支模块开发：module-006~013 等）
  - 组员 **wshsds** — [gitee.com/wshsds](https://gitee.com/wshsds)（PTB-IMP 项目组员）
- **作者**：warm-flame-core

---

## 👤 作者 & 链接

<img src="https://github.com/warm-flame-core.png" width="48" height="48" alt="warm-flame-core" align="left" style="border-radius:8px;margin-right:12px">

- 👤 **warm-flame-core** — [github.com/warm-flame-core](https://github.com/warm-flame-core) · [gitee.com/warm-flame-core](https://gitee.com/warm-flame-core)
- 本 skill 在 PTB-IMP 项目（Spring Boot + Vue3）实战中迭代沉淀，v10.1 起可对外分享，v10.7 起深度适配 DeepSeek Harness（DSH），v10.9 起深度适配 Reasonix，v11.1 起适配 Codex，v11.3 起深度适配 ZCode

<br clear="both">

---

## 📄 许可证

[MIT](LICENSE) — 自由使用、修改、分享（保留版权声明即可）。

---

## 📝 变更记录

| 日期 | 变更内容 | 署名 |
|------|----------|------|
| 2026-09-30 | **v11.4：入口规范文件瘦身（常驻 vs 按需）+ 防遗忘机制 + DSH 0.2.0-rc.2 适配复核 + WorkBuddy 适配**——①确立「入口文件=常驻区」原则（只放无条件的门禁 + 去哪找）与**体量门禁 ≤8 KB**（各平台自动注入上限：Codex 32 KiB / Claude Code 40k 字符 / DSH 64 KiB）②新增「**动作 → 必须更新**」触发侧门禁表 + 「**规范索引**」路由表（按需加载成立的前提）③模板 01 重写 398→287 行：C 区→**模板 32 `docs/AI协作规范.md`**、B 区→**模板 33 `docs/编码规范.md`**、踩坑→**模板 34 `docs/已知坑/`**（README 索引 + 单篇 NNNN + 模板；准入三判据；新建单篇须同补索引）④防遗忘三处联动（入口表 ↔ 记忆库自检三步→**四步·动作回看** ↔ 模板 24 阶段 6「文档影响清点」）+ **遗漏型借口自查表**⑤口径裁决：防遗忘统一 **5 条**、收尾四查唯一出处=模板 24 阶段 5、`<AI协作规范文件>` 新占位符随迁全仓引用⑥**DSH 适配复核**：修正 adaptation 2b 表 workflow「继承」事实错误（实为**不继承**）、`customSkillDirs` 段落重写、`--profile` 与 junction 重复警示；`lib/index.js` frontmatter 加固（块标量 + 官方 invocation 键 + 修 CRLF 解析缺陷）⑦**新增 WorkBuddy 适配**（`platforms/workbuddy/adaptation.md`，认 `AGENTS.md`、技能根 `~/.workbuddy/skills/`；**待会话级实测**）⑧README：DSH 安装节补 profile 语义、新增 WorkBuddy 节、跨平台表补行、计数 31→34；package.json 1.2.0→**1.3.0** | warm-flame-core-DSH-Developer@main |
| 2026-09-12 | v11.3：**五件套颗粒度机制 + 流程 gate 一批 + ZCode 适配**——新增 `references/五件套颗粒度标尺.md`（颗粒度下限表/BDD 场景类型覆盖清单/脱敏实例/30 硬验收词表）+ SKILL.md 强门禁第 4 条、样板固化机制、强制规则新增（五件套证据密度/独立审查/测试账号基于权限矩阵/最小对比验证/DDL 前实测库类型/权限白名单三处对齐）；模板 17~21/24/05/14 + references 问询 U10/U-M4 同步；新增 `platforms/zcode/adaptation.md` + `.zcode-plugin/plugin.json`，README 新增「ZCode 适配」节并补作者栏/英文摘要/目录树（含补登 Codex）；package.json 1.1.0→1.2.0（description/keywords 补 ZCode）；ISSUES 019~026/028~032 关闭 | warm-flame-core-ZCode-Developer@main |
| 2026-08-19 | v11.2：DSH 完全适配复核 + npm 恢复发布 + 插件市场上架——README「DSH 安装」节删除线清除，恢复 npm 命令 `dsh plugin --profile web add new-project-init`（推荐，免生成构建批准；GitHub 备选）；package.json 升 1.1.0 并发布 npm；GitHub 加 `dsh-plugin` topic + push；awesome-dsh-plugin 上架 PR（条目 YAML + 重新生成 README）；DSH 复核/实测/发布记录见 `_private/上架-04` | warm-flame-core-DSH-Developer@main |
| 2026-08-19 | v11.1：补录 Codex 平台适配到版本表（自身已在 README 有「Codex 适配」节）；本次为「上架计划准备」——用户要求恢复 npm 安装渠道并上架 awesome-dsh-plugin 插件市场，计划书完整写入 `_private/上架-00~04`（执行计划 DSH 交接 / awesome-dsh-plugin 条目 / 描述文案 / DSH 实测清单 / 测试记录模板），ISSUES 记 ISSUE-015；**npm 恢复发布 / DSH 实测 / 上架 PR 由后续 DSH 解密按计划书独立执行**，本次只落盘 + 版本记录，日期取系统当天 | Reasonix（skill 迭代） |
| 2026-08-18 | v11.0（README 对齐 + 推荐，日期取系统当天 08-18）：README 全量对齐 v11.0 大改——模板数 26→31（27~31 可装配）、目录结构补 references/ 与 31 模板/一次性 22 个、CREATION-LOG 版本 v11.0、存量完善定位补平台入口映射（CLAUDE.md/AGENTS.md 由主导平台定名）；新增「同类工具与推荐（superpowers 生态）」小节（原生态 obra/superpowers + 中文版 superpowers-zh + Reasonix 移植 superpowers-reasonix，注明原生版对存量完善适配不佳、本 skill 是差异化补充；其他平台移植未能联网核实、未编造仓库名） | Reasonix（skill 迭代） |
| 2026-08-17 | v11.0：平台适配节新增「平台适配迭代判据」（ISSUE-014：日常迭代免实测/新增平台必实测/平台机制变需复核，完整判据见 AGENTS.md）；新增模板 30/31（git worktrees / 并行 agent 调度，BL-01/02 可装配默认关）与四段式署名/排版/commit/PR 等 v11.0 迭代说明 | Reasonix（skill 迭代） |
| 2026-08-17 | 仓库布局重组（v10.10）：references/ 按平台拆分 → platforms/<平台>/；CREATION-LOG.md → docs/；新增 AGENTS.md；私密文件加密进 _private/（*.enc 入库，明文不入库）；npm 安装停止维护（删除线标注），发布改为 GitHub 唯一渠道 | warm-flame-core（skill 迭代） |
| 2026-08-16 | 新增「Reasonix 适配」节（v10.9，安装三方式/调用/落地映射/社区发布）；跨平台表补 Reasonix 行；英文摘要与作者栏补 v10.9；增加 Reasonix 徽章；目录树 references/ 行补 reasonix-adaptation.md | DSH 适配（agent） |
| 2026-08-16 | 打包为 DSH 插件（v10.8）：新增 package.json（`dsh.bundle`）+ lib/index.js（skill provider）+ cordis.patch.yml；DSH 安装节改为「插件安装（npm/GitHub/本地文件夹）+ 本地文件安装」双方式，新增「其他平台的使用方式」跨平台表；目录树补插件文件行 | DSH 适配（agent） |
| 2026-08-16 | README 白话化重写：开头加大白话介绍、新增「大白话 × 专业词对照表」、DSH 适配节前置扩写（安装/调用/映射）、致谢补全组员 wshsds（[gitee.com/wshsds](https://gitee.com/wshsds)）、增加 DSH 适配徽章 | DSH 适配（agent） |
| 2026-08-16 | 新增「DSH 适配」节（v10.7，安装/调用/落地映射三要点）；README 补变更记录表（原缺，按文档维护规则第 1 条补齐） | DSH 适配（agent） |






