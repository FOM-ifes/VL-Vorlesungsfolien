library(mosaic)
i <- c()
x <- c()
y1 <- c()
y2 <- c()
y3 <- c()

c <- 1000000
pup <- 10^12
max <- 100
yr <- 0.02

for(j in 0:max) {
    i <- c(i, j)
    tmp <- 1 - max/(2*c) + (j-1)/c
    yc <- (tmp-1)^8
    yb <- 1 + tmp* (-8 + tmp* (28 + tmp* (-56 + tmp* (70 + tmp* (-56 + tmp* (28 + (-8 + tmp) *tmp))))))
    ya <- 1 - 8 *tmp + 28 *tmp^2 - 56 *tmp^3 + 70 *tmp^4 - 56 *tmp^5 + 28 *tmp^6 - 8 *tmp^7 + tmp^8
    x <- c(x, tmp)
    y1 <- c(y1, ya)
    y2 <- c(y2, ya)
    y3 <- c(y3, ya)
}

xyplot((y1*pup) ~ x, xlim=range(1-(max+10)/(2*c), 1+(max+10)/(2*c)), ylim=range(-yr, +yr), col="blue")
xyplot((y2*pup) ~ x, xlim=range(1-(max+10)/(2*c), 1+(max+10)/(2*c)), ylim=range(-yr, +yr), col="red")
xyplot((y3*pup) ~ x, xlim=range(1-(max+10)/(2*c), 1+(max+10)/(2*c)), ylim=range(-yr, +yr), col="green")


