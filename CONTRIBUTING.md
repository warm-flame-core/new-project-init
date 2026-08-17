# 贡献指南（CONTRIBUTING）

感谢你对 **new-project-init** 感兴趣！本仓库由 **warm-flame-core** 单人维护，但对社区开放 —— 欢迎提 **issue** 和 **PR**，维护者会定期处理。

## 如何提 issue

- 先搜索 [已有 issue](https://github.com/warm-flame-core/new-project-init/issues)，避免重复。
- 使用模板：[Bug 报告](https://github.com/warm-flame-core/new-project-init/issues/new?template=bug_report.md) / [功能请求](https://github.com/warm-flame-core/new-project-init/issues/new?template=feature_request.md)。
- 描述请尽量具体：触发场景（全新 / 中途加入 / 存量完善）、期望行为、实际行为、相关模板编号。

## 如何提 PR

1. **Fork** 本仓库，在独立分支上修改（如 `fix/xxx`、`feat/xxx`）。
2. **遵循本 skill 的迭代纪律**（见 `SKILL.md` 的「skill 迭代大前提」与 `docs/CREATION-LOG.md`）：
   - 修改模板或主文件时**至少升一个小版本**；
   - 在 `docs/CREATION-LOG.md` **顶部追加一行**变更记录（读最近类，顶部插最新），注明改动、理由与来源；
   - 同步更新受影响的模板头部「📍 变更记录方向」「02 最后更新」等字段。
3. 若改动影响问询 / 流程，请用 `testing/` 下对应的**验证走查**过一遍，并在 PR 描述中说明。
4. 提交信息建议用 `<类型>: <简述>`（如 `feat: 新增存量完善阶段 0 核查`、`fix: 修正模板 17 必填核对表`）。
5. 提交 PR，勾选模板中的清单。

## 单人维护说明

- 只有一个维护者，review 可能不快 —— 请耐心等待，PR 保持小而聚焦会更快合入。
- 大改动（涉及整体流程重构）建议**先提 issue 讨论**再动代码，避免返工。
- 维护者有权关闭长期无人响应的 issue / 超范围 PR，并会给出说明。

## 行为准则

保持友善、就事论事。欢迎任何语言（中文 / English 均可）。
