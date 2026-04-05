
# 🚀 Projeto CamposDB

Sistema de gerenciamento de banco de dados local para controle de escopos, locadores e acompanhamento de negociações. Este projeto foca em portabilidade, segurança básica e automação de backups.

---

## 🐧 Guia para Linux (Ubuntu & Derivados)

### 0. Instalação e Hardening
```bash
# 1. Atualizar repositórios
sudo apt update && sudo apt upgrade -y

# 2. Instalar MySQL Server
sudo apt install mysql-server -y

# 3. Verificar status
sudo systemctl status mysql

# 4. Segurança (IMPORTANTE)
sudo mysql_secure_installation
```

### 1. Acesso ao Servidor
Para acesso direto no servidor (Local):
```bash
sudo mysql -u root -p
```
> **Dica:** Para hosts remotos, adicione `-h nome_servidor` ao comando.

---

## 🏗️ Estrutura do Banco de Dados

### 2. Criar Schema e Tabela
```sql
CREATE DATABASE camposdb 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE camposdb;

CREATE TABLE tblCampos (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  Escopo VARCHAR(100),
  Proximo_Contato DATETIME,
  Sigla VARCHAR(20),
  Locador_Contato VARCHAR(200),
  Historico TEXT,
  SAP VARCHAR(50),
  Tipo_Negociacao VARCHAR(100),
  Movimentacao VARCHAR(50),
  Inicio DATETIME,
  Termino DATETIME,
  Intervalo_Dias INT,
  Fly_Conecta BOOLEAN DEFAULT FALSE,
  Solicitacao_QA VARCHAR(200),
  Locador VARCHAR(200),
  CPF VARCHAR(20),
  CNPJ VARCHAR(20),
  Anotacoes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;
```

### 3. Gestão de Usuários (Controle de Acesso)
Criar usuário de aplicação com permissões CRUD:
```sql
CREATE USER 'paulo_roberto'@'%' IDENTIFIED BY 'CamposDB1!';

GRANT SELECT, INSERT, UPDATE, DELETE 
ON camposdb.* TO 'paulo_roberto'@'%';

FLUSH PRIVILEGES;
```

---

## 📝 Operações Diárias (Templates)

### 4. Inserção de Dados (INSERT)
```sql
INSERT INTO tblCampos (
  Escopo, Proximo_Contato, Sigla, Locador_Contato, 
  Historico, SAP, Tipo_Negociacao, Inicio, Termino,
  Locador, CPF, CNPJ, Anotacoes
) VALUES (
  'Exemplo Escopo', '2026-03-30 10:00:00', 'ABC', 'João Silva',
  'Histórico detalhado...', 'SAP12345', 'Negociação Inicial', 
  '2026-03-23 09:00:00', '2026-03-23 11:00:00',
  'João Silva LTDA', '123.456.789-00', '12.345.678/0001-99', 'Anotações adicionais'
);
```

### 5. View de Acompanhamento
Otimizada para visualização rápida de status:
```sql
CREATE VIEW vwCamposResumo AS
SELECT 
  ID, Escopo, Locador, Proximo_Contato,
  CASE 
    WHEN Fly_Conecta THEN '✅ Conectado'
    WHEN Locador IS NOT NULL THEN '✅ Cadastro OK'
    ELSE '⏳ Pendente'
  END AS Status,
  Inicio, Termino
FROM tblCampos;

-- Uso:
SELECT * FROM vwCamposResumo WHERE Proximo_Contato <= NOW() + INTERVAL 7 DAY;
```

---

## 💾 Backup e Automação

### Linux (Bash + Cron)
Crie o script `~/backup_camposdb.sh`:
```bash
#!/bin/bash
DATA=$(date +%F)
DESTINO="$HOME/backups"
mkdir -p $DESTINO

mysqldump -u root -p camposdb --single-transaction --routines --triggers > $DESTINO/camposdb_$DATA.sql
```

**Agendamento (Crontab):**
```text
0 2 * * * /home/$USER/backup_camposdb.sh
```

---

## 🪟 Guia para Windows 11

### Fase 1: Instalação
1. Baixe o [MySQL Installer](https://dev.mysql.com/downloads/installer/).
2. Escolha **"Server Only"** ou **"Developer Default"**.
3. Configure a porta `3306` e defina a senha do Root.

### Fase 2: Backup Automatizado (PowerShell)
Crie o arquivo `Backup-CamposDB.ps1`:
```powershell
$Data = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BackupDir = "C:\Backups\MySQL\"
$DumpFile = "$BackupDir\camposdb_$Data.sql"

New-Item -ItemType Directory -Force -Path $BackupDir

& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" `
  -u root -pSuaSenha `
  --single-transaction --routines camposdb `
  | Out-File -FilePath $DumpFile -Encoding UTF8
```

---

## ✅ Resumo do Workflow
| Recurso | Descrição |
| :--- | :--- |
| **Segurança** | Usuário `paulo_roberto` limitado ao banco `camposdb`. |
| **Visualização** | Utilização da View `vwCamposResumo` para filtros rápidos. |
| **Backup** | Automatizado via Cron (Linux) ou Task Scheduler (Windows). |
| **Ferramentas** | Compatível com MySQL Workbench e CLI. |

---
**Desenvolvido para gerenciamento local de dados.** 🚀
