# new-project-init（项目文档体系初始化 · 提问驱动）

> 🦸 **「项目文档乱成一团？换个 AI 就不知道项目在干嘛？」——这个 skill 帮你把项目的文档、规矩、AI 协作流程一次性立起来。**

**用大白话说**：你项目里有一堆文档要**建、要整理、要立规矩**，还要让 AI 以后**按规矩帮你干活**——用这个 skill，AI 会先问清楚你的项目情况（技术栈、团队、习惯……问到你烦为止，答不上来它会给默认），再按你的答案生成一套规范文件（CLAUDE.md、AI 记忆库、docs 文档、模块流程等），以后**每个 AI 进场都知道先读什么、怎么干活、怎么留记录**。**重点场景是「存量完善」：项目跑了一半、文档已经有点乱的**——不乱动你的代码，只把文档和流程理顺（只记录不重构）。

A question-driven skill focused on **optimizing existing project docs & AI-collaboration workflows** (存量完善) — and scaffolding new projects, or joining one mid-way. **Adapted for DeepSeek Harness (DSH, v10.7) and Reasonix (v10.9)**; also works with Claude Code and other skill-capable agents. Design methodology inspired by [superpowers](https://github.com/obra/superpowers) & [superpowers-zh](https://github.com/jnMetaCode/superpowers-zh).

[![作者 warm-flame-core](https://img.shields.io/badge/👤_作者-warm--flame--core-blue)](https://github.com/warm-flame-core)
[![DSH 适配](https://img.shields.io/badge/DeepSeek_Harness-深度适配-4F46E5)](https://github.com/deepseek-ai/deepseek-harness)
[![Reasonix 适配](https://img.shields.io/badge/Reasonix-深度适配-1E8E3E)](https://reasonix.io/skills/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

---

## 📊 项目规模

| 📦 模板 | 🎯 适用场景 | 📄 产出物 | 🧪 验证走查 |
|:---:|:---:|:---:|:---:|
| **26 个**（按产出模式分 3 目录） | **存量完善 / 中途加入 / 全新项目**（以存量完善为核心） | **CLAUDE.md + memory 三件套 + docs + specs 五件套** | **4 个场景走查**（skill 自身迭代验证） |

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

## 🖥️ DeepSeek Harness（DSH）适配

本 skill **v10.7 起深度适配 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)**（DSH）——**规则/模板/产出物完全跨平台**，Claude Code 等其他工具照常使用，本适配只是「在 DSH 里怎么落地」的指引。

### 安装（DSH）

**方式一：DSH 插件安装（GitHub）—— 本仓库同时是一个 DSH 插件包（`dsh.bundle`），安装即注册技能**

```sh
# ~~npm 包（v10.9 及以前，已停止维护）~~
# ~~dsh plugin --profile web add new-project-init~~

# 从 GitHub 安装（当前唯一插件渠道）
dsh plugin --profile web add github:warm-flame-core/new-project-init
```

> 装完重启 profile（`dsh web`），技能即出现在会话技能目录。其他 profile（desktop / headless）把 `--profile` 换成对应名字；也可以从本地文件夹安装（`dsh plugin --profile web add <仓库路径>`）。

**方式二：本地文件安装（无需插件系统，所有 profile 通用）**

| 方式 | 做法 | 说明 |
|------|------|------|
| **用户级（推荐）** | 把本仓库放进 `$DSH_HOME/skills/`（Windows 默认 `C:\Users\MSI\.dsh\skills\`；可用 **junction 指向本仓库**，保持单一来源） | 所有 profile / 所有会话可见，无需改配置 |
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
├── SKILL.md                    # 主文件：问询流程/执行流程/强制规则/附录（26 模板索引，平台无关）
├── AGENTS.md                   # 开发者入口（布局/开发工作流/发布/迭代说明）
├── README.md                   # 本文件（对外介绍，含各平台安装说明）
├── LICENSE / CONTRIBUTING.md / package.json / .gitignore
├── platforms/                  # 多平台适配，按平台分目录（v10.10 起）
│   ├── reasonix/adaptation.md  # Reasonix 能力映射全文
│   ├── dsh/adaptation.md       # DSH 能力映射全文
│   └── dsh/cordis.patch.yml    # DSH bundle patch（package.json 的 dsh.bundle 指向）
├── docs/
│   └── CREATION-LOG.md         # 完整版本演进历史（v3 → v10.x）
├── lib/index.js                # DSH 插件：skill provider（把根目录 SKILL.md 注册进技能注册表）
├── scripts/                    # 开发脚本（secret.ps1 私密加解密 / publish.ps1 发布前检查）
├── templates/                  # 26 个模板，按产出模式分 3 目录
│   ├── 一次性/                 # 特化即正式文件（CLAUDE.md / docs / 记忆库三件套 / gitignore 等 17 个）
│   ├── 多次-单文件/            # 复制单模板文件新建（logs 每日 / handoff 交接）
│   └── 多次-含文件夹/          # 复制整个特化模板文件夹新建（specs 五件套 / agents / checklist）
├── testing/                    # 四个验证走查（全新/中途/存量/模板）——skill 迭代者用
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
A：**设计方法论受启发，内容是原创**。触发条件式描述、完成前验证、集成选项交给用户等思想借鉴自 superpowers / superpowers-zh；但模板体系（26 个）、问询流程（三场景）、记忆库纪律、模块五件套闭环均为本 skill 在 PTB-IMP 项目实战沉淀的原创内容。

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
- **实战验证**：PTB-IMP 项目（Spring Boot + Vue3），26 个模板在真实模块开发中迭代沉淀
- **项目团队（PTB-IMP 实战贡献）**：
  - 组长 **white-bai-k** — [gitee.com/white-bai-k](https://gitee.com/white-bai-k)（lead 样板 module-004 五件套产出者）
  - 组员 **ssss_777** — [gitee.com/ssss_777](https://gitee.com/ssss_777)（white 分支模块开发：module-006~013 等）
  - 组员 **wshsds** — [gitee.com/wshsds](https://gitee.com/wshsds)（PTB-IMP 项目组员）
- **作者**：warm-flame-core

---

## 👤 作者 & 链接

<img src="https://github.com/warm-flame-core.png" width="48" height="48" alt="warm-flame-core" align="left" style="border-radius:8px;margin-right:12px">

- 👤 **warm-flame-core** — [github.com/warm-flame-core](https://github.com/warm-flame-core) · [gitee.com/warm-flame-core](https://gitee.com/warm-flame-core)
- 本 skill 在 PTB-IMP 项目（Spring Boot + Vue3）实战中迭代沉淀，v10.1 起可对外分享，v10.7 起深度适配 DeepSeek Harness（DSH），v10.9 起深度适配 Reasonix

<br clear="both">

---

## 📄 许可证

[MIT](LICENSE) — 自由使用、修改、分享（保留版权声明即可）。

---

## 📝 变更记录

| 日期 | 变更内容 | 署名 |
|------|----------|------|
| 2026-08-17 | 仓库布局重组（v10.10）：references/ 按平台拆分 → platforms/<平台>/；CREATION-LOG.md → docs/；新增 AGENTS.md；私密文件加密进 _private/（*.enc 入库，明文不入库）；npm 安装停止维护（删除线标注），发布改为 GitHub 唯一渠道 | warm-flame-core（skill 迭代） |
| 2026-08-16 | 新增「Reasonix 适配」节（v10.9，安装三方式/调用/落地映射/社区发布）；跨平台表补 Reasonix 行；英文摘要与作者栏补 v10.9；增加 Reasonix 徽章；目录树 references/ 行补 reasonix-adaptation.md | DSH 适配（agent） |
| 2026-08-16 | 打包为 DSH 插件（v10.8）：新增 package.json（`dsh.bundle`）+ lib/index.js（skill provider）+ cordis.patch.yml；DSH 安装节改为「插件安装（npm/GitHub/本地文件夹）+ 本地文件安装」双方式，新增「其他平台的使用方式」跨平台表；目录树补插件文件行 | DSH 适配（agent） |
| 2026-08-16 | README 白话化重写：开头加大白话介绍、新增「大白话 × 专业词对照表」、DSH 适配节前置扩写（安装/调用/映射）、致谢补全组员 wshsds（[gitee.com/wshsds](https://gitee.com/wshsds)）、增加 DSH 适配徽章 | DSH 适配（agent） |
| 2026-08-16 | 新增「DSH 适配」节（v10.7，安装/调用/落地映射三要点）；README 补变更记录表（原缺，按文档维护规则第 1 条补齐） | DSH 适配（agent） |
