 
---

# 📌 CamposDB - Inserção de Registros via Bash + MySQL

Script interativo em Bash para inserção de registros na tabela `tblCampos` do banco **MySQL**, com validações básicas, entrada guiada e tratamento de dados.

---

## 🚀 Objetivo

Facilitar a inserção de dados no banco **CamposDB**, eliminando a necessidade de comandos SQL manuais e reduzindo erros operacionais.

---

## ⚙️ Funcionalidades

* 🔐 Autenticação segura (usuário + senha via prompt)
* 🔍 Teste automático de conexão com MySQL
* 🧾 Entrada de dados guiada e amigável
* 📅 Datas automáticas (ex: próximo contato +7 dias)
* 📝 Campos multilinha (Histórico e Anotações)
* 🛡️ Tratamento de strings (escape de aspas simples)
* ✅ Confirmação antes da inserção
* 🆔 Retorno do `LAST_INSERT_ID()`

---

## 🧱 Estrutura da Tabela (esperada)

A tabela `tblCampos` deve conter os seguintes campos:

```sql
Escopo
Proximo_Contato
Sigla
Locador_Contato
Locador
CPF
CNPJ
Tipo_Negociacao
Inicio
Termino
Telefones
Email
SAP
Solicitacao_QA
Historico
Anotacoes
```

---

## 📥 Como usar

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/camposdb-script.git
cd camposdb-script
```

### 2. Dar permissão de execução

```bash
chmod +x campos_insert_v3.sh
```

### 3. Executar o script

```bash
./campos_insert_v3.sh
```

---

## 💡 Fluxo de Execução

![Image](https://images.openai.com/static-rsc-4/KlnWgjjCzWd6fhBKerJY3db-W1JKmJkP1j1LAh8K0HiqxnpfU1XeiL4FNFqNXHgDu9yxTSeUtnRsdVbgZhlDRIGCNHS8PwGM46cADupsUiOTihJv2o4HlDyaxs6KAqrRSNBRk5XKf5qF7bky_-OtId77q1TRZ_FLTlHf5Dup9rY3isMmsj2uEddfNRIX9qKb?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/6hDq9wnkHhifTMkKRR3FW0vMD9Zpgh4Zt3VrK0S8E2B4RNq-tYCEq_IcjgVhG433QcXL6fFjkx9nsqwy0I5d4n4_BUdGFYDW8zO4-br1tlnVoWvRJ9JWJgfTKVFBJsio2hO4l2Mdy9liY-iljtjq94cIH1JszXu_0uWw1t1eku4ocf1hDqx-JW7B-KHcFHl9?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/GkI2BoxD29jE8WoiV4bEh5sbh4v25IlojRd7p88zKJHZ-v9iZSDJF2-ZNtM37J_vsBUhgTrFSWcZpkntIF5uRTB4cnBOMa4PXz4S0QYczHlnDnzqdEIdYYnhzWn14GNmeznpAvY5HJc4kCGz2rbTD4eiGsUACg3sJe5umei1sQy4gLGl7VRTDGS_STKL7hNZ?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/6op8K0jAC7F_8kSkV0wnW6K65Ve20bMXzCpr30nbxwoyg9scRcosAxZJHaSBxcO_J-O9Jj-PyX1s12E0PlOljYKLeehcVBhQlC38s3ZIxQAGm-wChFPcAcwZj9yRd--wYiq_hoGBgEca0qFZp9Wvyx0WAaG9oCrP0XrCqR7MRYlh0nUgXcavjBJhS4yd60Nr?purpose=fullsize)

![Image](https://images.openai.com/static-rsc-4/u2xC0-s_vkHrQ4PtHt5rL6zwbzTht-chYvVoc0IEQ4VxgEUVtfFr99HPpfzJ06y4iRnW1HzUG4uqQjoZ70ABaQRvwXziKZbv8zivDw5Tabun6OKXITTiuFYEvXFw6nbnm8l-kGuEVr9plglltGb_gnO2gClwU5Z0CAmA2vNNLxdJPxwvsWkJSaQZETSG9S30?purpose=fullsize)

1. Usuário informa credenciais MySQL
2. Script valida conexão
3. Usuário preenche os dados do registro
4. Confirmação da operação
5. Inserção no banco
6. Retorno do ID gerado

---

## ⚠️ Pré-requisitos

* Linux / WSL / MacOS
* MySQL Client instalado (`mysql`)
* Acesso ao banco de dados
* Permissão de INSERT na tabela

---

## 🛡️ Boas práticas aplicadas

* Uso de `MYSQL_PWD` para evitar exposição direta da senha no comando
* Validação de conexão antes da execução
* Escape de caracteres especiais (`sed`)
* Campos obrigatórios com validação (`while`)
* Valores padrão para evitar falhas

---

## 📌 Possíveis melhorias (roadmap)

* [ ] Uso de `.env` para credenciais
* [ ] Log de inserções
* [ ] Validação de CPF/CNPJ
* [ ] Menu interativo (CRUD completo)
* [ ] Exportação para CSV/relatórios
* [ ] Dockerização do ambiente

---

## 👨‍💻 Autor

**David Lima**
Especialista em Banco de Dados | Oracle & MySQL | Suporte N2/N3

---

## 📄 Licença

Este projeto está sob a licença MIT. Sinta-se livre para usar e modificar.

---

 
