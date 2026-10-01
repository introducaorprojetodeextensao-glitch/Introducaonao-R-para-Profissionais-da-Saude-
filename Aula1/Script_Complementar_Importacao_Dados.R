# =============================================================
# Script complementar - Importando e explorando dados em saúde no R
# Programa de Extensão em Ciência de Dados e IA para Profissionais
# da Saúde Pública - UEPB
#
# Este script é um conteúdo EXTRA, para reforçar sozinho(a) em casa.
# Ele mostra, do jeito mais simples possível, como importar dados de
# diferentes formatos (Excel, CSV e texto) e começar a explorá-los.
#
# Como reproduzir com seus próprios dados: troque o nome do arquivo
# nas linhas de leitura (read_excel/read.csv/read.delim) pelo caminho
# do seu arquivo, e troque os nomes das colunas nos exemplos abaixo
# pelos nomes das colunas do seu banco.
# =============================================================


# --- 0. De onde vêm estes dados? ----------------------------------
# Diferente do resto do curso (que usa exemplos fictícios), aqui
# usamos um dado REAL: o cadastro de Unidades Básicas de Saúde (UBS)
# do Brasil inteiro, baixado do Portal de Dados Abertos do SUS.
#
# Para baixar você mesmo(a):
#   1. Acesse https://dadosabertos.saude.gov.br/dataset
#   2. Use o filtro "Formatos" na lateral e escolha CSV
#   3. Procure o conjunto "Unidades Básicas de Saúde (UBS)"
#   4. Baixe o arquivo .zip e extraia o .csv
#
# O processo de importação no R é sempre o mesmo, seja qual for a
# base que você baixar -- só muda o nome do arquivo.


# --- 1. Pacotes necessários --------------------------------------

library(readxl)   # importar .xlsx
library(dplyr)    # select(), filter(), count() etc.


# --- 2. Importando os três formatos -------------------------------

# 2.1) Excel (.xlsx)
dados_xlsx <- read_excel("dados/ubs_brasil.xlsx")

# 2.2) CSV -- separado por vírgula (padrão internacional)
dados_csv <- read.csv("dados/ubs_brasil.csv")

# 2.3) Texto -- separado por ponto e vírgula (;)
dados_txt <- read.delim("dados/ubs_brasil.txt", sep = ";")

# Os três carregam os MESMOS dados -- só o formato do arquivo muda.
# Daqui em diante, vamos trabalhar só com um deles:

dados <- dados_csv


# --- 3. Organizando em um data.frame -------------------------------
# Um data.frame é a "tabela" do R: linhas são observações (no nosso
# caso, cada UBS cadastrada), colunas são variáveis.

class(dados)
dim(dados)  # número de linhas e colunas


# --- 4. Visualizando as primeiras linhas ---------------------------

head(dados)


# --- 5. Nomes das variáveis (colunas) -------------------------------

names(dados)

# CNES = código do estabelecimento | UF = código do estado (IBGE) |
# IBGE = código do município | NOME/LOGRADOURO/BAIRRO = endereço |
# LATITUDE/LONGITUDE = localização geográfica


# --- 6. Estrutura e tipo de cada variável ----------------------------

str(dados)

class(dados$UF)
class(dados$LATITUDE)


# --- 7. Variáveis qualitativas x quantitativas -----------------------
# Olhando as colunas deste banco:
#
#   - "UF", "NOME", "LOGRADOURO" e "BAIRRO" são QUALITATIVAS (ou
#     categóricas): descrevem uma característica, não um número que
#     se soma ou tira média (mesmo "UF" sendo um código numérico, ele
#     representa uma categoria -- o estado -- não uma quantidade).
#
#   - "LATITUDE" e "LONGITUDE" são QUANTITATIVAS CONTÍNUAS: números
#     que podem assumir qualquer valor dentro de um intervalo.
#
# Este banco em particular não tem uma variável quantitativa
# DISCRETA natural (um exemplo seria "número de leitos" ou "número
# de profissionais", se essas colunas existissem). Nem todo banco de
# dados vai ter os três tipos -- tudo bem.


# --- 8. Selecionando uma ou duas variáveis para uma análise inicial ---

dados_selecionados <- dados %>%
  select(UF, LATITUDE)

head(dados_selecionados)


# --- 9. Medida simples para uma variável numérica ----------------------
# Repare no na.rm = TRUE: como algumas UBS não têm coordenada
# cadastrada (valores NA), precisamos avisar ao R para ignorá-los no
# cálculo -- senão o resultado também vira NA.

mean(dados$LATITUDE, na.rm = TRUE)
median(dados$LATITUDE, na.rm = TRUE)


# --- 10. Frequência de uma variável qualitativa --------------------------

table(dados$UF)

# O mesmo resultado, em um formato de tabela um pouco mais organizado,
# do maior para o menor:
dados %>%
  count(UF, sort = TRUE)


# --- 11. Bônus: focando em um estado específico -----------------------
# A função filter() (que vamos usar bastante na próxima aula) permite
# isolar só as linhas que você quer. Exemplo: só as UBS da Paraíba
# (código IBGE do estado = 25):

dados_pb <- dados %>%
  filter(UF == 25)

nrow(dados_pb)
head(dados_pb)


# =============================================================
# Fim. Se quiser praticar: troque "LATITUDE" por "LONGITUDE" no
# passo 9, ou troque o código 25 pelo código de outro estado no
# passo 11, e veja como os resultados mudam.
# =============================================================
