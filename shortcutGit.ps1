# Hanya untuk sesi ini
if (Test-Path Alias:gc) { Remove-Item Alias:gc -Force }  # hindari bentrok Get-Content

function ga { git add . }

function gpul { git pull }

function gs { git status }

function gc {
  param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Message)
  git commit -m ($Message -join ' ')
}

function gca {
  param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Message)
  git commit --amend -m ($Message -join ' ')
}

function gpush { git push }

function gpf { git push --force-with-lease }

# opsional: add+commit sekaligus
function gac {
  param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Message)
  git add .
  git commit -m ($Message -join ' ')
}

Write-Host "Loaded: ga, gc, gca, gpush, gpf, gs, gac, gpul"
