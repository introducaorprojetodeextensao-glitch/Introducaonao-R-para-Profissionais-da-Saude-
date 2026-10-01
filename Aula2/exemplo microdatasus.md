# exemplo microdatasus

# Mais fácil para aula - pelo próprio R (recomendado)
install.packages("microdatasus")
library(microdatasus)

#Baixa e já salva na pasta
fetch_datasus(
  year_start = 2023,
  year_end = 2023,
  uf = "PB",
  information_system = "SIM-DO"
)
#Ele baixa sozinho do FTP do #DATASUS. Não precisa de link.

#Link direto do governo - #OpenDataSUS

#1. Entra em: #https://opendatasus.saude.gov.br
#2. Pesquisa: `SIM` ou `SINASC`
#3. Clica em `SIM - Sistema de Informação sobre Mortalidade`
#4. Vai em `Recursos` > baixa o `.csv` ou `.dbc` por UF/ano

#Link direto do FTP antigo que o pacote usa:
#ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/


# Processa e padroniza os rótulos do SIM (converte códigos em textos compreensíveis)
dados_sim_pb <- process_sim(dados_sim_pb)

# Visualizar a base do DATASUS
glimpse(dados_sim_pb)
   
   
   
# 2. INSPEÇÃO  ---------------------------------------
dim(dados_sim_pb)       
names(dados_sim_pb)     
glimpse(dados_sim_pb)  
summary(dados_sim_pb$IDADE)  

# Quais variáveis mais importantes do SIM?
# DTÓBITO, SEXO, RACACOR, CODMUNRES, CAUSABAS, LINHAA, etc.

# 3. ORGANIZAÇÃO  -----------------------------------
# Agora sim, o código justo que faltava:

dados_sim_limpo <- dados_sim_pb |>
  janitor::clean_names() |> # padroniza tudo minúsculo
  select(
    # Identificação
    numerodo, tipobito, dtobito,
    # Pessoa
    sexo, racacor, idade, dtnasc,
    # Residência
    codmunres, codmunocor,
    # Causa
    causabas, linhai_a, linhai_b, linhai_c, linhai_d,
    # Outros
    escmae, ocup, natural
  ) |>
  rename(
    municipio_residencia = codmunres,
    municipio_ocorrencia = codmunocor,
    causa_basica = causabas,
    escolaridade_mae = escmae
  ) |>
  filter(
    !is.na(dtobito),          # desafio item 5 - filtrar população válida
    tipobito == "1"            # só óbitos não fetais
  ) |>
  mutate(
    dtobito = lubridate::dmy(dtobito),
    ano = lubridate::year(dtobito),
    mes = lubridate::month(dtobito),

    # desafio item 6 - criar categórica - ESSENCIAL EM SAÚDE
    faixa_etaria = case_when(
      idade < 1 ~ "Menor de 1 ano",
      idade >= 1 & idade < 10 ~ "1 a 9 anos",
      idade >= 10 & idade < 20 ~ "10 a 19 anos",
      idade >= 20 & idade < 60 ~ "20 a 59 anos",
      idade >= 60 ~ "60 ou mais",
      TRUE ~ NA_character_
    ),

    sexo_label = case_when(
      sexo == "Masculino" ~ "Masculino",
      sexo == "Feminino" ~ "Feminino",
      TRUE ~ "Ignorado"
    ),

    # Causa agrupada - exemplo SUS
    capitulo_cid = substr(causa_basica, 1, 1) # A,B = infecciosas, C,D = neoplasias, etc
  )

#  4.   ---------------------------------------

# Frequência simples
dados_sim_limpo |> count(sexo_label, sort = TRUE)

dados_sim_limpo |> count(faixa_etaria)

# Top 10 causas básicas na PB 2023
dados_sim_limpo |>
  count(causa_basica, sort = TRUE) |>
  head(10)

# Tabela cruzada - essencial para o curso principal
dados_sim_limpo |>
  group_by(faixa_etaria, sexo_label) |>
  summarise(
    total_obitos = n(),
    .groups = "drop"
  ) |>
  arrange(desc(total_obitos))

# Mortalidade por mês - para vigilância
dados_sim_limpo |>
  group_by(mes) |>
  summarise(total = n()) |>
  arrange(mes)

# 5. SALVAMENTO CORRIGIDO COM here() - item 8 ------------------------------

if(!dir.exists(here("resultados"))) dir.create(here("resultados"))

write_csv(dados_sim_limpo, here("resultados", "sim_pb_2023_organizado.csv"))
saveRDS(dados_sim_limpo, here("resultados", "sim_pb_2023_organizado.rds"))

# Também salva 

dados_sim_limpo |>
  select(municipio_residencia, sexo_label, faixa_etaria, causa_basica, dtobito) |>
  write_csv(here("resultados", "sim_pb_2023_recorte_encontro2.csv"))
