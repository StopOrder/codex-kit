# .agents/skills

이 에이전트의 스킬 폴더. Codex는 cwd에서 repo 루트까지 올라가며 각 `.agents/skills/`를 읽는다.

- 스킬 하나 = 폴더 하나 = `SKILL.md` 하나. frontmatter에 `name`·`description` 필수.
- `description`에는 **언제 쓰고 언제 안 쓰는지**를 적는다 — 암묵 호출 매칭에 그 문장이 쓰인다.
- 긴 참고 자료는 `references/`, 스크립트는 `scripts/`로 빼고 `SKILL.md`는 절차만 남긴다.
- 전역 스킬(`~/.agents/skills/`)과 이름이 겹치면 둘 다 선택기에 뜬다. 겹치지 않게 짓는다.
