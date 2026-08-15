# memory/agent-activity-log.md 章节模板（模板 04）
> 🗂️ **产出模式**：一次性文档（skill 特化即正式文件，后续修改=更新式：改内容+变更记录+署名）；模板目录：templates/一次性/（v10.0 目录规整）
> 📍 **变更记录方向**：新行插顶部（纯 AI 看；见 SKILL.md 文档维护规则第 9 条）

> **一次性创建 + 持续维护**（每模块每阶段交接时记 1 行，阶段交接硬性校验）。示例=结构示范。
> 定位：**进度总览**——新 agent 入场第三份必读，看各模块各阶段最近进展；每模块每阶段 1 行，不逐动作记录（逐动作见 memory/logs/）。

---

## 第一部分：章节结构一览

```
memory/agent-activity-log.md
├── # Agent 活动日志
├── > 粒度规则说明       ← 每模块每阶段 1 行（PLAN/CODE/REVIEW/TEST 交接各 1 行）
├── ## 活动记录（单表）  ← 时间/模块/阶段/执行者/动作标签/产出文件/状态
└── ## 维护规则          ← 历史不删/更正用 [CORRECT]/阶段退出必记
```

> **动作标签**：完整标签表（20 个 + 语义）**唯一出处见 CLAUDE.md C 区「记忆库纪律」**，本文件不再重复定义；使用时查 CLAUDE.md。

## 第二部分：详细规格

- **单表结构**（不按 agent/日期拆分文件）：
```
| 时间 | 模块 | 阶段 | 执行者 | 动作标签 | 产出文件 | 状态 |
```
- **粒度**：每模块 4 行（PLAN / CODE / REVIEW / TEST 交接各 1 行）；交接行阶段写 `CODE→REVIEW` 之类。
- **动作标签**：完整标签表（20 个 + 语义）唯一出处见 **CLAUDE.md C 区「记忆库纪律」**（PLAN/CLARIFY/CODE/FIX/BUILD/REVIEW/ADR/TEST/REGRESSION/SMOKE/BLOCKED/UNBLOCKED/HANDOFF/CONTEXT/CORRECT/ESCALATE/GIT/DB/CLEANUP/DOCS），本文件不重复定义。
- **状态**：✅ / 📋 / ❌（不通过时写明原因）。
- **历史不删除、不修改**；写错用追加一条 `[CORRECT]` 记录更正，不直接改。
- **每阶段退出前必记**（交接 SendMessage 附「已更新记忆库文件清单」），否则下一阶段不启动。

### 示例（结构示范）
```markdown
# Agent 活动日志

## 活动记录（单表）
| 时间 | 模块 | 阶段 | 执行者 | 动作标签 | 产出文件 | 状态 |
|------|------|------|--------|----------|----------|------|
| 2026-08-03 | module-001 | PLAN | Planner | `[PLAN]` | specs/module-001/plan.md、acceptance-criteria.md | ✅ |
| 2026-08-03 | module-001 | CODE | Developer | `[CODE]` | 4 文件改动 + changelog.md | ✅ |
| 2026-08-03 | module-001 | REVIEW | Reviewer | `[REVIEW]` | specs/module-001/review-report.md | ❌ 不通过（2 阻塞） |
| 2026-08-03 | module-001 | TEST | Tester | `[TEST]` | specs/module-001/test-report.md | ✅ |

## 动作标签说明
- `[PLAN]` 计划产出 / `[CODE]` 编码 / `[BUILD]` 构建 / `[REVIEW]` 审查 / `[TEST]` 测试 / `[HANDOFF]` 交接 / `[CONTEXT]` 上下文维护 …
- （完整标签表 20 个 + 语义见 CLAUDE.md C 区）
```

## 变更记录

| 日期时间 | 变更内容 | 署名 |
|----------|----------|------|
| 2026-08-15 | v10.5：变更记录方向标注统一为「新行插顶部（纯 AI）」（SKILL.md 第 9 条 v10.5）+ 存量行序规整 | Reasonix（skill 迭代） |
| 2026-08-14 | 动作标签定义改唯一出处（→CLAUDE.md C 区「记忆库纪律」），本文件不再重复维护标签表；补变更记录区 | Reasonix（skill 迭代） |
