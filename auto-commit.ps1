# Auto-commit script - monitora mudanças e faz commit + push automaticamente
# Uso: powershell -File auto-commit.ps1

param(
    [int]$IntervalSeconds = 30
)

$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoPath

Write-Host "🚀 Auto-commit iniciado para: $repoPath" -ForegroundColor Green
Write-Host "⏱️  Intervalo de verificação: ${IntervalSeconds}s" -ForegroundColor Cyan
Write-Host "📌 Pressione CTRL+C para parar`n" -ForegroundColor Yellow

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.Filter = "*.html"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$lastCommitTime = Get-Date
$debounceSeconds = 5

$onChanged = {
    param($source, $eventArgs)
    
    $now = Get-Date
    $elapsed = ($now - $lastCommitTime).TotalSeconds
    
    if ($elapsed -lt $debounceSeconds) {
        return
    }
    
    $file = $eventArgs.Name
    Write-Host "✏️  Mudança detectada: $file" -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2  # Aguarda conclusão da escrita
    
    try {
        $status = git status --porcelain
        if ($status) {
            git add $file 2>$null
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            git commit -m "auto: atualização em $timestamp"
            git push
            
            Write-Host "✅ Commit e push realizados" -ForegroundColor Green
            $lastCommitTime = $now
        }
    }
    catch {
        Write-Host "❌ Erro: $_" -ForegroundColor Red
    }
}

Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $onChanged | Out-Null

while ($true) {
    Start-Sleep -Seconds $IntervalSeconds
}
