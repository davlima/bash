#!/bin/bash

# Solicita ao usuário o nome do arquivo
echo "Digite o nome da base:"
read arquivo

# Solicita ao usuário a data no formato DD-MM-AAAA
echo "Digite a data no formato DD-MM-AAAA:"
read data

# Monta o nome completo do arquivo com a data
nome_completo="${arquivo}-${data}.dmp.bz2"

# Cria o diretório de destino com o formato mysqlcorp-DD-MM-YYYY
diretorio_destino="MySQLcorp-${data}"

# Cria o diretório de destino se ele não existir
mkdir -p "$diretorio_destino"

# Cria o diretório de origem com o mesmo formato
diretorio_origem="mysqlcorp-$data"

# Muda para o diretório de destino
cd "$diretorio_destino"

# Executa o comando SCP para transferir o arquivo do diretório de origem
sudo scp dba@10.255.250.10:/backup/spool/"$diretorio_origem"/"$nome_completo" .

# Verifica se a transferência foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Arquivo $nome_completo transferido com sucesso!"
else
    echo "Erro ao transferir o arquivo $nome_completo."
fi

