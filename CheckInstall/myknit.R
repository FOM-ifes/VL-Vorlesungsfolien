myknit <- function (inputFile, encoding, yaml='../private.yaml') {
    rmd <- readLines(inputFile)
    if (file.exists(yaml)) {
        # read in the YAML + src file
        yaml <- readLines(yaml)
        
        # insert the YAML in after the first ---
        # I'm assuming all my RMDs have properly-formed YAML and that the first
        # occurence of --- starts the YAML. You could do proper validation if you wanted.
        yamlHeader <- grep('^---$', rmd)[1]
        # put the yaml in
        rmd <- append(rmd, yaml, after=yamlHeader)
    }
    # write out to a temp file
    ofile <- file.path(tempdir(), basename(inputFile))
    writeLines(rmd, ofile)
    
    # render with rmarkdown.
    message(ofile)
    ofile <- rmarkdown::render(ofile, "pdf_document", encoding=encoding, envir=new.env())
    
    # copy back to the current directory.
    file.copy(ofile, file.path(dirname(inputFile), basename(ofile)), overwrite=T)
}