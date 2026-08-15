# 仓库打磨路线图（ROADMAP）

> 记录「优秀仓库都做了什么」的调研清单，作为本仓库后续逐步落地的待办（**先记录、后执行**）。
> 参照实证：obra/superpowers（27 万★）、anthropics/skills（17 万★）、jnMetaCode/superpowers-zh（7.6 万★，同源中文增强版）。
> 状态标记：✅ 已有 ｜ 📋 待办（建议做） ｜ 🔵 可选（按需）。

## A. 仓库元数据与搜索（低投入、高回报）

| 做法 | 参照 | 状态 |
|------|------|------|
| About 描述（存量完善优先定位） | 通用 | ✅ 已做（2026-08-15） |
| Topics 标签（8-11 个：skills / ai-coding / claude-code / agents / documentation…） | superpowers 8 个、superpowers-zh 11 个 | 📋 搜索曝光主来源，待打 |
| Homepage / Website 指向文档站 | superpowers-zh → sp.aiolaola.com | 🔵 有文档站后设置 |
| README 首屏 SEO 关键词 + 徽章 | 通用 | ✅ 已有（效果对比/徽章/定位句） |

## B. 多平台适配（skill 类特有打法）

| 做法 | 参照 | 状态 |
|------|------|------|
| 多 agent 插件目录：`.claude-plugin/` `.cursor-plugin/` `.codex-plugin/` `.kimi-plugin/` `.opencode/` `gemini-extension.json` | superpowers / superpowers-zh | 🔵 本项目面向 Reasonix/Claude，可后续补 |
| 多工具说明文件：`AGENTS.md` `CLAUDE.md` `GEMINI.md` | superpowers / superpowers-zh | 📋 至少补一份安装/使用说明（如何把本 skill 装进 agent） |

## C. 发布与版本

| 做法 | 参照 | 状态 |
|------|------|------|
| GitHub Releases：tag + 语义化版本 + 发布说明 | superpowers `RELEASE-NOTES.md` | 📋 本项目有 CREATION-LOG（v10.x），缺 GitHub tag/Release |
| 版本自动 bump：`.version-bump.json` / release-please | superpowers / superpowers-zh | 📋 配合 CI 自动发布 |
| npm / 包管理器分发 | superpowers-zh（npm-package topic） | 🔵 有需求再做 |
| CHANGELOG | 通用 | ✅ CREATION-LOG.md 已有 |

## D. 文档与站点

| 做法 | 参照 | 状态 |
|------|------|------|
| 文档站：`docs/` + `site/` + GitHub Actions 自动部署 | superpowers-zh `deploy-site.yml` | 🔵 后期可选 |
| 多语言 README（`README.zh-Hant.md` 等） | superpowers-zh | 🔵 有英文用户再加 |
| `assets/` 图片 / 演示 GIF / 效果截图 | superpowers / superpowers-zh | 📋 示例产出展示（本 skill 真实产出截图） |
| TOC、star-history 图 | 通用 | 🔵 可选 |

## E. CI/CD 与质量自动化

| 做法 | 参照 | 状态 |
|------|------|------|
| CI：markdownlint + 链接检查（文档多、断链是真实痛点 U13）+ prettier | superpowers-zh `ci.yml` | 📋 最值得先做的一项 |
| 依赖/动作更新：dependabot / renovate | 通用 | 📋 |
| pre-commit 钩子：`.pre-commit-config.yaml` | superpowers | 🔵 |
| 自动化测试目录 `tests/` | superpowers / superpowers-zh | 🔵 现有 `testing/` 走查为人工流程，可后续自动化 |
| 行尾规范：`.gitattributes` | superpowers | 🔵 Windows 协作下有价值 |

## F. 社区与治理

| 做法 | 参照 | 状态 |
|------|------|------|
| CONTRIBUTING.md + issue/PR 模板 | 通用 | ✅ 已做（2026-08-15） |
| CODE_OF_CONDUCT.md | superpowers / superpowers-zh | 📋 开放贡献的标配 |
| SECURITY.md（漏洞报告流程） | 通用 | 🔵 |
| 开启 Discussions + issue labels 规范 + Stale bot | 通用 | 📋 单人维护提效 |
| 第三方致谢/合规：THIRD_PARTY_NOTICES.md | anthropics/skills | 🔵 本项目致谢在 SKILL.md 内 |
| GitHub Sponsors / 赞助按钮 | 通用 | 🔵 有影响力后再说 |

## G. 增长与推广

| 做法 | 说明 | 状态 |
|------|------|------|
| 提交 Awesome 列表（awesome-claude-skills 等） | 冷启动主要流量 | 🔵 待办 |
| 社区发帖（X / Reddit / 掘金 / V2EX / 公众号） | 配合发布节点 | 🔵 待办 |
| 真实示例展示（用本 skill 产出的项目结构/效果） | 转化率最高 | 📋 |

## 建议的执行顺序（后面做时按此推进）

1. **Topics 标签**（5 分钟，搜索曝光）
2. **安装/使用说明**（README 或独立文档：如何装进 Reasonix/Claude）
3. **CI：markdownlint + 链接检查**（superpowers-zh ci.yml 同款）
4. **CODE_OF_CONDUCT.md**（开放贡献标配）
5. **GitHub Releases + 语义化版本 tag**（配合 CI 自动发布）
6. **Discussions + Stale bot + labels**（单人维护提效）
7. 其余按需（文档站 / 多语言 / npm / 赞助…）

---
*记录时间：2026-08-15（用户要求先记录优秀仓库做法，后续再逐项执行）。*
