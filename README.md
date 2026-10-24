# codex-kit — Codex용 작업 환경 규약 한 벌

Claude Code에서 쓰던 폴더 구조(도구의 집 `workspace` / 결과물의 집 `Projects`, 폴더형 에이전트, 산출물 분리 규약)를
**Codex 전용**으로 옮긴 것. 훅·서브에이전트처럼 Codex에 없는 기구는 빼고, 글로 된 규약과 스킬만 담았다.

## 설치

**Linux / macOS**

```bash
git clone https://github.com/StopOrder/codex-kit.git ~/codex-kit && bash ~/codex-kit/install.sh
```

**Windows (PowerShell)**

```powershell
git clone https://github.com/StopOrder/codex-kit.git "$HOME\codex-kit"; & "$HOME\codex-kit\install.ps1"
```

비파괴다. 이미 있는 파일은 건드리지 않고 `.new`를 옆에 둔다. 설치 후 Codex를 재시작한다.

## 무엇이 어디에 깔리나

| 키트 안 | 설치 위치 | 역할 |
|---|---|---|
| `home/.codex/AGENTS.md` | `~/.codex/AGENTS.md` | **전역 규약.** 언어, 두 집 구조, 산출물 분리, 일하는 방식, 세션 마무리 |
| `skills/project-init/` | `~/.agents/skills/project-init/` | 프로젝트 폴더의 `AGENTS.md` 스캐폴드. `$project-init` |
| `skills/agent-init/` | `~/.agents/skills/agent-init/` | 폴더형 에이전트 스캐폴드. `$agent-init` |
| `skills/session-handoff/` | `~/.agents/skills/session-handoff/` | 미완 작업을 새 세션에 넘기는 `HANDOFF.md`. `$session-handoff` |
| `templates/project/AGENTS.md` | `~/.agents/skills/project-init/template.md` | 프로젝트 `AGENTS.md` 골격 |
| `templates/agent/` | `~/.agents/skills/agent-init/template.md` | 에이전트 `AGENTS.md` 골격 |
| `tree/workspace/README.md` | `~/workspace/README.md` + 층 폴더 5개 | 도구의 집 |
| `tree/Projects/README.md` | `~/Projects/README.md` + 층 폴더 5개 | 결과물의 집 |

## 구조 한눈에

```
~/.codex/AGENTS.md                 ← 전역 규약 (모든 세션)
~/.agents/skills/<스킬>/SKILL.md   ← 전역 스킬 ($이름 으로 호출)

~/workspace/                       ← 도구의 집 (층 = 역할 순서)
  00-workflow/ 01-infra/ 02-sandbox/ 03-agents/ 04-archive/
  02-sandbox/<에이전트>/
    AGENTS.md          (OUT_SLUG: xxx 선언 포함)
    .agents/skills/    (그 에이전트의 스킬)
    tools/ assets/ vendor/ docs/

~/Projects/                        ← 결과물의 집 (층 = 카테고리)
  00-research/ 01-main/ 02-hackathon/ 03-personal/ 04-archive/
  <층>/<프로젝트>/
    AGENTS.md          (명령·구조·하지 말 것·받는 OUT_SLUG 원장)
    <OUT_SLUG>/<회차>/ (밖의 에이전트가 써넣는 산출물)
```

핵심 규칙 하나: **에이전트 폴더에는 산출물을 남기지 않는다.** 에이전트 폴더에 앉아 일하되, 결과는
`~/Projects/<층>/<프로젝트>/<OUT_SLUG>/`로 절대경로로 쓴다.

## Claude Code와 다른 점 (왜 이렇게 옮겼나)

| Claude Code | Codex | 비고 |
|---|---|---|
| `CLAUDE.md` (상위 탐색이 git 경계를 넘음) | `AGENTS.md` (git 루트 → cwd만 합침) | 트리 꼭대기 규약이 전역 `~/.codex/AGENTS.md`로 올라간 이유 |
| `~/.claude/skills/` | `~/.agents/skills/` | `SKILL.md` 형식은 같다 |
| `.claude/rules/*.md` (`paths:` 범위) | 하위 디렉터리 `AGENTS.md` | 그 디렉터리에서 일할 때만 붙는다 |
| `.claude/agents/*.md` 서브에이전트 | 없음 | 절차를 스킬로 풀었다 |
| `settings.json` 훅 | 없음 | "항상 X 하라"는 AGENTS.md 문장으로 |
| `@AGENTS.md` import | — | Claude Code도 같이 쓰면 `CLAUDE.md`를 `@AGENTS.md` 한 줄로 두고 정본은 `AGENTS.md` |

Codex 쪽 사실은 공식 문서 기준(2026-10): 전역 파일은 `$CODEX_HOME/AGENTS.md`(기본 `~/.codex`),
`AGENTS.override.md`가 있으면 그게 우선, 합산 한도 `project_doc_max_bytes` 기본 32 KiB, 스킬은
`~/.agents/skills`·repo의 `.agents/skills`·`/etc/codex/skills`.

## 고치는 법

정본은 이 저장소다. 설치된 사본(`~/.codex/AGENTS.md`, `~/.agents/skills/…`)을 고쳤으면 여기로 되가져와 커밋한다.
`SKILL.md`에 BOM을 붙이지 마라 — frontmatter 파싱이 깨진다.
