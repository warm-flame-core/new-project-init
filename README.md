# new-project-init（项目文档体系初始化 · 提问驱动）

> 🦸 **把「AI 分角色协作开发」工作流固化到项目里的工程化教练** — 新项目开工前、中途加入已有项目、已有文档想完善规范，三种场景全覆盖。从提问驱动落实规范，到模块五件套闭环，每个模板都是 PTB-IMP 项目实战验证的方法论沉淀。

A question-driven project scaffolding skill: turn your planning into project-specific spec files (CLAUDE.md / memory / docs / specs workflow). Design methodology inspired by [superpowers](https://github.com/obra/superpowers) & [superpowers-zh](https://github.com/jnMetaCode/superpowers-zh).

[![作者 warm-flame-core](https://img.shields.io/badge/👤_作者-warm--flame--core-blue)](https://github.com/warm-flame-core)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

---

## 📊 项目规模

| 📦 模板 | 🎯 适用场景 | 📄 产出物 | 🧪 验证走查 |
|:---:|:---:|:---:|:---:|
| **26 个**（按产出模式分 3 目录） | **全新项目 / 中途加入 / 存量完善** | **CLAUDE.md + memory 三件套 + docs + specs 五件套** | **4 个场景走查**（skill 自身迭代验证） |

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

## 这是什么？

一个「**项目文档体系初始化**」skill——通过**提问驱动**把项目规划落实为一组特化规范文件，并固化「AI 分角色协作开发」工作流。

**核心机制：提问驱动落实**。每个规范文件不是照模板硬套，而是先问你对项目的规划（技术栈/团队/记忆/git/编码/文档…），按你的答案特化生成；答不上来的给推荐默认（标注「可改」）。

---

## ✨ 核心特性

- **三种场景三分支**：全新项目（11 轮问询）/ 中途加入（7 轮，先探索 git/目录/规范）/ 存量完善（4 轮 + 限制规则 R1-R6 + 冲突消解三阶段 + 工作流闭环核查）
- **问询轻重分级**：🔴 关键决策一次一个（带推荐+权衡）、🟡 批量带默认（可一键「以上都用默认」快进）
- **三层推进结构**：设计文档 → 推进清单 → 模块五件套，上层未定稿不进入下层，防「颗粒度跳级返工」
- **闭环工作流**：Planner → Developer → Reviewer（独立审查）→ Tester → 收尾回看，签署责任矩阵（谁产出谁签署，禁代签）
- **记忆库纪律**：三件套（project-context / file-index / activity-log）+ logs 细档，触发即写/入场必读/借口自查表
- **文档维护三要素**：内容实时更新 + 变更记录行 + 署名；**变更记录方向两类分法**（读最近=顶部插最新 / 读演进=底部追加，防时间乱序）
- **唯一出处原则**：同一规范只在一处定义，其余引用不复制——防「多边维护漂移」
- **信息闭环图**（v10.0）：多边维护信息的唯一出处总图，人+AI 都能看懂
- **对齐 lead 颗粒度**（v10.0/v10.1）：五件套模板内嵌 lead 样板脱敏示例段 + 必填章节核对表
- **多技术栈支持**：Java/Web、C++ 后端、嵌入式（STM32/ESP32）三方向示例片段，按问询答案取用

> 完整设计思想（历史 v1-v9 + v10.0 共 14 条）见 `SKILL.md`「设计思想速览（全版本）」节。

---

## 🎯 三种适用场景

| 场景 | 触发语 | 走什么流程 | 产出什么 |
|------|--------|-----------|----------|
| **新项目开工前** | 「用 new-project-init 初始化项目」 | 第 0 轮摸底 + 11 轮问询（技术栈/团队/记忆/git/编码/文档…） | CLAUDE.md + memory 三件套 + docs + specs 框架 + .gitignore |
| **中途加入已有项目** | 「用 new-project-init 补建文档体系」 | 探索先行（git/目录/规范）+ 7 轮问询 | 补建整套规范（已有代码保留演进） |
| **已有文档想完善** | 「用 new-project-init 完善文档」 | 4 轮问询 + 限制规则 R1-R6 + 冲突消解三阶段 + 工作流闭环核查 | 文档规范化 + 工作流补闭环（只记录不重构） |
| **迭代本 skill** | 「用 new-project-init 迭代」 | 讨论驱动 + 四原则 + testing/ 走查 | skill 自身改进（版本演进记 CREATION-LOG） |

---

## 📁 目录结构

```
new-project-init/
├── SKILL.md                    # 主文件：问询流程/执行流程/强制规则/附录（26 模板索引）
├── README.md                   # 本文件（对外介绍）
├── CREATION-LOG.md             # 完整版本演进历史（v3 → v10.x）
├── LICENSE                     # MIT 协议
├── templates/                  # 26 个模板，按产出模式分 3 目录
│   ├── 一次性/                 # 特化即正式文件（CLAUDE.md / docs / 记忆库三件套 / gitignore 等 17 个）
│   ├── 多次-单文件/            # 复制单模板文件新建（logs 每日 / handoff 交接）
│   └── 多次-含文件夹/          # 复制整个特化模板文件夹新建（specs 五件套 / agents / checklist）
└── testing/                    # 四个验证走查（全新/中途/存量/模板）——skill 迭代者用
```

## 三种产出模式（skill 用完后）

| 产出模式 | 目录 | 使用方式 |
|----------|------|----------|
| 只创建一次 | `一次性/` | 特化即正式文件；更新式改内容+变更记录+署名 |
| 多次创建-不含文件夹 | `多次-单文件/` | 复制单模板文件新建（如每日日志） |
| 多次创建-含文件夹 | `多次-含文件夹/` | 复制整个特化模板文件夹新建（如 specs/module-XXX/） |

---

## 🚀 快速开始

1. **新项目开工前**：对 agent 说「用 new-project-init 初始化项目」→ 走 11 轮问询 → 产出整套规范文件
2. **中途加入已有项目**：对 agent 说「用 new-project-init 补建文档体系」→ 走 7 轮问询（先探索 git/目录/规范）
3. **已有文档想完善规范**：对 agent 说「用 new-project-init 完善文档」→ 走 4 轮问询 + 限制规则 R1-R6 + 冲突消解三阶段
4. **想迭代本 skill**：对 agent 说「用 new-project-init 迭代」→ 讨论驱动，多轮讨论定案后才改

---

## ❓ FAQ

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
  - 组员 **（gitee 待补充）** — 暂无 gitee 链接，留位待补充
- **作者**：warm-flame-core

---

## 👤 作者 & 链接

<img src="https://github.com/warm-flame-core.png" width="48" height="48" alt="warm-flame-core" align="left" style="border-radius:8px;margin-right:12px">

- 👤 **warm-flame-core** — [github.com/warm-flame-core](https://github.com/warm-flame-core) · [gitee.com/warm-flame-core](https://gitee.com/warm-flame-core)
- 本 skill 在 PTB-IMP 项目（Spring Boot + Vue3）实战中迭代沉淀，v10.1 起可对外分享

<br clear="both">

---

## 📄 许可证

[MIT](LICENSE) — 自由使用、修改、分享（保留版权声明即可）。
