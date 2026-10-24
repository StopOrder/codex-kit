#!/usr/bin/env bash
# codex-kit 설치 — 비파괴. 이미 있는 파일은 건드리지 않고 .new 로 옆에 둔다.
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$HOME/.agents/skills"
WS="$HOME/workspace"
PJ="$HOME/Projects"

put() { # put <src> <dst>  : dst 없으면 복사, 있고 다르면 dst.new 로
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ ! -e "$dst" ]; then
    cp "$src" "$dst"; echo "  + $dst"
  elif cmp -s "$src" "$dst"; then
    echo "  = $dst (동일)"
  else
    cp "$src" "$dst.new"; echo "  ! $dst 이미 있음 → $dst.new 로 둠. 직접 합치세요"
  fi
}

echo "[1/4] 전역 AGENTS.md → $CODEX_HOME"
put "$KIT/home/.codex/AGENTS.md" "$CODEX_HOME/AGENTS.md"

echo "[2/4] 스킬 → $SKILLS_DIR"
for d in "$KIT"/skills/*/; do
  name="$(basename "$d")"
  put "$d/SKILL.md" "$SKILLS_DIR/$name/SKILL.md"
done
# 스캐폴드 스킬이 참조하는 템플릿
put "$KIT/templates/project/AGENTS.md" "$SKILLS_DIR/project-init/template.md"
put "$KIT/templates/agent/AGENTS.md"   "$SKILLS_DIR/agent-init/template.md"

echo "[3/4] 폴더 트리 → $WS, $PJ"
for l in 00-workflow 01-infra 02-sandbox 03-agents 04-archive; do mkdir -p "$WS/$l"; done
for l in 00-research 01-main 02-hackathon 03-personal 04-archive; do mkdir -p "$PJ/$l"; done
put "$KIT/tree/workspace/README.md" "$WS/README.md"
put "$KIT/tree/Projects/README.md"  "$PJ/README.md"

echo "[4/4] 확인"
echo "  AGENTS.md: $(wc -c < "$CODEX_HOME/AGENTS.md") bytes (Codex 기본 한도 32768 — 프로젝트 AGENTS.md와 합산)"
ls "$SKILLS_DIR" | sed 's/^/  skill: /'
cat <<EOF

끝. Codex를 재시작하면 반영된다.
- 전역 규약: $CODEX_HOME/AGENTS.md
- 스킬 호출: \$project-init  \$agent-init  \$session-handoff
- 선택: $CODEX_HOME/config.toml 에 다음을 넣으면 Claude Code 식 CLAUDE.md 도 대안 이름으로 읽힌다
    project_doc_fallback_filenames = ["CLAUDE.md"]
EOF
