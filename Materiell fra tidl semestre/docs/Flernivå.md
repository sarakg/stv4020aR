Flernivåanalyse
================
Erlend Langørgen
23 9 2019

## Flernivåanalyse

Den statistiske motivasjonen bak flernivåanalyse er å ta hensyn til
avhengighet mellom observasjoner i en hierarkisk struktur. *I R:* Som de
andre regresjonsformene vi har sett på, ligner syntaksen for
flernivåanalyse på syntaksen for ols. Den største forskjellen ligger i
spesifisering av nivå for variabler. Hensikten med dette dokumentet er å
hjelpe deg til å forstå hvordan du kan oversette teorien fra
forelesning/pensum om variabler på ulike nivå til R-syntaks i `lmer()`
funksjonen fra pakken `lme4`. Dersom du ikke helt forstår hva som skjer
i flernivå-scriptet, vil forhåpentligvis dette dokumentet være til
hjelp, og vice versa. Installer og last inn `lme4` med koden under.

``` r
install.packages("lme4")
library(lme4)
```

Under finner dere syntaksen for flernivå med samme notasjon som på
forelesning, oversatt til `lmer`. Jeg bruker `group_var` for å betegne
variabelen som forteller hvilken gruppe observasjoner tilhører (den
hierarkiske strukturen). `x` refererer til variabler på nivå 1, mens `z`
referer til variabler på nivå 2 (skiller mellom z og x for å gjøre det
lettere og oversette til **R**).

**Lineær Regresjon:**
\[Y_i = \beta_0 + \beta_1 X_{1i} + \beta_2 X_{2i} + e_i\] `lmer(y ~
(1|group_var), data = data)` **Flernivå med kun random intercept:**
\[Y_i = \beta_{0} + u_{0j} + e_{ij}\] `lmer(y ~ 1 + (1|group_var))`

**Flernivå med uavh. var på mikronivå, fixed effects, random
intercept:** \[Y_i = \beta_{0} + \beta_{1}X_{1ij} +  u_{0j} + e_{ij}\]
`lmer(y ~ (1|group_var) + x1, data = data)` **Flernivå med uavh. var på
mikronivå, random slopes:**
\[Y_i = \beta_{0} + \beta_{1}X_{1ij} + u_{1j}X_{1ij} + u_{0j} +  e_{ij}\]
`lmer(y ~ x1 + (x1|group_var), data=data)`

**Flernivå med uavh. var på mikronivå med random effects, og uavhengig
variabel på makronivå:**
\[Y_i = \beta_{0} + \beta_{1}X_{1ij} + \beta_{2j} Z_{2j} + + u_{1j}X_{1ij} + u_{0j} + e_{ij}\]
`lmer(y ~ x1 + (x1|group_var) + z2, data=data)`

**Flernivå med uavh. var på mikronivå med random effects,
kryssnivåsamspill, og uavhengig variabel på makronivå:**
\[Y_i = \beta_{0} + \beta_{1}X_{1ij} + \beta_{2j}Z_{2j} + \beta_{3}X_{1ij}Z_{2j} + + u_{1j}X_{1ij} + u_{0j} + e_{ij}\]
`lmer(y ~ x1*z2 + x1 + (x1|group_var) + z2, data=data)`

Som dere kanskje husker, kan vi bruke modellen med kun random intercept
til å beregne intra-class correlation. For å gjøre dette deler vi
varians på nivå 2 på summen av varians på nivå en og nivå 2:

\[var(u_j)/(var(u_j) + var(e_{ij}))\]

Dersom vi har brukt `lmer()` til å kjøre en flernivåmodell med kun
random intercept, får vi outputen vi trenger til å regne ut ICC etter
denne formelen med `summary()`. Vi kan også bruke `VarCorr(model,
comp=`Variance`)`. Dere kan hente ut random slopes/intercepts med
`ranef()`, mens faste effekter kan hentes ut med `coef()`.

Her er en mer utdypende [forklaring av lme4 pakken med
eksempler](https://cran.r-project.org/web/packages/lme4/vignettes/lmer.pdf).
Mye av teksten er teknisk, men se seksjon 5.2 dersom du tenker å kjøre
en flernivåanalyse til hjemmeoppgaven for detaljer om diagnostikk for
`lmer`.
