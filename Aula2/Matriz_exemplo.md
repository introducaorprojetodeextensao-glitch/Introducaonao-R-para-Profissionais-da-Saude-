# Matriz_exemplo
# Com os seus dados:

library(tidyverse)

dados <- data.frame(
  id = c(1, 2, 3, 4, 5),
  idade = c(9, 56, 28, 40, 50),
  sexo = c("F", "M", "M", "F", "M"),
  altura = c(120, 160, 190, 170, 155)
)




# Opção 2 - do jeito tidyverse (que a gente vai usar no curso)
dados <- tribble(
  ~id, ~idade, ~sexo, ~altura,
   1,   9,      "F",   120,
   2,   56,     "M",   160,
   3,   28,     "M",   190,
   4,   40,     "F",   170,
   5,   50,     "M",   155
)

dados # olha a tabela


# Quantas linhas? (pacientes)
nrow(dados)




# Quantas colunas? (variáveis)
ncol(dados)


Os dois de uma vez - linhas e colunas.
```
# Os dois de uma vez - linhas e colunas
dim(dados)
```


# Para ver tudo  (que vamos usar )

dim(dados) # no SIM com 50 mil linhas é essencial


# Do mais simples ao que # vamos usar no curso:
# 1. Jeito cifrão $ 

```
#Jeito cifrão $ 
dados$idade
[1] 9 56 28 40 50
```

# 2. Jeito colchete - pega como tabela (mantém o nome em cima)
```
#Jeito colchete - pega como #tabela (mantém o nome em #cima)
dados["idade"]
dados[, "idade"]
```

# 3. Jeito tidyverse - o que vamos usar da Aula 2 em diante

library(dplyr)
select(dados, idade)

# mais de uma coluna?

```
# mais de uma coluna?
select(dados, idade, altura)
select(dados, sexo, altura)
```

# Apagar coluna 
```
#  Só mostra (não salva)
select(dados, -altura)
```
# 2. Agora sim apaga e guarda no caderno
```
# 2. Agora sim apaga e guarda no caderno
dados <- select(dados, -altura)
```

# pronto, agora se você digitar dados, altura sumiu
dados.
