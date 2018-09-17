polynewton <- function(x,y){
    # Polynominterpolation mit Hife des Newton Verfahrens

        # Korrektur für Poylnome a_0, a_n (Länge n+1)
    n <- length(x) - 1
    a <- y
    # Berechnung der dividierten Differenzen
    for (j in 1:n)
        for (i in n:j){
            a[i+1] <- (a[i+1]-a[i])/(x[i+1]-x[i-j+1])
        }
    erg <- list(x=x, y=y, a=a)
    return(erg)
}

interpoly <- function(x, ergnewton){
    # Polynominterpolation mit Newtonverfahren
    n <- length(x)
    y <- numeric(n)
    
    # Polynomberechnung für einzelnen x-Wert
    for (i in 1:n) {
        y[i] <- internewton(x[i], ergnewton)
    }
    return(y)
}

internewton <- function(x, ergpoly){
    # Berechnung der Interpolation mit Hilfe des Newton-Verfahrens
    a <- ergpoly$a; xa <- ergpoly$x
    # Korrektur der Länge
    n <- length(xa) - 1
    y <- a[1]
    for (i in 1:n) {
        xd <- 1
        for (j in 1:i) {
            xd <- xd * (x - xa[j])
        }
        y <- y + a[i+1] * xd
    }
    return(y)
}

(erg <- polynewton(x = c(0, 1, 3, 4), y = c(-4, -1, 29, 80)))
interpoly(-2, erg)
