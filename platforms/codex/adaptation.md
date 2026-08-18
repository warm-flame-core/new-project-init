# new-project-init · Codex 适配说明

> 📍 变更记录（纯 AI 看，头插）：
> `2026-08-18 | 新增：Codex 适配说明（v11.1） | Codex 适配（agent）`

> 本文件是 SKILL.md「平台适配」节的展开。**只提供「在 Codex 中怎么落地」的指引，不改变 skill 的任何规则/模板/产出物**；在其他平台（Reasonix、DSH、Claude Code 等）运行时忽略本文件，照常执行 SKILL.md 原流程。

## 1. 加载与调用（Codex）

- **技能格式**：与 Reasonix/DSH/Claude Code 相同——`SKILL.md` + YAML frontmatter（`name` 必须 kebab-case、`description` 必填）。本 skill 的 frontmatter 直接兼容，无需改动。
- **技能根（按优先级）**：
  - 全局：`~/.codex/skills/`（默认，可通过环境变量 `CODEX_HOME` 覆盖）
  - 自定义：`/skills\`（本机配置的全局记忆目录）
  - 项目级：`<项目根>/.codex/skills/`（工作区 skill，豁免全局记忆）
- **验证**：在 Codex 会话中，skill 会根据 `description` 自动路由；用户说「用 new-project-init …」或任务匹配 description → Codex 加载并执行本 skill。
- **调用**：用户显式调用时，直接说「用 new-project-init 初始化项目」或「用 new-project-init 迭代」即可。
- **常驻纪律**：Codex 使用项目根 `AGENTS.md`（或 `CLAUDE.md`）承载常驻纪律——把本 skill 的「记忆库写入纪律/入场核对」要点抄进项目的入口规范文件即可与 Codex 工作流融合。

## 2. 能力映射表（skill 概念 → Codex 工具）

| skill 概念 | Codex 落地 |
|---|---|
| 多 agent 角色（Planner/Developer/Reviewer/Tester，`agents/<role>.md`） | Codex 原生多 agent 工具 `_iv9s__multi_agent_v1__spawn_agent`（派发子代理）/ `_iv9s__multi_agent_v1__send_input`（发送消息）/ `_iv9s__multi_agent_v1__wait_agent`（等待结果）；`agents/<role>.md` 直接作子代理 prompt 模板 |
| 大规模并行 / 多阶段协作 | `spawn_agent` + `wait_agent` 组合（Codex 把它们做成原生工具） |
| 问询（🔴 一次一个 / 🟡 批量） | `request_user_input` 工具（支持结构化问题、选项）；🔴 关键题单独问，🟡 批量题可合并为一次多选 |
| 命令实测（构建/测试，禁止猜） | `shell_command` 工具（支持 PowerShell/cmd）；强制规则「实测不猜」不变 |
| 代码库探索（入场核对/现状盘点） | `shell_command` + `Get-ChildItem`/`Select-String` 等 PowerShell 命令 |
| 文件系统 | `shell_command`（读/写/编辑）；注意 Codex 的 sandbox 权限模式（`sandbox_permissions`） |
| 记忆纪律（memory/ 三件套 + logs） | **项目级落地不变**（memory/ 是项目内唯一出处）；Codex 的会话持久化是补充而非替代 |
| 会话上下文管理（H 组问询） | 交接文档（memory/handoff/）仍是项目内机制；Codex 侧再叠加其会话保存/恢复 |
| 工具沉淀（tools/，依赖方向 + 删除演练） | 与平台无关；Codex 中临时脚本用 `shell_command` 写，固化进 `tools/` 后同样遵守「项目 → 工具禁止引用」「删除演练」硬规则 |
| 审批纪律（commit/push、SQL 先确认） | 与 Codex 的 `sandbox_permissions` 机制对齐（`require_escalated` 需用户确认） |
| 迭代（「用 new-project-init 迭代」） | 对 Codex 会话说同样的话 → 加载本 skill → 走「skill 迭代大前提」讨论驱动纪律 |

### 2b. 子代理上下文继承档位（v11.0 新增）

> **关键区别（决定子代理看不看得到 SKILL.md 与 references/场景/ 题库）**：Codex 的子代理通过 `spawn_agent` 派发，**上下文继承取决于 `fork_context` 参数**——它直接决定「跨平台强门禁」是否天然覆盖该子代理：

| 派发方式 | 上下文继承 | 对门禁/题库的影响 | 需要怎么做 |
|---|---|---|---|
| `spawn_agent`（`fork_context: false`） | **独立会话，不继承父上下文** | 裸子代理看不到 SKILL.md 全文与 references/场景/ 题库 | 其 prompt（或用 `agents/<role>.md` 作模板）**必须含「入场先 read `references/场景/<全新\|中途\|存量>-问询.md` 全文再执行」**；否则可能凭残缺上下文现编题目 |
| `spawn_agent`（`fork_context: true`） | **继承父上下文** | 门禁天然覆盖 | 正常执行 |
| 常驻主代理 / 会话续接 | 带完整上下文 | 门禁天然覆盖 | 正常执行 |

**异常提示（v11.0）**：任何 Codex 子代理在执行中发现自己**没有 SKILL.md 或 references 上下文、流程被精简、题目缺失** → **停下上报父代理或提醒用户**，不凭残缺上下文猜着做（与 SKILL.md「生成期异常处理」/「跨平台强门禁」红线一致）。兜底指令见模板 06「协作协议」；`agents/<role>.md` 作模板时，团队要确保其含 references 必读行。

## 3. 产出物在 Codex 下的定位

- **入口规范文件（原 CLAUDE.md）**：默认**保持原名 CLAUDE.md**（跨平台约定）。Codex 会自动读取项目根的 `CLAUDE.md` 或 `AGENTS.md`。若用户选 **Codex 为主导平台**，则按 v11.0「平台入口规范文件」节（ISSUE-013）**正文唯一名为 `AGENTS.md`**，CLAUDE.md 反而作非主导薄入口（一行引用正文）。
- **agents/<role>.md**：可直接作 `spawn_agent` 的 prompt 输入（见映射表）。
- **memory/ 与 logs**：与平台无关，按模板原样生成。
- **.gitignore / docs/ / specs/**：纯项目文件，无平台差异。

## 4. 平台差异注意（Codex vs Reasonix vs DSH vs Claude Code）

| 差异 | 说明 |
|---|---|
| 常驻纪律文件 | Claude Code/Reasonix 认 `AGENTS.md`；DSH 不自动读，靠 preset/入场核对；Codex 认 `CLAUDE.md` 或 `AGENTS.md`。本 skill 产出 CLAUDE.md 保持原名，各平台按需引用 |
| 多 agent 落地 | Reasonix 原生 `task`/`review`/`wait`/`explore`；DSH 用 `subagent`/`workflow`；Codex 用 `spawn_agent`/`send_input`/`wait_agent` |
| 技能命名 | Reasonix/DSH 用裸名；Claude Code 生态常见 `superpowers-*` 前缀；Codex 用裸名 |
| 用户显式调用 | Reasonix/DSH 无 Claude 式技能命令，靠「用 new-project-init …」触发；Codex 同理 |
| 权限模型 | DSH 用 `workspace-write` + `approval: ask`；Codex 用 `sandbox_permissions`（`use_default` / `require_escalated`） |

## 5. 安装与发现（Codex）

### 方式一：Junction链接（推荐，保持单一来源）

创建Junction链接（Windows，不需要管理员权限）：

```powershell
# 创建Junction链接
New-Item -ItemType Junction -Path "$CODEX_HOME/skills/new-project-init" -Target "/path/to/new-project-init"
```

> **优点**：改动自动同步，无需手动复制；不占用额外磁盘空间。

### 方式二：复制（简单但需手动同步）

复制skill到Codex技能目录：

```powershell
# 复制skill
Copy-Item -Path "/path/to/new-project-init" -Destination "$CODEX_HOME/skills/new-project-init" -Recurse
```

> **注意**：后续迭代需要手动同步，建议使用Junction链接。

### 方式三：配置指向（高级）

在Codex全局配置（`$CODEX_HOME/config.toml`）里添加：

```toml
[skills]
paths = ["/path/to/new-project-init"]
```

> **注**：需确认Codex是否支持`[skills]`配置节；若不支持，使用环境变量方案。

### 方式四：项目级（工作区豁免）

把仓库复制/链接到`<项目>/.codex/skills/`（仅该项目可见，豁免全局记忆）。

**验证**：在Codex会话中，skill会根据`description`自动路由；用户说「用 new-project-init …」即可触发。

## 6. 维护说明

- 本文件只**增加**指引，不复制任何规则（唯一出处原则：规则仍只在 SKILL.md 与模板中定义）。
- 改本文件 → 按 SKILL.md「逐文件三要素」在 SKILL.md 版本表 + docs/CREATION-LOG.md 追加变更记录行；本文件自身变更记录区为**头部头插**（纯 AI 看）。



