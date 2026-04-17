@echo off
REM Auto-commit - inicia o script PowerShell de monitoramento
REM Esse arquivo ativa o auto-commit automaticamente

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0auto-commit.ps1" -IntervalSeconds 30
pause
