# new-project-init · ZCode 适配说明

> 📍 变更记录（纯 AI 看，头插）：
> `2026-09-12 | 新增：ZCode 适配说明（v11.3，ISSUE-019~031 一批迭代 + zcode 平台适配）——按三判据②在本平台（ZCode 会话）实测：AskUserQuestion 问询 / Agent 子代理（Explore×3 派发验证）/ references 读取 / Edit old_string 唯一性报错行为 / ~/.agents/skills（多工具共享根）junction 发现机制；安装推荐由 ~/.zcode/skills 改为 ~/.agents/skills（ZCode 无任意路径技能根字段，.zcode 专属根会遮蔽 .agents，同技能二选一） | warm-flame-core-ZCode-Developer@main`

> 本文件是 SKILL.md「平台适配」节的展开。**只提供「在 ZCode 中怎么落地」的指引，不改变 skill 的任何规则/模板/产出物**；在其他平台（Claude Code / DSH / Reasonix 等）运行时忽略本文件，照常执行 SKILL.md 原流程。

## 1. 加载与调用（ZCode）

- **技能格式**：与 Claude Code/DSH/Reasonix 相同——目录 + `SKILL.md`（YAML frontmatter：`name`/`description`/`whenToUse`）。本 skill 的 frontmatter 直接兼容。
- **技能根（按优先级，先发现者生效；同级 `.zcode` 先于 `.agents`）**：
  - 用户级：`~/.zcode/skills/`（仅 ZCode）
  - 用户级跨工具共享：`~/.agents/skills/`（Claude/Codex/Cursor 等也认）
  - 项目级：`<repo>/.zcode/skills/`、`<repo>/.agents/skills/`（从当前目录向上逐级到仓库根，每级都算；团队随仓库共享）
  - 插件技能根（优先级最低）
- **验证**：技能出现在会话系统提示的技能索引里（新会话生效；运行中会话不补发现——装完需新开会话确认）。
- **调用**：用户说「用 new-project-init …」→ agent 用 `Skill` 工具加载；或直接输入 `/new-project-init`（用户显式斜杠调用，命名空间为裸名）。
- **常驻纪律**：ZCode 自动把项目根 `AGENTS.md` 注入每次会话（workspace instruction；用户级 `~/.zcode/AGENTS.md` 先注入、workspace 的后注入可覆盖）——把本 skill 的「记忆库写入纪律/入场核对」要点写进项目 `AGENTS.md` 即可与 ZCode 工作流融合；`CLAUDE.md` 等其他入口文件须 agent 按入场纪律主动读。

## 2. 能力映射表（skill 概念 → ZCode 工具）

| skill 概念 | ZCode 落地 |
|---|---|
| 问询（🔴 一次一个 / 🟡 批量） | `AskUserQuestion` 工具（结构化选择题，**单次最多 4 题**、支持 multiSelect/preview/推荐项标 Recommended）——🔴 关键题单独一问，🟡 批量题 ≤4 题合并一次；每题 2-4 个选项 +「Other」自由输入自动提供 |
| 多 agent 角色（Planner/Developer/Reviewer/Tester，`agents/<role>.md`） | `Agent` 工具派子代理（subagent_type：general-purpose / Explore 等；并行多代理单消息多 tool call）；`agents/<role>.md` 内容作子代理 prompt 模板（见 2b 上下文档位） |
| 独立审查（v11.3 强制规则 ISSUE-020） | `Agent` 派独立审查子代理（general-purpose）产 review-report——**与开发主代理隔离，禁自审**；后台运行 `run_in_background` 可异步 |
| 规划/迭代讨论（多轮讨论定案） | plan 模式（`EnterPlanMode`/`ExitPlanMode`：只读勘探 → 出计划 → 用户批准后执行）——与「讨论驱动迭代」纪律天然对齐 |
| 会话上下文管理（H 组问询 / 交接） | `ReadSessionContext`（按 `#sess_*` 会话 id 读取历史会话上下文，relevant/handoff 两种策略）+ 项目内 memory/handoff/ 交接文档互补 |
| 命令实测（构建/测试，禁止猜） | `Bash` 工具（Windows 下 Git Bash / 可调 pwsh；长任务 `run_in_background`） |
| 文件系统（读/写/编辑） | `Read` / `Write` / `Edit`（**Edit 强制 old_string 全局唯一且需先 Read**，见第 6 节已知坑）/ Glob/Grep（经 Bash） |
| 待办/进度 | `TodoWrite`（会话任务清单，可作模块推进的临时进度辅助；正式进度仍以项目记忆库为准） |
| 审批纪律（commit/push、SQL 先确认） | ZCode 权限模式（工具调用按模式请求用户批准；被拒 = 用户否决，调整而非原样重试）；`AskUserQuestion` 用于显式确认 |
| 记忆纪律（memory/ 三件套 + logs） | **项目级落地不变**（memory/ 是项目内唯一出处）；ZCode 会话摘要/压缩是补充而非替代 |
| 工具沉淀（tools/，依赖方向 + 删除演练） | 与平台无关；ZCode 中临时脚本用 `Bash` 写，固化后同样守硬规则 |
| 迭代（「用 new-project-init 迭代」） | 对 ZCode 会话说同样的话 → 加载本 skill → 走「skill 迭代大前提」讨论驱动纪律 |

### 2b. 子代理上下文继承档位（v11.3 新增）

> **关键区别（决定子代理看不看得到 SKILL.md 与 references/ 题库）**：ZCode 的 `Agent` 子代理是**全新会话，不继承父上下文**——只有 prompt 里写进去的内容可见。「跨平台强门禁」对它不天然生效：

| 派发方式 | 上下文继承 | 对门禁/题库的影响 | 需要怎么做 |
|---|---|---|---|
| `Agent`（任意 subagent_type，含后台运行） | **不继承**（全新会话） | 裸子代理看不到 SKILL.md 全文与 references 题库/颗粒度标尺 | 其 prompt（或用 `agents/<role>.md` 作模板）**必须含「入场先 read `references/场景/<场景>-问询.md` 全文（写五件套另加 `references/五件套颗粒度标尺.md`）再执行」**；否则可能凭残缺上下文现编题目 |
| 主代理（本会话，已加载 skill） | 天然带上下文 | 门禁天然覆盖 | 正常执行（强门禁仍要求显式读 references 全文） |
| 会话接续 | 新会话无旧上下文 | 旧会话的 skill 加载状态不延续 | 按 H 组交接纪律：交接文档 + `ReadSessionContext` 按需取 |

**异常提示**：任何 ZCode 子代理执行中发现**没有 SKILL.md 或 references 上下文、流程被精简、题目缺失** → **停下上报父代理或提醒用户**，不凭残缺上下文猜着做（与 SKILL.md「生成期异常处理」/「跨平台强门禁」红线一致）。兜底指令见模板 06「协作协议」。

## 3. 产出物在 ZCode 下的定位

- **入口规范文件（原 CLAUDE.md）**：按 v11.0「平台入口规范文件」节（ISSUE-013），正文唯一名由问询主导平台决定——**ZCode 认 `AGENTS.md`**（每次会话自动注入），ZCode 为主导平台时正文即 `AGENTS.md`，`CLAUDE.md`/`GEMINI.md` 反而作非主导薄入口（一行引用正文）；主导 Claude 时正文 `CLAUDE.md` + 生成 `AGENTS.md` 薄入口（ZCode 自动读到引用行）。
- **agents/<role>.md**：作 `Agent` 子代理 prompt 模板（含 references 必读行，见 2b）。
- **memory/ 与 logs**：与平台无关，按模板原样生成。
- **.gitignore / docs/ / specs/**：纯项目文件，无平台差异。

## 4. 平台差异注意（ZCode vs Claude Code vs DSH/Reasonix）

| 差异 | 说明 |
|---|---|
| 常驻纪律文件 | ZCode **自动注入**项目 `AGENTS.md`（同 Reasonix）；Claude Code 认 CLAUDE.md；DSH 不自动读靠入场核对 |
| 问询工具 | ZCode 有原生 `AskUserQuestion`（结构化选项/推荐/多选）；DSH `ask_user_question`；Reasonix 会话内提问 |
| 斜杠调用 | ZCode `/new-project-init`（同 DSH）；Claude Code 生态靠自然语言触发 |
| 子代理 | ZCode `Agent` 工具（全新会话不继承）；DSH `subagent`/`subagent_fork`；Reasonix `task`/`subagent` |
| 跨会话记忆 | ZCode 有 `ReadSessionContext` 读历史会话（#sess_*）；交接文档仍是项目内权威机制 |

## 5. 安装与发现（ZCode）

> ⚠️ **ZCode 没有「任意路径技能根」配置字段**（对照 Reasonix 的 `[skills] paths`）——技能根是**约定目录**：`.zcode/skills`（ZCode 专属）+ **`.agents/skills`（多工具共享）** + 各工具约定目录（`.claude/skills`、`.codex/skills`…，ZCode 也扫描以发现外部工具的技能）。因此「多工具共享」用 **`~/.agents/skills/`**：junction 指向仓库，内容实体仍只有一份（单一来源）。

**方式一：多工具共享根 junction（推荐，Windows；ZCode 与 Claude/Codex/Cursor 等共享同一份）**

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.agents\skills" -Force | Out-Null
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents\skills\new-project-init" -Target <本仓库路径>
```

（junction 是指针不复制文件，**内容实体仍在仓库**；装完**新开一个 ZCode 会话**确认技能出现在索引、`/new-project-init` 能触发。若同时存在 `~/.zcode/skills/new-project-init`，**`.zcode` 会遮蔽 `.agents`**（同级 .zcode 先扫）——同一技能只保留一处 junction，别两处都放。）

**方式二：ZCode 专属根（仅 ZCode 可见，不推荐给多工具用户）**

放进 `~/.zcode/skills/new-project-init/`（junction 或复制）——只影响 ZCode，其他工具看不到；与方式一互斥（同技能二选一）。

**方式三：项目级（团队共享）**

放进 `<项目>/.zcode/skills/` 或 `<项目>/.agents/skills/`（随仓库分发，仅该项目可见；从当前目录向上逐级生效）。

**方式四：插件清单（实验路径）**

仓库根已含 `.zcode-plugin/plugin.json`（`skills: ["."]`）——可在 ZCode「Settings → Plugin Management → Discover → +」尝试以 **GitHub 仓库/本地目录**添加为插件源安装（ZCode 插件源的 marketplace 清单为 `marketplace.json`，结构 `{plugins:[…]}`）。此路径**未做完整装机实测**，失败请用方式一。插件机制的意义：不依赖约定目录、可把本仓库作为**插件源**分发给他人（与 npm/GitHub 安装同一层级的分发渠道）。

## 6. 受控环境执行已知坑（v11.3，ISSUE-028/030 平台落地）

### 6a. 构建/测试命令被权限模式或沙箱拦截（ISSUE-028）

ZCode 的 Bash 工具跑在权限模式/沙箱之下，「验证 + 写状态」混合型命令（`mvn test`、`npm run build` 等：既产测试报告又验结果）可能被拦或要求批准。**决策路径（不硬编码具体构建工具）**：

1. **先区分两类动作**：写状态准备（构建产物/依赖安装/测试报告落盘）vs 只读验证（读结果文件/报告/日志）；
2. 能拆则拆：先跑写状态准备命令（用户批准一次），再用只读命令读结果（`cat`/`grep` 报告文件）；
3. 拆不开（测试框架写 target 与断言一体）：把**环境变量设置放进子进程**隔离主 shell 状态，如 Windows 下 `cmd /c "set JAVA_HOME=D:\path\&&mvn -o test"`（整个命令一次工具调用内完成）——Reasonix 实测同型拦截以此绕过（见 `platforms/reasonix/adaptation.md` 已知坑节）；
4. 仍被拦：**停下向用户说明**（哪条命令、为什么需要写权限、影响哪个目录），获批准后再执行——不反复原样重试（被拒 = 用户否决）。

### 6b. Edit 精确替换遇「多处相同文本」（ISSUE-030）

ZCode 的 `Edit` 工具**强制 old_string 全局唯一**，不唯一即报错（实测确认）。复制粘贴型重复代码（分支菜单、switch-case 同款 case、枚举项）天然多处相同：

1. 命中 not unique 报错 → **扩大 old_string 到该处独有的相邻上下文**（函数边界/分支判断行/文件头声明），直到唯一命中；**禁止碰运气的短锚**（误改错处比报错更糟——静默改错位置高发于同构文件）；
2. 多处都要改同款文本：逐处分别用各自上下文锚编辑；或先在源分支改好再整体复制；
3. 锚定失效（文件刚被外部改动）：先 `Read` 刷新文件状态再编辑（ZCode 要求编辑前已 Read，行号/内容以最新读取为准）。

## 7. 维护说明

- 本文件只**增加**指引，不复制任何规则（唯一出处原则：规则仍只在 SKILL.md 与模板中定义）。
- 改本文件 → 按 SKILL.md「逐文件三要素」在 SKILL.md 版本表 + docs/CREATION-LOG.md 追加变更记录行；本文件自身变更记录区为**头部头插**（纯 AI 看）。
- 按 AGENTS.md 三判据：ZCode 平台机制变化（技能发现根/工具集调整影响已登记映射）→ 回 ZCode 环境复核并同步本文件。
