# Desafio Final 
De onde vêm estes dados
 Diferente do resto do curso (que usa exemplos fictícios), aqui
 usamos um dado REAL: o cadastro de Unidades Básicas de Saúde (UBS)
do Brasil inteiro, baixado do Portal de Dados Abertos do SUS.
Para baixar você mesmo(a):
#### 1. Acesse https://dadosabertos.saude.gov.br/dataset
### 2. Use o filtro "Formatos" na lateral e escolha CSV
### 3. Procure o conjunto "Unidades Básicas de Saúde (UBS)"
### 4. Baixe o arquivo .zip e extraia o .csv
 O processo de importação no R é sempre o mesmo, seja qual for a base que você baixar  só muda o nome do arquivo.

```
#Desafio Final 
# 1. importar
dados <- read_csv(here("dados", "Mortalidade_Geral_2026.csv"))

# 2. dimensões
dim(dados)

# 3. nomes e tipos
names(dados)
glimpse(dados)

# 4. selecionar
dados_sel <- dados |> select(id, idade, sexo, municipio, desfecho)

# 5. filtrar
dados_sel <- dados_sel |> filter(idade >= 18)

# 6. criar categórica
dados_sel <- dados_sel |> 
  mutate(faixa_etaria = case_when(
    idade < 30 ~ "18-29",
    idade < 60 ~ "30-59",
    idade >= 60 ~ "60 ou mais",
    TRUE ~ NA_character_
  ))

# 7. frequências
dados_sel |> count(sexo)
dados_sel |> count(faixa_etaria)

# 8. salvar - CORRIGIDO com here()
write_csv(dados_sel, here("resultados", "dados_organizados.csv"))
saveRDS(dados_sel, here("resultados", "dados_organizados.rds"))

```