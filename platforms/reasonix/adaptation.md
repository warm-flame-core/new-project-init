# new-project-init · Reasonix 适配说明

> 📍 变更记录（纯 AI 看，头插）：
> `2026-08-17 | 新增 2b「子代理上下文继承档位（v11.0）」：task/subagent（独立会话不继承）、subagent create+profile（模板即 prompt）、review/explore/research（父驱动）、常驻主代理/-c --resume（带上下文）；说明各档对「跨平台强门禁 + references 题库可见性」的影响与所需动作；新增「异常提示」段（流程被精简/题目缺失 → 停下上报父代理或提醒用户）；产出物定位补齐平台入口映射协调（Reasonix 为主导平台时正文名为 AGENTS.md，CLAUDE.md 转薄入口） | Reasonix（skill 迭代）`
> `2026-08-16 | 新增：Reasonix 适配说明（v10.9） | DSH 适配（agent）`

> 本文件是 SKILL.md「平台适配」节的展开。**只提供「在 Reasonix 中怎么落地」的指引，不改变 skill 的任何规则/模板/产出物**；在 DSH、Claude Code、或其他支持技能机制的 agent 中运行时忽略本文件，照常执行 SKILL.md 原流程。

## 1. 加载与调用（Reasonix）

- **技能格式**：与 DSH/Claude Code 相同——`SKILL.md` + YAML frontmatter（`name` 必须 kebab-case、`description` 必填）。本 skill 的 frontmatter 直接兼容，无需改动。
- **技能根（按优先级）**：
  - 全局：`~/.reasonix/skills/`（可用环境变量 `REASONIX_SKILLS_DIR` 覆盖）
  - 项目：`<项目根>/.reasonix/skills/`
  - 兼容项目根：`.claude/skills/`、`.agents/skills/`、`.agent/skills/`（Reasonix 也会扫描）
  - 配置指向：`reasonix.toml`（本机为 `%APPDATA%\reasonix\config.toml`，`reasonix setup` 会生成）里写 `[skills] paths = ["/绝对路径"]`
- **验证**：会话内 `/skill paths` 看是否识别该根；`/skills` 看发现的技能列表。有 `description` 的技能会出现在系统提示的固定技能索引里。
- **调用**：用户说「用 new-project-init …」→ Reasonix agent 加载并执行本 skill；Reasonix 的技能命名空间是裸名（与 DSH 一致），无需 `superpowers-` 之类前缀。
- **常驻纪律**：Reasonix 用项目根 `AGENTS.md` 承载「动手前先加载技能」的常驻纪律（`reasonix init` 会说明如何生成）——把本 skill 的「记忆库写入纪律/入场核对」要点抄进项目的 `AGENTS.md` 即可与 Reasonix 工作流融合。

## 2. 能力映射表（skill 概念 → Reasonix 工具）

| skill 概念 | Reasonix 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester，`agents/<role>.md`） | Reasonix 原生工具 `task`（派发子任务）/ `review`（代码审查）/ `wait`（等待并行任务）；`reasonix subagent list/create` 管理子代理 profile，`agents/<role>.md` 直接作子代理 prompt 模板 |
| 大规模并行 / 多阶段协作 | `task` + `wait` 组合（Reasonix 把它们做成原生工具而非独立 workflow） |
| 问询（🔴 一次一个 / 🟡 批量） | Reasonix 会话内提问；🔴 关键题单独问，🟡 批量题合并列出 |
| 命令实测（构建/测试，禁止猜） | Reasonix 的 bash/shell 执行（`reasonix run`/会话内命令）；强制规则「实测不猜」不变 |
| 代码库探索（入场核对/现状盘点） | 原生 `explore` 工具 |
| 文件系统 | Reasonix 自带读写/编辑工具；注意其权限模式（`--permission-mode`） |
| 记忆纪律（memory/ 三件套 + logs） | **项目级落地不变**（memory/ 是项目内唯一出处）；Reasonix 的 `AGENTS.md`（项目记忆）+ 会话持久化是补充而非替代 |
| 会话上下文管理（H 组问询） | 交接文档（memory/handoff/）仍是项目内机制；Reasonix 侧再叠加其会话保存/恢复（`-c/--continue`、`-r/--resume`） |
| 工具沉淀（tools/，依赖方向 + 删除演练） | 与平台无关；Reasonix 中临时脚本同样遵守「项目 → 工具禁止引用」「删除演练」硬规则 |
| 审批纪律（commit/push、SQL 先确认） | 与 Reasonix 的权限/确认机制对齐（默认需用户确认时照常停下问） |
| 迭代（「用 new-project-init 迭代」） | 对 Reasonix 会话说同样的话 → 加载本 skill → 走「skill 迭代大前提」讨论驱动纪律 |

### 2b. 子代理上下文继承档位（v11.0 新增）

> **关键区别（决定子代理看不看得到 SKILL.md 与 references/场景/ 题库）**：Reasonix 有独立会话子代理（`task`/`subagent`）与父驱动只读子代理（`review`/`explore`/`research`）两类，**上下文继承与否不同**——它直接决定「跨平台强门禁」是否天然覆盖该子代理：

| 派发方式 | 上下文继承 | 对门禁/题库的影响 | 需要怎么做 |
|---|---|---|---|
| `task`（原生子任务/子代理） | **独立会话，不继承父上下文** | 裸子代理看不到 SKILL.md 全文与 references/场景/ 题库 | 其 prompt（或用 `agents/<role>.md` 作 profile）**必须含「入场先 read `references/场景/<全新\|中途\|存量>-问询.md` 全文再执行」**；否则可能凭残缺上下文现编题目 |
| `subagent create` + profile | profile 即 prompt 模板 | `agents/<role>.md` 作 profile 时，模板若含 references 必读行则可见 | 团队要确保 role 模板含 references 必读（见模板 06 兜底指令） |
| `review`（代码审查） | 父驱动（review 基于 diff/仓库） | 由父代理喂入上下文；父已读 SKILL.md 则门禁生效 | 审查前仍应先读 references 对应场景做核对（观照门禁） |
| `explore`（只读代码探索）/ `research`（web+code 只读） | 父驱动子代理 | 上下文由父代理传入 | 派发时在 prompt 里显式「先读 references 对应文件全文」再执行 |
| 常驻主代理 / `-c`/`--resume` 接续会话 | 带完整上下文 | 门禁天然覆盖 | 正常执行 |

**异常提示（v11.0）**：任何 Reasonix 子代理/子任务在执行中发现自己**没有 SKILL.md 或 references 上下文、流程被精简、题目缺失** → **停下上报父代理或提醒用户**，不凭残缺上下文猜着做（与 SKILL.md「生成期异常处理」/「跨平台强门禁」红线一致）。兜底指令见模板 06「协作协议」；`agents/<role>.md` 作 profile 时，团队要确保其含 references 必读行。

## 3. 产出物在 Reasonix 下的定位

- **入口规范文件（原 CLAUDE.md）**：默认**保持原名 CLAUDE.md**（跨平台约定）。Reasonix 的常驻纪律文件是 **`AGENTS.md`**——生成时可提示用户：把入口规范文件的核心纪律（工作流/记忆纪律/入场核对）摘要进项目 `AGENTS.md`，Reasonix 每次会话都会读到；CLAUDE.md 仍作完整规范宪法。若用户选 **Reasonix 为主导平台**，则按 v11.0「平台入口规范文件」节（ISSUE-013）**正文唯一名为 `AGENTS.md`**，CLAUDE.md 反而作非主导薄入口（一行引用正文）。
- **agents/<role>.md**：可直接作 `reasonix subagent create` 的 profile 输入（见映射表）。
- **memory/ 与 logs**：与平台无关，按模板原样生成。
- **.gitignore / docs/ / specs/**：纯项目文件，无平台差异。

## 4. 平台差异注意（Reasonix vs DSH vs Claude Code）

| 差异 | 说明 |
|---|---|
| 常驻纪律文件 | Claude Code/Reasonix 认 `AGENTS.md`；DSH 不自动读，靠 preset/入场核对。本 skill 产出 CLAUDE.md 保持原名，各平台按需引用 |
| 多 agent 落地 | Reasonix 原生 `task`/`review`/`wait`/`explore`；DSH 用 `subagent`/`workflow`；Claude Code 靠 agents/ 约定 |
| 技能命名 | Reasonix/DSH 用裸名；Claude Code 生态常见 `superpowers-*` 前缀（非必须） |
| 用户显式调用 | Reasonix/DSH 无 Claude 式技能命令，靠「用 new-project-init …」触发 |

## 5. 安装与发现（Reasonix）

**方式一：配置指向（推荐，保持单一来源，零 C 盘占用）**

在 Reasonix 全局配置（本机 `%APPDATA%\reasonix\config.toml`，用 `reasonix setup` 生成或手写）里加：

```toml
[skills]
paths = ["F:/Software/deepseek-harness/Skill/new-project-init"]
```

**方式二：junction 进全局技能根（推荐给 Windows）**

```powershell
mkdir C:\Users\MSI\.reasonix\skills -Force
New-Item -ItemType Junction -Path C:\Users\MSI\.reasonix\skills\new-project-init -Target F:\Software\deepseek-harness\Skill\new-project-init
```

（junction 是指针，不复制文件——C 盘零字节占用。）

**方式三：放进项目**

把仓库复制/链接到 `<项目>/.reasonix/skills/`（或 `<项目>/.claude/skills/` 等兼容根）。

**验证**：`reasonix doctor` 无技能加载错误；会话内 `/skill paths` + `/skills` 确认发现。

## 6. 社区发布（reasonix.io/skills）

- 网页：**https://reasonix.io/skills/** → 点 **Publish（发布）** 按钮
- 表单 `source` 填：GitHub 仓库 URL `https://github.com/warm-flame-core/new-project-init`（或 SKILL.md 直链 `https://raw.githubusercontent.com/warm-flame-core/new-project-init/main/SKILL.md`）
- 表单 `repoUrl` 填：`https://github.com/warm-flame-core/new-project-init`
- 需要 Reasonix 账号登录（已在 https://reasonix.io 注册）
- 提示语确认的是「指向含 `reasonix-plugin.json` / `.codex-plugin` / `.claude-plugin` 的仓库或 SKILL.md 路径」——本仓库是单技能仓库（根目录 SKILL.md），两种填法均可尝试，若表单要求插件清单结构再按页面提示调整

## 7. 维护说明

- 本文件只**增加**指引，不复制任何规则（唯一出处原则：规则仍只在 SKILL.md 与模板中定义）。
- 改本文件 → 按 SKILL.md「逐文件三要素」在 SKILL.md 版本表 + docs/CREATION-LOG.md 追加变更记录行；本文件自身变更记录区为**头部头插**（纯 AI 看）。
