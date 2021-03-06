########################
### Faktoranalyse   ####
########################


## For mer dokumentasjon/tutorials - sjekk (evt. kan du google):
#https://cran.r-project.org/web/packages/psych/index.html

#install.packages("psych")
library(psych)
library(tidyverse)

## Start med samme data fra European Social Survey som i flernivå-scriptet
## Last ned fra data-mappen på github, lagre data i prosjektmappen din (working directory)
# og kjør følgende kode:

load("ess.rda")

## Ser på korrelasjoner mellom tillitsvariabler

korrel <- ess %>%
  select(trust_parl, trust_legalsys, trust_police, 
                      trust_politicians, trust_polparties, 
                      trust_eurparl, trust_unitednations) %>%
cor(, use = "complete.obs")
korrel



cor.plot(korrel, numbers = TRUE)
KMO(korrel) # Keyser-Meyer-Olkin, alle er godt over .5



## Induktivt valg av faktorer: principal component
trust_prin <- princomp(~., ess %>% 
                         select(trust_parl, trust_legalsys, trust_police, 
                                   trust_politicians, trust_polparties, 
                                   trust_eurparl, trust_unitednations),
                       scores = TRUE)

summary(trust_prin)
loadings(trust_prin)
screeplot(trust_prin, type = "lines")

## Vi velger antall faktorer, her 2, under 3.
trust_factor1 <- factanal(~., 2, ess %>% 
                            select(trust_parl, trust_legalsys, trust_police, 
                                   trust_politicians, trust_polparties, 
                                   trust_eurparl, trust_unitednations))
names(trust_factor1)
print(loadings(trust_factor1), cutoff = .5)

trust_factor2 <- factanal(~., 3, ess %>% 
                            select(trust_parl, trust_legalsys, trust_police, 
                                   trust_politicians, trust_polparties, 
                                   trust_eurparl, trust_unitednations))


print(loadings(trust_factor2), cutoff = .5)

## Rotasjon
varimax(loadings(trust_factor2), normalize = TRUE)
promax(loadings(trust_factor2))
oblimin(loadings(trust_factor2))
?oblimin

## Opprette additive indekser - eksempel (her finnes det mange muligheter - se pensum/forelesning):
ess$political_trust <- (ess$trust_parl + ess$trust_politicians + ess$trust_polparties) / 3
ess$legal_trust <- (ess$trust_legalsys + ess$trust_police) / 2
ess$international_trust <- (ess$trust_unitednations + ess$trust_eurparl) / 2



