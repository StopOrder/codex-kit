# codex-kit 설치 (Windows PowerShell) — 비파괴. 이미 있는 파일은 건드리지 않고 .new 로 옆에 둔다.
$ErrorActionPreference = 'Stop'

$Kit       = Split-Path -Parent $MyInvocation.MyCommand.Path
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$SkillsDir = Join-Path $HOME '.agents\skills'
$WS        = Join-Path $HOME 'workspace'
$PJ        = Join-Path $HOME 'Projects'

function Put($src, $dst) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  if (-not (Test-Path $dst)) {
    Copy-Item $src $dst; Write-Host "  + $dst"
  } elseif ((Get-FileHash $src).Hash -eq (Get-FileHash $dst).Hash) {
    Write-Host "  = $dst (동일)"
  } else {
    Copy-Item $src "$dst.new"; Write-Host "  ! $dst 이미 있음 → $dst.new 로 둠. 직접 합치세요"
  }
}

Write-Host "[1/4] 전역 AGENTS.md → $CodexHome"
Put (Join-Path $Kit 'home\.codex\AGENTS.md') (Join-Path $CodexHome 'AGENTS.md')

Write-Host "[2/4] 스킬 → $SkillsDir"
Get-ChildItem (Join-Path $Kit 'skills') -Directory | ForEach-Object {
  Put (Join-Path $_.FullName 'SKILL.md') (Join-Path $SkillsDir "$($_.Name)\SKILL.md")
}
Put (Join-Path $Kit 'templates\project\AGENTS.md') (Join-Path $SkillsDir 'project-init\template.md')
Put (Join-Path $Kit 'templates\agent\AGENTS.md')   (Join-Path $SkillsDir 'agent-init\template.md')

Write-Host "[3/4] 폴더 트리 → $WS, $PJ"
'00-workflow','01-infra','02-sandbox','03-agents','04-archive'     | ForEach-Object { New-Item -ItemType Directory -Force -Path (Join-Path $WS $_) | Out-Null }
'00-research','01-main','02-hackathon','03-personal','04-archive'  | ForEach-Object { New-Item -ItemType Directory -Force -Path (Join-Path $PJ $_) | Out-Null }
Put (Join-Path $Kit 'tree\workspace\README.md') (Join-Path $WS 'README.md')
Put (Join-Path $Kit 'tree\Projects\README.md')  (Join-Path $PJ 'README.md')

Write-Host "[4/4] 확인"
$bytes = (Get-Item (Join-Path $CodexHome 'AGENTS.md')).Length
Write-Host "  AGENTS.md: $bytes bytes (Codex 기본 한도 32768 — 프로젝트 AGENTS.md와 합산)"
Get-ChildItem $SkillsDir -Directory | ForEach-Object { Write-Host "  skill: $($_.Name)" }
Write-Host @"

끝. Codex를 재시작하면 반영된다.
- 전역 규약: $CodexHome\AGENTS.md
- 스킬 호출: `$project-init  `$agent-init  `$session-handoff
- 선택: $CodexHome\config.toml 에 다음을 넣으면 Claude Code 식 CLAUDE.md 도 대안 이름으로 읽힌다
    project_doc_fallback_filenames = ["CLAUDE.md"]
"@
