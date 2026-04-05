#!/bin/bash

# ==============================================================================
# Script: mysql_backup_interativo.sh
# Descrição: Gera backup de banco de dados MySQL com opções de compactação.
# ==============================================================================

# Cores para saída (melhorar legibilidade)
VERDE='\033[0;32m'
VERMELHO='\033[0;31m'
AMARELO='\033[1;33m'
NC='\033[0m' # Sem Cor

echo -e "${AMARELO}=== Configuração de Backup MySQL Interativo ===${NC}\n"

# 1. Solicita informações do Servidor
read -p "🖥️  Digite o endereço do servidor MySQL [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost} # Define padrão se vazio

# 2. Solicita informações do Banco de Dados
while [ -z "$DB_NAME" ]; do
    read -p "🗄️  Digite o nome do banco de dados: " DB_NAME
done

# 3. Solicita credenciais
read -p "👤 Digite o usuário MySQL: " DB_USER

# Solicita a senha de forma segura (sem ecoar no terminal)
echo -n "🔑 Digite a senha MySQL: "
read -s DB_PASS
echo "" # Adiciona uma nova linha após a senha

# 4. Define o nome do arquivo de saída com data e hora
DATA_HORA=$(date +%Y-%m-%d_%Hh%M)
ARQUIVO_BASE="${DB_NAME}_backup_${DATA_HORA}"

# 5. Pergunta sobre compactação
echo -e "\n📦 Escolha o tipo de saída:"
echo "1) SQL Comum (.sql)"
echo "2) Compactado GZIP (.sql.gz) - [Recomendado]"
echo "3) Compactado BZIP2 (.sql.bz2)"
read -p "Selecione uma opção [1-3, padrão 2]: " OPCAO_COMP
OPCAO_COMP=${OPCAO_COMP:-2} # Define padrão se vazio

# Configura o comando e extensão final baseado na opção
case $OPCAO_COMP in
    1)
        EXTENSAO=".sql"
        COMANDO_FINAL="cat" # Não faz nada, apenas passa o stream
        ;;
    3)
        EXTENSAO=".sql.bz2"
        if ! command -v bzip2 &> /dev/null; then
            echo -e "${VERMELHO}Erro: bzip2 não instalado.${NC}"
            exit 1
        fi
        COMANDO_FINAL="bzip2"
        ;;
    2|*) # Padrão ou opção 2
        EXTENSAO=".sql.gz"
        COMANDO_FINAL="gzip"
        ;;
esac

NOME_FINAL="${ARQUIVO_BASE}${EXTENSAO}"

echo -e "\nIniciando backup de ${VERDE}$DB_NAME${NC} em ${VERDE}$DB_HOST${NC}..."
echo "O arquivo será salvo como: $NOME_FINAL"

# ==============================================================================
# Execução do Backup (Forma Segura)
# ==============================================================================

# Cria um arquivo de configuração temporário para passar a senha com segurança
# Isso evita que a senha apareça no comando 'ps'
TEMP_CNF=$(mktemp)
cat << EOF > "$TEMP_CNF"
[client]
host=$DB_HOST
user=$DB_USER
password=$DB_PASS
EOF

# Executa o mysqldump passando o arquivo de config temporário e o stream para o compactador
# Nota: --single-transaction é recomendado para bases InnoDB para não travar tabelas
mysqldump --defaults-extra-file="$TEMP_CNF" --single-transaction --routines --triggers "$DB_NAME" | $COMANDO_FINAL > "$NOME_FINAL"

# Captura o status da execução (especificamente do mysqldump)
STATUS=${PIPESTATUS[0]}

# Remove o arquivo temporário de senha imediatamente
rm -f "$TEMP_CNF"

# ==============================================================================
# Verificação
# ==============================================================================
if [ $STATUS -eq 0 ] && [ -s "$NOME_FINAL" ]; then
    TAMANHO=$(du -sh "$NOME_FINAL" | cut -f1)
    echo -e "\n${VERDE}✅ Sucesso!${NC}"
    echo "Arquivo gerado: $(pwd)/$NOME_FINAL ($TAMANHO)"
else
    echo -e "\n${VERMELHO}❌ Erro ao gerar o backup.${NC}"
    # Se o arquivo foi criado mas está vazio, remove
    [ -f "$NOME_FINAL" ] && rm "$NOME_FINAL"
    exit 1
fi
