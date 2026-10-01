# ==============================================================================
# CURSO PREPARATÓRIO: INTRODUÇÃO AO R E RSTUDIO PARA ANÁLISE DE DADOS EM SAÚDE
# ENCONTRO 2: Importação, Inspeção e Organização Básica de Dados
# Coordenação: Profa. Dra. Érika Fialho e Prof. Dr. Cleanderson Fidelis
# ==============================================================================
#Pacotes Essenciais do Encontro tidyverse: Coleção de pacotes para manipulação e visualização de dados.
#tidyverse=Conjunto principal de pacotes para organização e análise.
#readr=Importação e exportação de arquivos CSV.
#readxl=Importação de planilhas Excel.
#dplyr=Seleção, filtragem, transformação e resumo.
#stringr=Tratamento de textos.
#lubridate=Tratamento de datas.
#janitor=Padronização de nomes e tabelas simples.
#here =Organização dos caminhos dos arquivos.

#O pacote microdatasus poderá ser apresentado brevemente no encerramento, mas sua
#instalação e utilização devem integrar o curso principal, quando serão discutidos o acesso, o
#download, o processamento e as particularidades dos diferentes sistemas de informação do SUS.
# ------------------------------------------------------------------------------
# 1. CARREGAMENTO DE PACOTES ESSENCIAIS
# ------------------------------------------------------------------------------
install.packages("tidyverse")
install.packages("readr") # Importação e exportação de CSV
library(readr)     
install.packages("readxl") # Importação de planilhas Excel
library(readxl)    
install.packages("dplyr")  # Manipulação e transformação de dados
library(dplyr)    
install.packages("stringr") # Tratamento de textos
library(stringr)   
install.packages("lubridate")  # Tratamento de datas
library(lubridate)
install.packages("janitor") # Padronização de nomes de colunas e tabelas simples
library(janitor)   
install.packages("here") # Gestão de caminhos relativos de arquivos
library(here)      

# ------------------------------------------------------------------------------
# 2. IMPORTAÇÃO DOS DADOS
# ------------------------------------------------------------------------------
# Importação do arquivo CSV padronizado do formulário
#dados_csv <- read_csv(here("dados", "exemplo_saude.csv"))

# Exemplo alternativo de importação direta de Excel:
#dados_excel <- read_excel(here("dados", "Google_forms_R.xlsx"), sheet = 1)
Google_forms_R <- read_excel("C:/Users/usar/Downloads/Google_forms_R.xlsx")
View(Google_forms_R)
# ------------------------------------------------------------------------------
# 3. INSPEÇÃO DA ESTRUTURA DA BASE
# ------------------------------------------------------------------------------
# Visualização da tabela interativa (descomente no RStudio)
# View(dados_excel)

head(Google_forms_R)       # Exibe as 6 primeiras linhas
names(Google_forms_R)      # Lista o nome de todas as colunas
dim(Google_forms_R)        # Retorna o número de linhas (observações) e colunas (variáveis)
str(Google_forms_R)        # Mostra a estrutura interna e tipos de dados
summary(Google_forms_R)    # Produz o resumo estatístico preliminar
glimpse(Google_forms_R)    # Visão rápida e compacta do dataframe (dplyr)
# ------------------------------------------------------------------------------
# 4. ORGANIZAÇÃO E TRANSFORMAÇÃO DE DADOS COM DPLYR
# ------------------------------------------------------------------------------
# 4.1. Padroniza os nomes longos da planilha para minúsculas e sem espaços/acentos
dados_limpos <- Google_forms_R |> 
  clean_names()

# 4.2. Executa a seleção, renomeação e criação de variáveis
dados_organizados <- dados_limpos |> 
  # Seleciona as variáveis ajustadas pelo janitor
  select(
    nome_completo, 
    ha_quantos_anos_voce_concluiu_o_ensino_medio, 
    com_qual_genero_voce_se_identifica, 
    voce_e_natural_de_campina_grande, 
    renda_mensal_aproximada_em_r
  ) |> 
  
  # Renomeia para nomes curtos e amigáveis
  rename(
    participante = nome_completo,
    anos_ensino_medio = ha_quantos_anos_voce_concluiu_o_ensino_medio,
    genero = com_qual_genero_voce_se_identifica,
    natural_campina_grande = voce_e_natural_de_campina_grande,
    renda = renda_mensal_aproximada_em_r
  ) |> 
  
  
class(dados_organizados$participante)
class(dados_organizados$anos_ensino_medio)
class(dados_organizados$natural_campina_grande)
class(dados_organizados$natural_campina_grande)
class(dados_organizados$renda) 

  # Filtra participantes que responderam o tempo de conclusão
  filter(!is.na(anos_ensino_medio)) |> 
  
  # Cria a variável categórica
  mutate(
    categoria_tempo_em = case_when(
      anos_ensino_medio < 10 ~ "Recente (< 10 anos)",
      anos_ensino_medio < 20 ~ "Intermediário (10–19 anos)",
      anos_ensino_medio >= 20 ~ "Veterano (20+ anos)",
      TRUE ~ NA_character_
    )
  )

# Visualizar o resultado final organizado
glimpse(dados_organizados)

# ------------------------------------------------------------------------------
# 5. RESUMOS DESCRITIVOS SIMPLES
# ------------------------------------------------------------------------------
# Contagem por gênero
dados_organizados |> 
  count(genero)

# Frequência absoluta da nova variável categórica
dados_organizados |> 
  count(categoria_tempo_em)

# Agrupamento e resumo estatístico da renda mensal por categoria de tempo
dados_organizados |> 
  group_by(categoria_tempo_em) |> 
  summarise(
    total_participantes = n(),
    renda_media = mean(renda, na.rm = TRUE),
    renda_mediana = median(renda, na.rm = TRUE)
  )

# ------------------------------------------------------------------------------
# 6. SALVAMENTO E EXPORTAÇÃO
# ------------------------------------------------------------------------------
# Garante que a pasta resultados existe no seu diretório
if(!dir.exists(here("resultados"))) dir.create(here("resultados"))

# Salvar a base organizada em formato CSV
write_csv(
  dados_organizados, 
  here("resultados", "dados_organizados.csv")
)

# Salvar a base organizada em formato nativo RDS
saveRDS(
  dados_organizados, 
  here("resultados", "dados_organizados.rds")
)

