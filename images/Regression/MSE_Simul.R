### Simulation zur Verdeutlichung, dass MSE_Test mit zunehmender Komplexität wieder steigen kann

## Matrizen, die die MSE Ergebnisse sammeln
trainerrormatrix <- matrix(0, nrow=100, ncol=11)
testerrormatrix <- matrix(0, nrow=100, ncol=11)

## Schleife über die Simulationen
for(i in 1:100)
{
  set.seed(i)
  
  # x Wertebereich: 0-6; 100 Training, 10000 Testbeobachtungen
  x <- runif(n=10100, min=0, max=6)
  # "Wahres" y
  y <- - x^3 + 8*x^2 - 9*x - 18
  # y mit Störterm
  y <- y + rnorm(length(y), sd=sd(y))

  # Datensatz
  dat <- data.frame(x=x, y=y)

  # Aufteilung Training/ Test
  traindat <- dat[1:100,]
  testdat <- dat[-c(1:100),]

  # MSE Ergebnisvektor
  trainerror <- numeric(11)
  testerror <- numeric(11)

  # Modell Polynom 0
  m <- lm(y~1, data=traindat)
  ydachtrain <- predict(m, newdata=traindat)
  msetrain <- mean((ydachtrain-traindat$y)^2)
  ydachtest <- predict(m, newdata=testdat)
  msetest <- mean((ydachtest-testdat$y)^2)
  trainerror[1] <- msetrain 
  testerror[1] <- msetest

  # Modell Polynom 1
  m <- lm(y~x, data=traindat)
  ydachtrain <- predict(m, newdata=traindat)
  msetrain <- mean((ydachtrain-traindat$y)^2)
  ydachtest <- predict(m, newdata=testdat)
  msetest <- mean((ydachtest-testdat$y)^2)
  trainerror[2] <- msetrain 
  testerror[2] <- msetest

  # Schleife für Modelle Polynom 2-10
  for (j in 2:10)
  {
    xf <- paste0("I(x^", 2:j,")")
    fm <- as.formula(paste("y ~ x + ", paste(xf, collapse = "+")))
    m <- lm(fm, data=traindat)
    ydachtrain <- predict(m, newdata=traindat)
    msetrain <- mean((ydachtrain-traindat$y)^2)
    ydachtest <- predict(m, newdata=testdat)
    msetest <- mean((ydachtest-testdat$y)^2)
    trainerror[1+j] <- msetrain 
    testerror[1+j] <- msetest
  }
  
  # Alle 11 Ergebnisse der Simulation speichern
  trainerrormatrix[i,] <- trainerror
  testerrormatrix[i,] <- testerror
}

# Mittelwert über Simulationen MSE je Grad des Polynoms
mse <- data.frame(grad=0:10, train=apply(trainerrormatrix, 2, mean), test=apply(testerrormatrix, 2, mean))

# Abbildung erzeugen
library(ggplot2)
gmse <- ggplot(data=mse, aes(grad)) +
  geom_line(aes(y=train, colour="Training"), size=1.5) +
  geom_line(aes(y=test, colour="Test"), size=1.5) +
  labs(colour='Daten') +
  scale_x_continuous(name="Grad des Schätzpolynoms", breaks=0:10) + 
  geom_vline(xintercept = 3) +
  ylab("Modellfehler (MSE)") 

ggsave("MSE.png", plot=gmse, device="png", width=20, height=10, units = "cm")

