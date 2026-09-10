# 协作约定

## 团队成员

| 角色 | 成员 | 主要职责 |
|---|---|---|
| 协调 | @Cindy | 任务派发、收口、验收 |
| 主开发 | @general | 引擎项目、环境、集成 |
| 调研 | @scout | 引擎/资源调研 |
| 文档 | @writer | 项目记录、决策日志、模板 |

## Git 工作流

### 分支约定

- `main`：稳态分支，每个里程碑收口后才更新
- `feature/<task-id>-<short-name>`：单个任务的开发分支（如 `feature/e02-functional-sample`）
- `research/<task-id>-<short-name>`：调研报告分支

### 提交约定

```
<task-id>: <type>(<scope>): <subject>

<body>
```

类型：`feat` / `fix` / `docs` / `research` / `refactor` / `test`

示例：`e02: feat(sample): add cave scene with sword pickup`

### 推送与合并

- 任务完成 = 推送分支 + 在任务 thread 里报告（含 commit hash、变更摘要、自检结果）
- 由 @Cindy 在 thread 里决定是否合并到 main
- main 上的提交必须对应一个通过验收的任务

## 文件所有权

| 路径 | 主要负责 | 说明 |
|---|---|---|
| `src/`、`tools/` | @general | 代码与工具脚本 |
| `assets/` | @general + 用户审 | 美术与音效，需用户拍板风格 |
| `docs/DECISIONS.md`、`docs/TASK_TEMPLATE.md` | @writer | 决策与模板 |
| `research/` | @scout | 调研报告 |
| `README.md`、`CONTRIBUTING.md` | @Cindy | 项目元数据

其他成员修改非主负责路径前先在 thread 同步。

## 沟通

- 工作流同步走 Raft 频道（`#general` 项目主 thread、`#engineering`、`#research`）
- 每个任务有自己的 thread，由创建任务的 system 消息决定 target
- 重大决策 / 路线变更 / 用户拍板项 → `@ben-gao`，不要直接拍板

## 环境约束（O-005）

macmini02 网络受限：
- ❌ GitHub 不可达
- ✅ Godot 官网（godotengine.org）、GitLab、Docker Hub 可达

调研结论必须区分"已本地验证"和"仅文档可查"。