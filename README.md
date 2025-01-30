# ProPedidos

## Descrição do Projeto
O **ProPedidos** é um sistema desenvolvido para gestão de pedidos, utilizando MySQL como banco de dados. O projeto faz uso da biblioteca **libmysql.dll** para conexão com o banco de dados e depende de um arquivo de configuração `config.ini` para armazenar as informações de conexão.

## Estrutura do Projeto

- **ProPedidos.exe**: Executável principal do sistema.
- **libmysql.dll**: Biblioteca necessária para conexão com o MySQL.
- **config.ini**: Arquivo de configuração contendo os dados de conexão ao banco de dados.
- **SQL/**: Pasta contendo os scripts `.sql` para criação das tabelas e inserção de novos campos no banco de dados.

## Dependências
Para o correto funcionamento do sistema, os seguintes arquivos devem estar na **mesma pasta** que o executável `ProPedidos.exe`:

- `libmysql.dll`
- `config.ini`

Caso algum desses arquivos esteja ausente, o sistema pode apresentar falhas ao tentar conectar ao banco de dados.

## Configuração do `config.ini`
O arquivo `config.ini` é essencial para definir as informações de conexão ao banco de dados. Ele deve conter as seguintes configurações:

```ini
[Database]
Database=pedidos_db
Username=root
Server=localhost
Port=3306 
Password=xxxx 
CaminhoDll=libmysql.dll  
```

## Como Utilizar os Scripts SQL
Os scripts para criação e modificação do banco de dados estão localizados na pasta `SQL`. Para aplicar as alterações, siga os seguintes passos:

1. Abra um cliente MySQL como **MySQL Workbench** ou utilize o terminal.
2. Execute os scripts `.sql` na ordem necessária.

## Contato
Caso tenha dúvidas ou precise de suporte, entre em contato.

---
**Desenvolvido por [Asiel Aldana Ortíz]**
