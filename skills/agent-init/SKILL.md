---
name: agent-init
description: Use when scaffolding or reorganizing a folder-agent — one folder that owns one domain (AGENTS.md + .agents/skills/ + tools/ + optionally a vendored third-party repo), always under ~/workspace/02-sandbox/ at first — or when absorbing a cloned third-party repo into such a folder, or when that folder's AGENTS.md has grown past ~200 lines. Do not use for project folders under ~/Projects/ where real code and outputs live (use project-init).
---

# agent-init — 폴더형 에이전트 스캐폴드

**폴더 경로가 곧 에이전트다.** 그 폴더에 앉으면 그 `AGENTS.md`와 `.agents/skills/`가 로드되고 그것이 능력이다.
이 스킬이 만드는 것은 전부 **장비**다. 일의 결과는 `~/Projects/<층>/<프로젝트>/<OUT_SLUG>/`로 나간다.

## 0. 대상 경로 판정

판정하는 것은 **스캐폴드할 폴더**의 경로다. 사용자가 말했으면 그 경로, 아니면 cwd. 불분명하면 묻는다.

- **새 에이전트는 항상 `~/workspace/02-sandbox/<이름>/`에서 시작한다.** `03-agents/`로의 승격은 몇 번 써본 뒤
  **사용자가 지시할 때만** — 이 스킬은 승격하지 않는다.
- 대상이 `~/workspace/` 밖이면 이 스킬이 아니다. 한 줄 알리고 `$project-init`으로 넘긴다.
- git 워크트리로 의심되면 `git rev-parse --git-common-dir`로 본체를 찾아 본체 경로로 판정한다.

## 1. 모드 판정

| 상황 | 할 일 |
|---|---|
| 빈 폴더 / 새로 만든다 | §3 트리 |
| 남의 repo를 클론해 왔다 | §2 정찰 → §3. **벤더 경계(§4)가 핵심** |
| 쓰던 에이전트인데 설정이 낡았다 | §2 정찰 → 갱신 |
| `AGENTS.md`가 200줄을 넘었다 | §5 재편 |

## 2. 정찰 (남의 repo일 때)

읽기만 한다. `README`, 라이선스, 진입점, 의존성, 그 repo가 자기 설정 파일을 어디에 두는지.
**라이선스가 재배포를 허락하지 않으면** 벤더링하지 않고 사용자에게 알린다.

## 3. 트리

```
<이름>/
├─ AGENTS.md                 # 역할 · OUT_SLUG · 장비 표 · 환경 전제 · 함정   (200줄 아래)
├─ .agents/skills/<스킬>/    # 이 에이전트의 절차. $<스킬>로 부른다
├─ tools/                    # 이 에이전트가 쓰는 스크립트 + README.md
├─ assets/                   # 두 번 이상 실제로 쓴 재료만 (승인 후 복사로 올린다)
├─ vendor/<repo>/            # 남의 repo. 고치지 않는다
└─ docs/                     # 이 에이전트를 만든 기록 — 설계, 함정, 장비용 HANDOFF.md
```

`AGENTS.md`는 이 키트의 `~/.agents/skills/agent-init/template.md` 골격으로 쓴다. **`OUT_SLUG: <슬러그>` 선언을
첫 부분에 반드시 넣는다** — 전역 규약이 이 한 줄로 산출물 경로를 정한다. 슬러그는 사용자와 정한다.
짧은 영문 소문자 한 단어가 좋다(`research`, `hwp`, `pitch`).

Claude Code도 같이 쓰는 환경이면 `CLAUDE.md`를 한 줄 `@AGENTS.md`로 만든다. 정본은 `AGENTS.md`.

**스킬 1개로 시작한다.** 이 에이전트가 가장 자주 할 일 하나를 `.agents/skills/<이름>/SKILL.md`로 쓴다.
`description`에는 언제 쓰고 **언제 안 쓰는지**를 적는다. 나머지 절차는 실제로 두 번 반복된 뒤에 스킬로 올린다.

## 4. 벤더 경계

- `vendor/<repo>/`는 **읽기 전용**이다. 패치가 필요하면 `tools/`에 래퍼를 쓰거나 `docs/`에 패치 파일을 둔다.
  직접 고치면 업스트림 갱신 때 조용히 사라진다.
- 벤더 repo의 `.git`은 지우고 `docs/vendor.md`에 출처 URL·커밋 해시·날짜를 적는다. (서브모듈은 쓰지 않는다 —
  클론한 사람마다 상태가 갈린다.)
- 벤더 repo 안의 `AGENTS.md`·`CLAUDE.md`는 **그 repo를 개발하는 사람용**이다. 이 에이전트의 지시와 충돌하면
  이 에이전트의 `AGENTS.md`가 이긴다고 거기 적어 둔다.

## 5. 재편 — 유일하게 기존 문서를 다시 쓰는 모드

1. 원본을 `AGENTS.md.bak-<날짜>`로 복사한다.
2. 원본의 모든 문단에 대응표를 만든다: 남김 · `.agents/skills/`로 · `docs/`로 · 하위 디렉터리 `AGENTS.md`로 · **버림**.
3. 버린 것은 이유와 함께 사용자에게 보여주고 승인받은 뒤 쓴다. **줄 수가 줄었다는 것은 성공의 증거가 아니다.**

## 6. 끝내기 전에

- `AGENTS.md`에 `OUT_SLUG:` 선언이 있는지, 200줄 아래인지 확인한다.
- `.agents/skills/*/SKILL.md`의 frontmatter에 `name`·`description`이 있는지, 파일 첫 3바이트가 BOM(`EF BB BF`)이
  아닌지 확인한다. BOM이 있으면 frontmatter 파싱이 깨진다.
- 사용자에게 만든 파일 목록과 **묻지 못해 비워 둔 칸**(환경 전제, 함정)을 알린다.
