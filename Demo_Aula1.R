# =============================================================
# Aula 1 - Primeiros Passos com R e RStudio
# Script de demonstracao do instrutor - programa de extensao UEPB


# --- Topico 1: Interface do RStudio -----------------------------
# Objetivo: preencher os 4 painéis, um de cada vez, so pra mostrar
# pra que serve cada um. Não precisa explicar o código em detalhe
# ainda -- isso vem nos próximos tópicos.
      
# 1) Console: roda e mostra resultado na hora
2 + 2

# 2) Environment: cria um objeto, aparece na gaveta
minha_primeira_variavel <- 10

# 3) Plots: gera um gráfico (R base, sem pacote nenhum -- ainda não
# instalamos nada nesse ponto da aula)
x <- 1:10
y <- x^2
plot(x, y, type = "b", pch = 19, col = "steelblue", lwd = 2,
     main = "Só um exemplo de gráfico")


# --- Topico 2: Projetos, pastas e scripts -----------------------
# Objetivo: mostrar que dá pra criar pastas direto pelo Console,
# sem precisar usar o mouse. Rode isso DEPOIS de já ter criado o projeto de
# exemplo pelo menu (File > New Project > New Directory).

dir.create("dados")
dir.create("scripts")
dir.create("resultados")

# Exemplo de comentário no topo de um script (mostrar, não precisa rodar):
# nome: (seu nome aqui)
# aula 1 - primeiros passos com R


# --- Topico 3: Objetos e tipos de dados --------------------------

idade <- 35
nome <- "Maria"
profissional_saude <- TRUE

class(idade)
class(nome)
class(profissional_saude)

# Comparação (operador de comparação)
idade > 18

# Valor ausente
peso <- NA
peso


# --- Topico 4: Vetores e funções ---------------------------------

idades <- c(23, 35, 41, 29, 50)

length(idades)
mean(idades)
median(idades)
min(idades)
max(idades)


# --- Topico 5: Pacotes --------------------------------------------
# Os install.packages() de tidyverse/readxl já rodaram lá no
# Topico 1 (truque de tempo). Aqui é só carregar.

library(tidyverse)
library(readxl)

# tidyverse já traz junto: readr, dplyr, stringr, lubridate.
# Só faltam esses dois para fechar a lista de pacotes essenciais
# do curso (o aluno instala e carrega estes dois no desafio dele):
# install.packages("janitor")
# install.packages("here")

