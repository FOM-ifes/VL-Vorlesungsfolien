library(tibble)
library(purrr)

amazon_prefix <- "http://ec2.images-amazon.com/images/P/"
pathtoimage <- "./images/Literatur"
books <- tribble(
    ~ISBN_10,     ~Name,
    "3658215860",    "Moderne-Datenanalyse-mit-R.jpg",
    "1943450145",    "Introduction-to-Modern-Statistics.jpg",
    "0367409828",    "ModernDive---An-Introduction-to-Statistical-and-Data-Science-via-R.jpg",
    "1071614177",    "An-Introduction-to-Statistical-Learning---with-Applications-in-R.jpg",
#    "0983965838",    "A-Students-Guide-to-R.jpg"
)

get_image <- function(ISBN_10, Name) {
    print(paste(ISBN_10, Name))
    download.file(paste0(amazon_prefix, ISBN_10), file.path(pathtoimage, Name))
}

pmap(books, get_image)
