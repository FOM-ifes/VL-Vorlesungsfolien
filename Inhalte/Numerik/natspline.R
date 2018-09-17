natspline <- function(x,y){
    # Berechnung von natürlichen Splines
    
    n <- length(x)
    y2 <- numeric(n)
    u <-numeric(n)
    
    # natuerlicher Spline:
    y2[1] <- 0
    u[1] <- 0
    
    for (i in 2:(n-1)){
        sig <- (x[i]-x[i-1])/(x[i+1]-x[i-1])
        p <- sig*y2[i-1]+2
        y2[i] <- (sig-1)/p
        u[i] <- (y[i+1]-y[i])/(x[i+1]-x[i]) - (y[i]-y[i-1])/(x[i]-x[i-1])
        u[i] <- (6*u[i]/(x[i+1]-x[i-1])-sig*u[i-1])/p
    }
    # natürlicher Spline:
    y2[n] <- 0
    for (i in (n-1):1){
        y2[i] <- y2[i]*y2[i+1]+u[i]
    }
    erg <- list(x=x, y=y, y2=y2)
    return(erg)
}

splinterpol <- function(x, ergspline){
    # Spline Interpolation für einen Vektor x
    n <- length(x)
    y <- numeric(n)
    
    # Polynomberechnung für einzelnen x-Wert
    for (i in 1:n) {
        y[i] <- splint(x[i], ergspline)
    }
    return(y)
}

splint <- function(x, ergspline){
    # Berechnung der Interpolation mit Hilfe von natürlichen Splines

    xa <- erg$x; ya <- erg$y; y2a <- erg$y2
    n <- length(xa)
    
    # Bisektion zum Finden der Position
    klo <- 1 ; khi <- n
    while ((khi-klo)>1){
        k <- floor((khi+klo)/2)
        if (xa[k]>x) {
            khi <- k
        } else {
            klo <- k
        }
    }

    # Berechnung des Polyomwertes
    h <- xa[khi] - xa[klo]
    
    a <- (xa[khi]-x)/h
    b <- (x-xa[klo])/h
    y <- a*ya[klo]+b*ya[khi] + ((a^3-a)*y2a[klo]+(b^3-b)*y2a[khi])*h^2/6
    return(y)
}
    
