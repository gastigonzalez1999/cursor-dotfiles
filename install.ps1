<#
.SYNOPSIS
  Installs cursor-agent-toolkit skills (and optional rules) into a project's .cursor folder.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -ProjectPath "D:\work\my-app"
  .\install.ps1 -SkipRules
  .\install.ps1 -Force
#>
[CmdletBinding()]
param(
  [string] $ProjectPath = ".",
  [switch] $SkipRules,
  [switch] $Force
)

$ErrorActionPreference = "Stop"
$ToolkitRoot = $PSScriptRoot
$SkillsSrc = Join-Path $ToolkitRoot "skills"
$RulesSrc = Join-Path $ToolkitRoot "rules"

$resolved = (Resolve-Path -LiteralPath $ProjectPath).Path
$destSkills = Join-Path $resolved ".cursor\skills"
$destRules = Join-Path $resolved ".cursor\rules"

Write-Host "Installing cursor-agent-toolkit into: $resolved"

New-Item -ItemType Directory -Force -Path $destSkills | Out-Null
New-Item -ItemType Directory -Force -Path $destRules | Out-Null

Get-ChildItem -LiteralPath $SkillsSrc -Directory | ForEach-Object {
  $name = $_.Name
  $dest = Join-Path $destSkills $name
  $skillMd = Join-Path $dest "SKILL.md"
  if ((Test-Path -LiteralPath $skillMd) -and -not $Force) {
    Write-Host "  [skip] skill: $name (exists, use -Force to replace)"
    return
  }
  if (Test-Path -LiteralPath $dest) {
    Remove-Item -LiteralPath $dest -Recurse -Force
  }
  Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force
  Write-Host "  [ok]   skill: $name"
}

if ($SkipRules) {
  Write-Host "Rules skipped (-SkipRules)."
} else {
  Get-ChildItem -LiteralPath $RulesSrc -Filter "*.mdc" -File | ForEach-Object {
    $dest = Join-Path $destRules $_.Name
    if ((Test-Path -LiteralPath $dest) -and -not $Force) {
      Write-Host "  [skip] rule:  $($_.Name) (exists, use -Force to replace)"
      return
    }
    Copy-Item -LiteralPath $_.FullName -Destination $dest -Force
    Write-Host "  [ok]   rule:  $($_.Name)"
  }
}

Write-Host "Done. Skills: $destSkills | Rules: $destRules"
