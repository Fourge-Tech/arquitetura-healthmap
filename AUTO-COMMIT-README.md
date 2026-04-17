# 🔄 Auto-Commit Setup

Configuração para **commit e push automáticos** ao salvar arquivos no repositório.

## ⚡ Como usar

### **Opção 1: Duplo-clique (mais fácil)**
1. Na pasta do repositório, abra o arquivo `start-auto-commit.bat`
2. Uma janela PowerShell vai abrir monitorando mudanças
3. Salve qualquer arquivo `.html` e ele fará auto-commit + push automaticamente

### **Opção 2: Terminal (manual)**
```powershell
cd c:\Users\Pichau\source\repos\arquitetura-healthmap
powershell -ExecutionPolicy Bypass -File .\auto-commit.ps1
```

## 🎯 O que acontece

- ✅ Monitora mudanças em arquivos `.html`
- ✅ Aguarda 5 segundos após a última mudança (debounce)
- ✅ Faz `git add` do arquivo
- ✅ Faz `git commit` com timestamp
- ✅ Faz `git push` para origin/main
- ✅ Mostra status em tempo real no terminal

## ⏹️ Como parar

Pressione **CTRL+C** na janela do PowerShell

## 🔧 Customizar intervalo

Se quiser verificar mudanças a cada 60 segundos (ao invés de 30):
```powershell
powershell -ExecutionPolicy Bypass -File .\auto-commit.ps1 -IntervalSeconds 60
```

## ⚠️ Notas

- Funciona apenas com arquivos `.html` no diretório raiz
- Não commitará arquivos não-rastreados (untracked files)
- Recomendado deixar rodando enquanto estiver editando documentos

---

**Status:** ✅ Pronto para usar
