# new-project-init · WorkBuddy 适配说明

> 📍 变更记录（纯 AI 看，头插）：
> `2026-09-30 | 新增：WorkBuddy 适配说明（v11.4）——来源：本机安装目录（WorkBuddy 5.6.2）的 product.json / install-manifest.json / 用户目录实测 + app.asar 字符串探测。**按三判据②属「新增平台适配」，本文件逐项标注实测状态，会话级实测（第 6 节清单）跑完并回填后才算转正** | warm-flame-core-DSH-Developer@main`

> 本文件是 SKILL.md「平台适配」节的展开。**只提供「在 WorkBuddy 中怎么落地」的指引，不改变 skill 的任何规则/模板/产出物**；在其他平台（Claude Code / DSH / Reasonix / ZCode 等）运行时忽略本文件，照常执行 SKILL.md 原流程。

> ⚠️ **实测状态约定**：**【实测】**= 本机文件/字符串级已验证；**【推断】**= 依据 product.json 能力位与同源技能格式推定，未见明文文档；**【待实测】**= 必须在本平台会话里跑一次才能确认。**本平台适配尚未完成会话级实测（三判据②未过）**——使用前请先跑第 6 节「待实测清单」。

## 1. 加载与调用（WorkBuddy）

- **技能格式**【实测】：与 Claude Code 系一致——目录 + `SKILL.md`（YAML frontmatter），重内容外置 `references/`。本机内置技能即此结构：`<安装目录>\resources\app.asar.unpacked\resources\plugins\workbuddy-builtin\builtin-plugins\<插件>\skills\<技能>\SKILL.md`（同目录带 `references/`）。
- **技能根**：
  - 用户级【实测】：`~/.workbuddy/skills/`（本机已存在，且已装多个技能）
  - 项目级【实测】：`<repo>/.workbuddy/skills/`——本机 `~/.workbuddy/skills/blog-writer` 是指向 `F:\Code\blog\.workbuddy\skills\blog-writer` 的 Junction，反证项目级根存在
- **调用**【推断】：`Skill` 工具（product.json 工具表含 `Skill`；`SkillManage` 能力位为关）→ 用户说「用 new-project-init …」由模型调用。
- **常驻纪律文件**【实测 + 推断】：`app.asar` 内含 `AGENTS.md` 字符串，**不含** `CLAUDE.md` / `GEMINI.md` / `WORKBUDDY.md` → 本平台认 **`AGENTS.md`**（与 Reasonix / ZCode / DSH 同源约定）。**自动注入时机、是否读嵌套 `AGENTS.md` 属【待实测】**。
- **字数上限**【待实测】：未找到公开数值与源码证据 → **统一按 SKILL.md「入口规范文件」的预算执行（≤8 KB）**，留足余量。

## 2. 能力映射表（skill 概念 → WorkBuddy 工具）

| skill 概念 | WorkBuddy 落地 |
|---|---|
| 问询（🔴 一次一个 / 🟡 批量） | `AskUserQuestion`（结构化选择）；另有 `AskUserForStructuredInput`　【实测：工具表】 |
| 多 agent 角色（Planner/Developer/Reviewer/Tester，`agents/<role>.md`） | `Agent` 工具派子代理；内置子代理 `code-explorer`（文件检索专用：`search_file` / `search_content` / `read_file` / `list_files`）；`agents/<role>.md` 作 prompt 模板 |
| 大规模并行 / 多阶段协作 | `Workflow` 工具（Skill 目录内含 `workflow-tool-description`，与 DSH 的 workflow 同型：`agent()` + 阶段 + schema） |
| 命令实测（构建/测试，禁止猜） | `Bash` / `PowerShell` 双工具（Windows 下用 `PowerShell`） |
| 文件系统（读/写/编辑/检索） | `Read` / `Write` / `Edit` / `Glob` / `Grep`（`Edit` 同为精确替换语义） |
| 规划 / 迭代讨论 | `EnterPlanMode` / `ExitPlanMode` |
| 待办 / 进度 | `TaskCreate` / `TaskGet` / `TaskUpdate` / `TaskList` |
| 会话上下文管理（H 组问询 / 交接） | `SendMessage` / `SendUserMessage` / `TeamCreate` 多代理协作；项目内 `memory/handoff/` 仍是唯一出处 |
| 记忆纪律（memory/ 三件套 + logs） | **项目级落地不变**；product.json 有 `MemoryManagement: true`，属平台侧补充而非替代 |
| 并行工作区隔离（模板 30） | `EnterWorktree` / `LeaveWorktree` 与「git worktrees 规范」对应 |
| 技能自管理 | `SkillManage` 关、`DisableCloudSkillSync: true`（product.json）→ 技能以**本地目录**为准，不走云端同步 |
| 迭代（「用 new-project-init 迭代」） | 对 WorkBuddy 会话说同样的话 → 加载本 skill → 走「skill 迭代大前提」讨论驱动纪律 |

### 2b. 子代理上下文继承档位

> 内置 `code-explorer` 子代理的用途说明明写「Searches done via the subagent do not enter main-agent context」——子代理**独立上下文**【实测：builtInSubagents 的 systemPrompt】。

| 派发方式 | 上下文继承 | 对门禁/题库的影响 | 需要怎么做 |
|---|---|---|---|
| `Agent` 子代理 | 【推断】**不继承**（与 Claude Code 系 `Task` 同型） | 裸子代理看不到 SKILL.md 全文与 references 题库 | prompt（或用 `agents/<role>.md` 作模板）**必须含「入场先 read `references/场景/<场景>-问询.md` 全文（写五件套另加 `references/五件套颗粒度标尺.md`）再执行」** |
| `Workflow` 的 `agent()` | 【推断】与 DSH 同型（独立子代理） | 同上 | 脚本里**每个** `agent()` 的 prompt 都必须自带 references 必读行 |
| 主代理（本会话） | 天然带上下文 | 门禁天然覆盖 | 正常执行（强门禁仍要求显式读 references 全文） |

**异常提示**：任何子代理/工作流执行中发现**没有 SKILL.md 或 references 上下文、流程被精简、题目缺失** → **停下上报父代理或提醒用户**，不凭残缺上下文猜着做（与 SKILL.md「生成期异常处理」/「跨平台强门禁」红线一致）。兜底指令见模板 06「协作协议」。

## 3. 产出物在 WorkBuddy 下的定位

- **入口规范文件（原 CLAUDE.md）**：WorkBuddy 认 **`AGENTS.md`**【实测：asar 字符串探测】→ 主导平台为 WorkBuddy 时，正文唯一名取 `AGENTS.md`；其他平台各生成薄入口（见 SKILL.md「平台入口规范文件」节）。
- **agents/<role>.md**：作 `Agent` 子代理的 prompt 模板（含 references 必读行，见 2b）。
- **memory/ 与 logs**：与平台无关，按模板原样生成。
- **.gitignore / docs/ / specs/**：纯项目文件，无平台差异。

## 4. 平台差异注意

| 差异 | 说明 |
|---|---|
| 血统 | product.json 内置市场指向 `download.codebuddy.cn`，工具表与 frontmatter 迁移文件与 Claude Code 系高度同形 →【推断】WorkBuddy 与腾讯 CodeBuddy 同生态 |
| 技能 frontmatter 扩展 | 用户技能目录存在迁移文件 `_bm_skillid_migration.json`、`.disable_to_model_invocation_migration.json`、`.model_invocation_to_override_migration.json`【实测】→【推断】支持 `disable-model-invocation` 等调用开关，并另有「模型调用覆盖」机制（语义【待实测】） |
| 数据目录 | `~/.workbuddy`（product.json `dataFolderName: ".workbuddy"`）；应用配置另在 `%APPDATA%\WorkBuddy` |
| 沙箱 / 审批 | product.json 有 `Sandbox: true` 能力位；具体策略与批准粒度【待实测】 |
| 与 Claude Code 的差异 | WorkBuddy **不认** `CLAUDE.md`（asar 无该字符串）——多平台共用时，`CLAUDE.md` 只是给 Claude Code 的薄入口 |

## 5. 安装与发现（WorkBuddy）

【实测】用户级技能根：`~/.workbuddy/skills/`。最简安装 = **junction 指向本仓库**（与 DSH / ZCode 同法，保持单一来源）：

```powershell
# Windows；junction 不需要管理员权限
cmd /c mklink /J "%USERPROFILE%\.workbuddy\skills\new-project-init" "F:\path\to\new-project-init"
```

项目级（团队随仓库共享）：`<repo>\.workbuddy\skills\new-project-init`。

> 【待实测】是否需要重启 App、运行中是否热发现、是否有插件/市场安装渠道（product.json 有 `builtInMarketplaces`，但**第三方技能上架渠道未确认**）。

## 6. 待实测清单（三判据②；跑完请把结论回填本文件并去掉对应【待实测】标记）

1. junction 安装后，**新开会话**能否在技能列表 / `Skill` 工具里看到 `new-project-init`？
2. `SKILL.md` 的 frontmatter（`name` / `description` / `whenToUse`）是否被正确读取？描述是否截断、截断到多少字符？
3. 项目根 `AGENTS.md` 是否**每次会话自动注入**？子目录嵌套 `AGENTS.md` 是否加载？
4. `AGENTS.md` 的注入预算上限是多少（逐步加大文件，观察是否出现截断 / 省略提示）？
5. 是否存在用户级指令文件（如 `~/.workbuddy/AGENTS.md`）？
6. `/new-project-init` 这类斜杠显式调用是否可用？
7. `Agent` / `Workflow` 子代理是否继承父会话上下文（问一句「你看得到 SKILL.md 正文吗」即知）？
8. 写文件、跑命令是否需要逐次批准？被拒后能否换路径重试？

## 7. 维护说明

- 本文件只**增加**指引，不复制任何规则（唯一出处原则：规则仍只在 SKILL.md 与模板中定义）。
- 改本文件 → 按 SKILL.md「逐文件三要素」在 SKILL.md 版本表 + docs/CREATION-LOG.md 追加变更记录行；本文件自身变更记录区为**头部头插**（纯 AI 看）。
- **转正条件**：第 6 节清单跑完、结论回填后，本平台适配才算按三判据②完成实测。
