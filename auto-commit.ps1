param([int]$IntervalSeconds = 30)

$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoPath

Write-Host "Auto-commit iniciado" -ForegroundColor Green
Write-Host "Pressione CTRL+C para parar" -ForegroundColor Yellow

while ($true) {
    Start-Sleep -Seconds $IntervalSeconds
    
    $status = git status --porcelain
    if ($status) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git add -A
        git commit -m "auto: update $timestamp"
        git push
        Write-Host "[$($timestamp)] Commit e push realizado" -ForegroundColor Green
    }
}
