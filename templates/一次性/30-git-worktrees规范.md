# git worktrees 并行工作区规范 章节模板（模板 30）
> 🗂️ **产出模式**：一次性文档；模板目录：templates/一次性/（v11.0 新增，源自 backlog BL-01）
> 📍 **变更记录方向**：新行追加底部（有人看；见 SKILL.md 文档维护规则第 9 条）
> 🧩 **装配方式**：可选规范模块（见 SKILL.md「规范装配问询」）——默认**关**；问询「需要并行工作区隔离吗？」用户答「要」时产出本独立文件（如 `docs/git工作区规范.md`），并登记进 DOCUMENT-INDEX + `<入口规范文件>` 信息闭环图。
> 📎 **参考来源**：git `worktree` 官方机制 + BL-01（并行 agent/多人同时改动互踩场景）；与模板 31 并行 agent 调度配套，二者常一起装配。

> ⚠️ **维护声明**：本文档修改后必须在末尾「变更记录」表追加一行——`YYYY-MM-DD HH:mm | 变更内容 | 署名`（署名按四段式 实体人-平台-角色@分支（无 git 省略 @分支，如 warmflame-Reasonix-Developer@feat/xxx）；无法确认身份先问用户）。

## 第一部分：章节结构一览

```
git worktrees 并行工作区规范
├── 适用场景（何时需要并行工作区）
├── 概念（worktree / 基础仓库 / 各分支占位）
├── 创建与管理（git worktree 命令）
├── 并行隔离纪律（分支/依赖/冲突最小化）
└── 与并行 agent 调度的衔接（BL-02）
```

## 第二部分：详细规格（写什么 / 格式 / 示例）

### 1. 适用场景（何时装配本规范）

- **需要多个 agent / 多个人同时改同一仓库的不同模块**，且互不想被对方未提交改动干扰。
- 开发分支要长期共存（如主线在等验收、专项分支并行推进）而**不想反复 stash / 切换 checkout 丢失现场**。
- 模块间**依赖稀疏**（分层清晰、改动点不重叠）时收益最大；依赖密集时反而建议串行或同 worktree 顺序推进。

### 2. 概念（一句话搞懂）

- **git worktree**：同**一个仓库**（同一 `git` 仓库、同一对象库）在**多个工作目录**里分别检出不同分支；各 worktree 目录是独立的工作区，**互不阻塞**（不冲突）。
- **基础仓库**（`.git` 所在、第一个 checkout）：可作为只读主工作目录或每个并行分支各开一个 worktree。
- **注意事项**：一个分支同一时间只能被一个 worktree 检出；切走前保证干净（提交或 stash）。

### 3. 创建与管理

```
# 查看当前 worktree
git worktree list

# 新增一个 worktree（新目录 + 新分支）
git worktree add ../project-feat-b feat/b

# 已有分支检出到新目录
git worktree add ../project-main main

# 移除不再使用的 worktree（先清目录改动）
git worktree remove ../project-feat-b

# 修剪失效条目（删除目录后）
git worktree prune
```

- 目录命名带分支含义（`../<仓库名>-<分支>`），不进 `.gitignore`（是真实工作区）。临时并行区可用 `.tmp-*/` 命名并按记忆纪律用完即删。

### 4. 并行隔离纪律（硬规则）

1. **分支隔离**：每个并行 worktree 对应**自己的分支**；公共分支（main/develop）不在并行 worktree 内直接改动。
2. **rebase 而非 merge 到主线**：并行分支完成合并回主线前先 `git fetch origin && git rebase origin/main`，冲突在**各自分支**解决，避免污染共享工作区。
3. **互不依赖的改动集**：并行模块只改自己的文件；**共享文件**（如公共配置、公共接口签名）改前先确认没有其他 worktree 在同一处改动，否则串行推进。
4. **提交纪律**：改完即提交（记录提交号入记忆库 agent-activity-log），避免 worktree 长期脏。
5. **占位/冲突最小化**：数据库迁移、依赖清单（pom/package-lock）等全局文件**只在单一 worktree 改**，其他人 `rebase` 后接用，不并行编辑同一文件。

### 5. 与并行 agent 调度（BL-02）的衔接

- **worktree = 空间维度隔离，agent = 时间维度调度**：BL-02 派多个 subagent 并行时，各 subagent 若写文件 → 分配到**不同 worktree**（避免同一目录同时写撞车）。
- 只读 agent（探索/审查/研究）**不需要独立 worktree**，可共用一个只读目录并行。
- 并行收尾回归：所有分支合并后，在**单一干净工作区**跑全量测试再 push（见模板 24 阶段 6 / 模板 28 §5 合并规范）。

### 示例（摘自 PTB-IMP 并行专项 worktree 使用记录，结构脱敏）

```markdown
- 主线 worktree：../ptb-imp-main（main，只读核对）
- 权限专项 worktree：../ptb-imp-perm（feat/perm-008）
- 每模块在 feat/perm-00X 分支改各自 specs/module-XXX/，共享 SecurityConfig 时先确认无冲突
- 合并回 main 前逐一 rebase + 全量 mvn test 绿
```

---

## 变更记录

| 日期时间 | 变更内容 | 署名 |
|----------|----------|------|
| 2026-08-17 | v11.0：新增本模板（backlog BL-01 git worktrees 并行工作区规范，可装配模块·默认关；适用场景/创建管理/隔离纪律/与 BL-02 衔接） | Reasonix（skill 迭代） |
