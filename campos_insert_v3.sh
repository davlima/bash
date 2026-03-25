#!/bin/bash
# campos_insert_v3.sh

clear
echo "=== ➕ INSERIR NOVO REGISTRO CAMPOSDB ==="
echo "========================================="

# Credenciais
read -p "👤 Usuário MySQL: " USER
read -s -p "🔑 Senha MySQL: " PASS
echo
read -p "🖥️ Host [localhost]: " HOST
HOST=${HOST:-localhost}

read -p "🗄️ Banco [camposdb]: " DB
DB=${DB:-camposdb}

# Teste de conexão
MYSQL_PWD="$PASS" mysql -h"$HOST" -u"$USER" -e "SELECT 1;" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Falha na conexão com MySQL. Verifique usuário/senha."
  exit 1
fi

# Entrada de dados
while [ -z "$escopo" ]; do
  read -p "📋 Escopo: " escopo
done

read -p "📅 Próximo Contato (YYYY-MM-DD HH:MM) [Enter=+7 dias]: " proximo
[ -z "$proximo" ] && proximo=$(date -d "+7 days" '+%Y-%m-%d %H:%M:%S')

read -p "🏷️  Sigla: " sigla
[ -z "$sigla" ] && sigla="N/A"

while [ -z "$locador_contato" ]; do
  read -p "👤 Locador/Contato: " locador_contato
done

while [ -z "$locador" ]; do
  read -p "🏢 Locador: " locador
done

read -p "👛 CPF: " cpf
read -p "🏛️  CNPJ: " cnpj

read -p "🤝 Tipo Negociação: " tipo_neg
[ -z "$tipo_neg" ] && tipo_neg="Não especificado"

read -p "🕐 Início (YYYY-MM-DD HH:MM) [Enter=agora]: " inicio
[ -z "$inicio" ] && inicio=$(date '+%Y-%m-%d %H:%M:%S')

read -p "🕛 Término (YYYY-MM-DD HH:MM) [Enter=pular]: " termino

read -p "📱 Telefones: " telefones
read -p "✉️  Email: " email

read -p "💼 SAP: " sap
read -p "📝 Solicitação QA: " solicitacao_qa

echo -e "\n📝 Histórico (linha vazia para finalizar):"
historico=""
while true; do
  read -r linha
  [ -z "$linha" ] && break
  historico+="$linha\n"
done

echo -e "\n📌 Anotações (linha vazia para finalizar):"
anotacoes=""
while true; do
  read -r linha
  [ -z "$linha" ] && break
  anotacoes+="$linha\n"
done

clear
echo "=== ✅ CONFIRMAR REGISTRO ==="
echo "Escopo: $escopo"
echo "Locador/Contato: $locador_contato"
echo "Locador: $locador"
echo "Próximo Contato: $proximo"

read -p $'\n👆 Confirmar inserção? [s/N]: ' confirm

if [[ $confirm =~ ^[Ss]$ ]]; then

  historico_escaped=$(printf "%s" "$historico" | sed "s/'/''/g")
  anotacoes_escaped=$(printf "%s" "$anotacoes" | sed "s/'/''/g")

  termino_sql="NULL"
  [ -n "$termino" ] && termino_sql="'$termino'"

  RESULT=$(MYSQL_PWD="$PASS" mysql -h"$HOST" -u"$USER" "$DB" -N -e "
  INSERT INTO tblCampos (
    Escopo, Proximo_Contato, Sigla, Locador_Contato, Locador,
    CPF, CNPJ, Tipo_Negociacao, Inicio, Termino,
    Telefones, Email, SAP, Solicitacao_QA, Historico, Anotacoes
  ) VALUES (
    '$escopo', '$proximo', '$sigla', '$locador_contato', '$locador',
    '${cpf:-}', '${cnpj:-}', '$tipo_neg', '$inicio', $termino_sql,
    '${telefones:-}', '${email:-}', '${sap:-}', '${solicitacao_qa:-}',
    '$historico_escaped', '$anotacoes_escaped'
  );
  SELECT LAST_INSERT_ID();
  ")

  ID=$(echo "$RESULT" | tail -n1)

  if [ -n "$ID" ]; then
    echo -e "\n✅ SUCESSO! Registro inserido com ID: $ID"
  else
    echo -e "\n❌ ERRO ao inserir registro."
  fi

else
  echo "❌ Operação cancelada."
fi
