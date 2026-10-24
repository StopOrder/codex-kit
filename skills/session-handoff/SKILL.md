---
name: session-handoff
description: Use when unfinished work must continue in a fresh Codex session — the user says "인수인계", "핸드오프", "새 세션에서 이어가게 정리해줘", "handoff", or the context is getting long with work still open. Writes HANDOFF.md so the next session can resume without re-deriving anything. Do not use for a finished task (commits and outputs are the record) or for a user-facing summary of what was built.
---

# session-handoff — 다음 세션이 그대로 이어받는 HANDOFF.md

읽는 사람은 **아무 기억이 없는 새 세션**이다. 요약이 아니라 **재개에 필요한 사실**을 쓴다.

## 어디에 쓰나

| 작업이 사는 곳 | 파일 |
|---|---|
| 프로젝트 (`~/Projects/…`) | `<프로젝트>/docs/handoffs/HANDOFF.md` |
| 에이전트 폴더 (`~/workspace/…`) — 장비 자체를 고치는 중 | `<에이전트>/docs/HANDOFF.md` |
| 에이전트 폴더에 앉아 **산출물**을 만드는 중 | 산출물 쪽 `~/Projects/<층>/<프로젝트>/<OUT_SLUG>/HANDOFF.md` |

이미 `HANDOFF.md`가 있으면 **덮어쓰지 말고** 읽은 뒤 갱신한다. 지난 내용 중 끝난 항목은 「완료」로 옮기고 지우지 않는다.
세대가 쌓이면 옛것은 `HANDOFF-1.md`, `HANDOFF-2.md`로 밀고 `HANDOFF.md`는 항상 최신.

## 구조

```markdown
# HANDOFF — <작업 이름>  (<YYYY-MM-DD HH:MM>, 쓴 세션의 한 줄 정체)

## 목표
한 문장. 이 작업이 끝났다고 말할 수 있는 조건.

## 지금 상태
- 된 것 (검증 방법·결과 포함 — "테스트 12/12 통과", "배포 URL 열어 확인")
- 안 된 것 / 하다 만 것 (어디서 멈췄는지 파일·줄·명령까지)

## 결정 (바꾸지 말 것)
- <결정> — 왜. 사용자가 정한 것은 "사용자 결정"이라고 표시.

## 다음에 할 일 (순서대로)
1. <구체 행동> → 확인: <명령 또는 보는 곳>
2. …

## 함정
- 실제로 부딪힌 것만. 재현 조건과 우회로.

## 참조
- 정본 문서, 관련 파일, 외부 URL — 전부 절대경로 또는 전체 URL.
```

## 규칙

- **절대경로.** `./src`나 "그 파일"이 아니라 `~/Projects/02-hackathon/foo/src/x.ts:42`.
- **명령은 그대로.** 재개 세션이 복사해 붙일 수 있게. 환경 변수·cwd 전제도 함께.
- **검증된 것과 추측을 가른다.** 돌려보지 않은 것은 "미확인"이라고 쓴다.
- **사용자가 결정할 것을 대신 정하지 않는다.** 미결은 「다음에 할 일」에 "사용자에게 물을 것: …"으로.
- 쓴 뒤 **한 번 다시 읽고**, 아무 기억이 없는 상태로 1번 행동을 시작할 수 있는지 자문한다. 못 하면 빠진 사실을 채운다.
- 쓰고 나서 사용자에게 파일 경로를 알린다. 커밋은 사용자가 시킬 때만.
