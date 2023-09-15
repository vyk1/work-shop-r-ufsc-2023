
################################################# INTRODUÇÃO AO R #####################################################


####### - INDICAÇÃO https://www.youtube.com/@FernandaPeres/playlists
####### - https://cran.r-project.org/ - INSTALAÇÃO
####### - https://rstudio.com/products/rstudio/ - INSTALAÇÃO

#######################################################################################################################
######################## ###################### #### COMEÇANDO ### ########################### #######################

# SELECIONAR DIRETÓRIO

## 1º é necessário organizar seu ambiente de trabalho no R:
####### - Selecionar seu diretório (pasta de trabalho no seu pc)

setwd("/home/rstudio")

## Ou session > set working directory > choose directory

####### - Vamos criar uma pasta para o mini curso onde vamos colocar nossos dados

#######################################################################################################################

# INSTALAR E CARREGAR PACOTES

## 2º é necessário instalar ou carregar os pacotes necessários no R:
####### - vamos usar o pacote vegan e o pacote ggpubr

####### Para instalar:

install.packages("vegan")
install.packages("car")
install.packages("dplyr")
install.packages("ggpubr")

####### Para carregar os pacotes:

library(car)
library(vegan)
library(dplyr)
library(ggpubr)

#########################################################################################################################

# CARREGAR SEUS DADOS NO R

## 3º (mais crítico dos passos) carregar suas planilhas no R:
######## - É aconselhável ter seus dados salvos em .csv separado por vírgulas para facilitar a leitura do R

# arquivo csv no br: a vírgula é usada como decimal; por isso a personalização;
# se converter no hardcode, dará problema no excel (problema , e .)
dados <- read.table("Banco de Dados 2.csv", header = TRUE, sep = ";", dec = ",")
View(dados)

# fx glimpse informa o tipo de dado da coluna
glimpse(dados)

#######################################################################################################################

############################################# TESTE T PARA UMA AMOSTRA ################################################

# Vamos usar o banco de dados para testar se a média de altura dessa amostra é diferente da média nacional 1,67 m.

# VERIFICAÇÃO DA NORMALIDADE DOS DADOS (se for maior do que 0,05 está tudo ok)
## objeto$Propriedade(Coluna)
## a hipotese do shairo é que estão nao normais
## precisa-se que p seja maior que 0.05
shapiro.test(dados$Altura)

# FAZER O TEST T PROPRIAMENTE DITO (se for maior do que 0,05 as médias não são diferentes)
## teste t é nativo

t.test(dados$Altura, mu = 167)

## Geralmente para rabalho usa-se 3 casas decimais
######## O teste t para uma amostra mostrou que a média de altura da amostra (168,43 m) não é diferente 
## df grau de liverdade
######## da média nacional (1,67 m) (t(29) = 0,702; p = 0,488).
## portanto, valor de p não é significativo

boxplot(dados$Altura, ylab= "Altura (cm)")

# Linha de mediana (linha mais escura)
# Primeiro quartil
# Terceiro quartil
# Limite inferior (menor valor que tem se na amostra)
# Limite superior (maior valor ||)
# Outlier (não é sempre que aparece mas é a bolinha - valor discrepante)

## Dá para exportar como eps!

#####################################################################################################################

############################################ TESTE T PARA DUAS AMOSTRAS #############################################

# Será que a posição que o aluno senta na sala tem influência na nota que ele tem em biologia, física e história?

dados3 <- read.table("Banco de Dados 3.csv", header = TRUE, sep = ";", dec = ",")

# Verificação da normalidade dos dados
shapiro.test(dados3$Nota_Biol)
shapiro.test(dados3$Nota_Fis) # nota não normal
shapiro.test(dados3$Nota_Hist) # nota não normal

# Verificação da homogeneidade de variâncias
## precisa do dado numerico (nota) e dado de grupo (posição sala)
## tabmem precisa ser menor que 005
leveneTest(Nota_Biol ~ Posicao_Sala, dados3)
leveneTest(Nota_Fis ~ Posicao_Sala, dados3) # nao homo
leveneTest(Nota_Hist ~ Posicao_Sala, dados3) #  nao homo

# Realização do Teste t
t.test(Nota_Biol ~ Posicao_Sala, dados3, var.equal= T) # p significativo (diferença entre medias - não diz qual é mais alta ou mais baixa)
t.test(Nota_Fis ~ Posicao_Sala, dados3, var.equal= F) # nao homo e nao normal ||p
t.test(Nota_Hist ~ Posicao_Sala, dados3, var.equal= F) # nao homo e nao normal masp nçao sigfnicativo

# Visualização

par(mfrow=c(1,3)) # Quero os gráficos em uma linha e três colunas (todos na mesma imagem)
boxplot(Nota_Biol ~ Posicao_Sala, data = dados3, ylab = "Notas de Biologia", xlab = "Posição na Sala")
boxplot(Nota_Fis ~ Posicao_Sala, data = dados3, ylab = "Notas de Física", xlab = "Posição na Sala")
boxplot(Nota_Hist ~ Posicao_Sala, data = dados3, ylab = "Notas de História", xlab = "Posição na Sala")

# Podemos dizer então, por exemplo, que o teste-t para duas amostras independentes mostrou que há efeito da posição
# na sala de aula sobre a nota de física (t(17,68) = 4,44; p < 0,001). O grupo que senta na frente da sala apresentou,
# em média, notas superiores às do grupo que senta nos fundos da sala.

######################################################################################################################

################################################### ANOVA DE UMA VIA #################################################
## analise de variancia

dados5 <- read.table("Banco de Dados 5.csv", header = TRUE, sep = ";", dec = ",")

######### o Banco de dados 5 contém informações de 31 indivíduos tratados com placebo, um anti-hipertensivo já em uso
######### no mercado ou um anti-hipertensivo novo. Vamos verificar se há efeito do tratamento sobre a pressão e os
######### batimentos cardíacos.

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(car)) install.packages("car")  
library(car)                                
if(!require(psych)) install.packages("psych")
library(psych)                                
if(!require(rstatix)) install.packages("rstatix")
library(rstatix)                                
if(!require(DescTools)) install.packages("DescTools")
library(DescTools)

# Verificação da normalidade dos dados

shapiro.test(dados5$BC) # normais
shapiro.test(dados5$Pressao) # normais

# Verificação da homogeneidade de variâncias

leveneTest(BC ~ Grupo, dados5) # homo
leveneTest(Pressao ~ Grupo, dados5) # homo

# Verificação da existência de outliers

boxplot(BC ~ Grupo, data = dados5, ylab = "Frequência cardíaca (bps)", xlab = "Tratamento")
boxplot(Pressao ~ Grupo, data = dados5, ylab = "Pressão Arterial (mmHg)", xlab = "Tratamento")

# solução para os outliers:
## remove-los, 
## fazer Analise não parametrica
## fazer parametrica igual

# Realização da ANOVA

# Criação do modelo para BC
anova_BC <- aov(BC ~ Grupo, dados5)
summary(anova_BC) # resume existe diferença entre placebo e outro gp (valor de p)

# Criação do modelo para Pressão
anova_pressao <- aov(Pressao ~ Grupo, dados5)
summary(anova_pressao) # resume existe diferença entre placebo e outro gp (valor de p)

# Entre quais tratamentos há diferença na variância? - Análise post-hoc
# Uso do Pós teste de Tukey (não é tão conservador) mas tem o dunham (conservador)

## hsd é o teste de tukey
PostHocTest(anova_BC, method = "hsd", conf.level = 0.95)
PostHocTest(anova_pressao, method = "hsd", conf.level = 0.95)

############################### ANÁLISE DE VARIÂNCIAS NÃO-PARAMÉTRICO KRUSKAL-WALLIS ################################

kruskal_BC <- kruskal.test(BC ~ Grupo, dados5)
kruskal_pressao <- kruskal.test(Pressao ~ Grupo, dados5)

# Com um gráfico mais informativo:

my_comparisons <- list( c("AH Novo", "AH Padrão"), c("AH Padrão", "Placebo"), c("AH Novo", "Placebo"))

kruskal_boxplot_BC <- ggboxplot(dados5, x = "Grupo", y = "BC",
                                color = "Grupo", palette = "lancet",
                                add = "jitter", xlab = F, ylab = "Batimentos Cardíacos", width = 0.9)

kruskal_boxplot_BC + stat_compare_means(comparisons = my_comparisons) + font("y", size = 18, color = "black")+
  font("xy.text", size = 18, color = "black")

#####################################################################################################################

######################################## CORRELAÇÃO LINEAR PARAMÉTRICA ##############################################

dados10 <- read.csv("Banco de Dados 10.csv", header = TRUE, sep = ";", dec = ",")

# Verificação dos pressupostos para a correlação de Pearson

## Normalidade (Shapiro-Wilk)
shapiro.test(dados10$Ansiedade)
shapiro.test(dados10$Nota)

## Presença de outliers
boxplot(dados10$Ansiedade)
boxplot(dados10$Nota)

## Relação linear entre as variáveis
plot(dados10$Ansiedade, dados10$Nota)

## Não cumpriu com os pressupostos, mas vamos fazer para ver:

###### CORRELAÇÃO DE PEARSON
cor.test(dados10$Nota, dados10$Ansiedade, method = "pearson") # normais e homogeneos

###### CORRELAÇÃO DE SPEARMAN
cor.test(dados10$Nota, dados10$Ansiedade, method = "spearman") # correlacao nao parametrica

###### CORRELAÇÃO TAU DE KENDALL - PARA VALORES DE EMPATES OU N PEQUENO
cor.test(dados10$Nota, dados10$Ansiedade, method = "kendall")

dispersao_graf <-ggscatter(dados10, x = "Ansiedade", y = "Nota", conf.int = TRUE, palette = "lancet",
                           cor.coef = TRUE, cor.method = "spearman",
                           xlab = "Ansiedade pré-prova", ylab = "Desempenho na prova")
dispersao_graf + font("xy", size = 18, color = "black")+
  font("xy.text", size = 18, color = "black")

#####################################################################################################################

####################################### EXPORTAR DADOS ##############################################################

data("iris")
write.table(iris, file = "dados iris.csv", sep = ";", dec = ",", row.names = F)
novo<-read.csv("dados iris.csv", header = TRUE, sep = ";", dec = ",")
glimpse(novo)
