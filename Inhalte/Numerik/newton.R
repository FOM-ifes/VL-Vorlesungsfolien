library(mosaic)

newton <- function(fkt, dftk, xstart, maxiter=1000, epsilon=1/1000) {
    x <- xstart
    for(i in 1:maxiter) {
        fx <- fkt(x)
        dfx <- dfkt(x)
        if (fx < epsilon) break
    }
    return(x)
}


fkt <- makeFun(x^2 ~ x)

dfkt <- makeFun(2*x ~ x)

(x <- newton(fkt, dfkt, 10))