# new-project-init · DSH（DeepSeek Harness）适配说明

> 📍 变更记录（纯 AI 看，头插）：
> `2026-08-16 | 新增：插件安装方式（npm/GitHub/本地文件夹，v10.8 打包为 DSH 插件包） | DSH 适配（agent）`
> `2026-08-16 | 新增：DSH 适配说明（v10.7） | DSH 适配（agent）`

> 本文件是 SKILL.md「平台适配」节的展开。**只提供「在 DSH 中怎么落地」的指引，不改变 skill 的任何规则/模板/产出物**；在其他平台（Claude Code 等）运行时忽略本文件，照常执行 SKILL.md 原流程。

## 1. 加载与调用（DSH）

- **目录路由**：DSH 在每个 agent 步骤前渲染技能目录（`name` + 截断到 500 字符的 `description`）。本 skill 的 frontmatter `description` 已是纯触发条件，无需改动。
- **模型调用**：用户说「用 new-project-init …」或任务匹配 description → agent 调 `skill` 工具（参数 `name: new-project-init`）。
- **用户显式调用**：用户在输入框直接输入 `/new-project-init`，DSH 会把本 skill 正文作为指令注入（`user-invocable` 默认开启）。
- **资源解析**：加载后 `resourceBase` = 技能所在目录；SKILL.md 里所有相对引用（`templates/`、`testing/`、`references/`）都相对该目录解析，按需读取。

## 2. 能力映射表（skill 概念 → DSH 工具/机制）

| skill 概念 | DSH 落地 |
|---|---|
| 问询（🔴 一次一个 / 🟡 批量） | `ask_user_question` 一次一问；🔴 关键题单独问，🟡 批量题可合并为一次多选 |
| 多 agent 角色（Planner/Developer/Reviewer/Tester，`agents/<role>.md`） | `subagent`（后台派发）/ `subagent_fork`（继承本会话上下文）；`agents/<role>.md` 直接作为子代理 prompt 模板（职责/输出物/检查清单原样可用） |
| 大规模并行 / 多阶段协作（多模块同时推进） | `workflow` 工具（脚本扇出到多个子代理，分阶段收集结构化结果） |
| 长周期连续目标（如「把整套文档体系补齐」） | `goal` 工具（跨轮次持续推进同一目标） |
| 命令实测（构建/测试/运行，强制「不猜」） | `pwsh`（Windows，如 `mvn compile`、`npm run build`）；非 Windows 用 `tool-bash` |
| 文件系统（读/写/编辑/检索） | `read` / `write` / `edit` / `glob` / `grep`（注意 DSH 的 fs-observation-policy：编辑前先读） |
| 文件沙箱与审批 | DSH 默认 `workspace-write` + `approval: ask`；workspace 外的写操作会请求授权——与 skill「commit/push 需允许」「SQL 先展示确认」纪律天然一致 |
| 记忆纪律（memory/ 三件套 + logs） | **项目级落地不变**（memory/ 是项目内唯一出处）；DSH 会话本身持久化、`goal` 记录目标，是补充而非替代 |
| 会话上下文管理（H 组问询：交接文档/压缩） | 交接文档（memory/handoff/）仍是项目内机制；DSH 侧再叠加会话自身的持久化/压缩，产出的交接文档对两者都适用 |
| 工具沉淀（tools/，依赖方向 + 删除演练） | 与平台无关；DSH 中临时脚本用 `pwsh` 写，固化进 `tools/` 后同样遵守「项目 → 工具禁止引用」「删除演练」硬规则 |
| 入场核对（git status + diff --stat） | DSH 用 `pwsh` 跑 git；新会话入场时先读 CLAUDE.md + memory 三件套再核对 git |
| 迭代（「用 new-project-init 迭代」） | 对 DSH 会话说同样的话 → agent 用 `skill` 工具加载 → 走「skill 迭代大前提」讨论驱动纪律 |

## 3. 产出物在 DSH 下的定位

- **CLAUDE.md**：默认**保持原名**——它是跨平台约定（Claude Code/Cursor 等都会读），DSH agent 在入场核对时用 `read` 按需读取，定位不变（项目规范宪法，人+AI 双受众）。纯 DSH 项目若想改名，可在生成时与用户确认改叫 `AGENTS.md`（同为通用约定）——不改默认。
- **agents/<role>.md**：除项目内角色职责外，可直接作 DSH `subagent` 的 prompt 模板（见映射表）。
- **memory/ 与 logs**：与平台无关，按模板原样生成。
- **.gitignore / docs/ / specs/**：纯项目文件，无平台差异。

## 4. 平台差异注意（DSH vs Claude Code）

| 差异 | 说明 |
|---|---|
| CLAUDE.md 自动加载 | Claude Code 会自动读取；**DSH 不会**——agent 必须按「入场核对」主动 `read`（skill 的入场纪律正好覆盖这一点） |
| 多 agent 角色 | Claude Code 靠 agents/ 约定；DSH 用 `subagent`/`workflow` 原生实现，`agents/<role>.md` 作 prompt 模板 |
| 技能目录描述 | DSH 目录描述截断到 500 字符（本 skill description 远低于该值，无影响） |
| 用户显式调用 | DSH 支持 `/new-project-init`；Claude Code 无此机制（说「用 new-project-init …」即可） |

## 5. 安装与发现（DSH）

skill 目录 = `<root>/new-project-init/`（含 SKILL.md + templates/ + testing/ + references/）。DSH 的 filesystem skill 提供方按优先级扫描这些根（每级一个 `<name>/SKILL.md` 或 `<name>.md`）：

**插件安装（v10.8 起，本仓库同时是 DSH 插件包 `new-project-init`，`dsh.bundle` 自动注册技能 provider）**：

```sh
dsh plugin --profile web add new-project-init                    # npm 包（发布后）
dsh plugin --profile web add github:warm-flame-core/new-project-init   # 或 GitHub
dsh plugin --profile web add <仓库路径>                            # 或本地文件夹
```

插件安装走 host 层 provider（rank 550），装完重启 profile 即可在技能目录出现，无需任何配置；与下方本地文件安装可并存（同名时 rank 更低者胜，本地 400/500 优先于插件 550）。

**本地文件安装（filesystem provider 的发现根）**：

| 优先级 | 根 | 说明 |
|---|---|---|
| 100 | `<项目根>/.dsh/skills` | 项目级（随仓库走） |
| 200 | `<项目根>/.agents/skills` | 项目级 |
| 300 | `customSkillDirs`（配置） | 见下 |
| 400 | `$DSH_HOME/skills`（默认 `C:\Users\MSI\.dsh\skills`） | **用户级，所有 profile/会话可见（推荐）** |
| 500 | `$DSH_AGENTS_HOME/skills` | 兼容级 |

**Web/桌面界面的注意**：GUI 的 skill 由 **agent preset** 层的 `skill-filesystem` 行提供（宿主行被 `dsh-web-app` 禁用），`standard` 等 preset 默认 `includeDefaultRoots: true` → 上表 100/200/300/400/500 全部生效。因此：

- **最简安装（推荐）**：把本 skill 放进 `$DSH_HOME/skills/`（复制或 **junction 指向仓库**均可）——所有 profile、所有 preset、所有会话可见，无需改任何配置，仓库保持单一来源。
- **项目级**：放进项目 `.dsh/skills/`（随仓库分发）。
- **customSkillDirs（配置指向仓库）**：在 `$DSH_HOME/cordis.patch.yml`（对所有 profile 生效、HMR 热重载）加：

```yaml
- id: skill-filesystem
  config:
    customSkillDirs:
      - 'F:/Software/deepseek-harness/Skill'
```

> 注：该宿主层行在 Web/桌面 profile 被禁用（preset 层接管），因此 customSkillDirs 主要对 TUI/headless 等 profile 生效；GUI 请用 `$DSH_HOME/skills` 方案。两者可并存，互不冲突。

- **验证**：`dsh --profile <name> --dump-config` 应看到 `skill-filesystem` 行的 `customSkillDirs`；技能目录在会话首个步骤渲染（新会话必见；运行中的会话由 watcher 轮询补发现，缺失根每 100ms 探测一段路径）。

## 6. 维护说明

- 本文件只**增加**指引，不复制任何规则（唯一出处原则：规则仍只在 SKILL.md 与模板中定义）。
- 改本文件 → 按 SKILL.md「逐文件三要素」在 SKILL.md 版本表 + docs/CREATION-LOG.md 追加变更记录行；本文件自身变更记录区为**头部头插**（纯 AI 看）。
