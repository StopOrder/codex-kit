---
name: project-init
description: Use when scaffolding Codex configuration (AGENTS.md) for a folder where real code and outputs live — a new project, a project without AGENTS.md, an inherited codebase, or a project folder that will receive outputs written by agents sitting elsewhere; usually under ~/Projects/. Also when a project's AGENTS.md has grown past ~200 lines. Do not use for folder-agents under ~/workspace/ (use agent-init) or for sorting loose files.
---

# project-init — 프로젝트 폴더 스캐폴드

프로젝트는 **일의 결과가 사는 곳**이다. 여기서 만드는 `AGENTS.md`는 그 코드를 다루기 위한 설정이지
도메인 에이전트가 아니다.

## 0. 대상 경로 판정 — 건너뛰지 않는다

판정하는 것은 cwd가 아니라 **스캐폴드할 폴더**다. 사용자가 대상을 말했으면 그 경로, 아니면 cwd.
새 프로젝트라면 그 폴더는 아직 없으므로 cwd일 수 없다 — **대상이 불분명하면 파일을 만들기 전에 묻는다.**

- 대상이 `~/workspace/` 아래면 이 스킬이 아니다. "여기는 에이전트 폴더다" 한 줄 알리고 `$agent-init`으로 넘긴다.
- 대상이 `~/Projects/` 최상위면 안 된다. 층(`00-research` … `04-archive`) 아래여야 한다. 층이 애매하면 묻는다.
- git 워크트리로 의심되면 `git rev-parse --git-common-dir`로 본체를 찾아 **본체 경로로 판정**한다.

## 1. 모드 판정

| 상황 | 할 일 |
|---|---|
| 빈 폴더 / 새 프로젝트 | §3 (a) |
| 코드가 이미 있다 (인수 포함) | §2 정찰 → §3 (a) |
| 밖의 에이전트가 산출물을 써넣는 수신처 | §3 (b). **폴더를 봐서는 알 수 없다** — 새 프로젝트면 사용자에게 "여기로 산출물을 써넣을 에이전트가 있나?" 묻는다 |
| (a)이면서 (b) | 둘 다 한다. 드물지 않다 |
| `AGENTS.md`가 200줄을 넘었다 | §4 재편 |

## 2. 정찰 — 코드가 있으면 필수

읽기만 한다. 파일을 만들지 않는다.

1. 루트 목록, `README*`, 패키지 매니페스트(`package.json`·`pyproject.toml`·`Cargo.toml`·…), 락파일, CI 설정.
2. 이미 있는 에이전트 지시문: `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`.
   **있으면 그 내용을 정본으로 삼고 합친다** — 새로 쓰지 않는다.
3. 실제로 돌아가는 명령을 확인한다 — 매니페스트의 `scripts`를 읽고, 테스트 명령은 **한 번 실행**해 본다.
   돌려보지 않은 명령을 `AGENTS.md`에 적지 않는다.

## 3. 쓰기

**(a) 코드 설정** — `templates/project/AGENTS.md`(이 키트의 `~/.agents/skills/project-init/template.md`) 골격으로
루트 `AGENTS.md`를 쓴다. 채우는 것은 네 가지뿐: 한 줄 소개와 정본 문서 위치 · 명령 표(검증된 것만) ·
구조(최상위 5~8개) · 하지 말 것. **200줄 아래.** 디렉터리 전용 설명은 그 디렉터리의 `AGENTS.md`로 내린다
(Codex는 루트→cwd 순으로 합쳐 읽으므로 그 디렉터리에서 일할 때만 붙는다).

Claude Code도 같이 쓰는 환경이면 `CLAUDE.md`를 한 줄 `@AGENTS.md`로 만든다. 정본은 항상 `AGENTS.md`.

**(b) 산출물 수신처** — 루트 `AGENTS.md`의 「받는 산출물」 표에 `OUT_SLUG` · 보내는 에이전트 경로 · 무엇을 적는다.
에이전트 쪽 `AGENTS.md`의 `OUT_SLUG:` 선언과 **글자까지 같아야** 한다. 다르면 다음 세션이 폴더를 두 개 만든다.

**만들지 않는 것**: `.gitignore`·린터 설정·CI 같은 프로젝트 도구는 요청받았을 때만. 이 스킬은 에이전트 지시문만 만든다.

## 4. 재편 — 유일하게 기존 문서를 다시 쓰는 모드

줄 수가 줄었다는 것은 성공의 증거가 아니다. **잃은 문단이 없다는 것이 증거다.**

1. 원본을 `AGENTS.md.bak-<날짜>`로 복사한다. git이 아닐 수 있다고 가정한다.
2. 원본의 **모든 문단**에 대해 대응표를 만든다: 남김 · 하위 디렉터리 `AGENTS.md`로 · 스킬로 · **버림**.
3. 버린 것은 이유와 함께 사용자에게 보여주고 승인받은 뒤 쓴다.

## 5. 끝내기 전에

- `AGENTS.md`의 명령을 하나 골라 다시 실행해 본다.
- 200줄 아래인지 `wc -l`로 확인한다.
- 사용자에게 만든 파일 목록과 **묻지 못해 비워 둔 칸**을 알린다. 채워 넣은 척하지 않는다.
