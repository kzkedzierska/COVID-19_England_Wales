#!/usr/bin/env R

`%not in%` <- Negate(`%in%`)

## TODO:
# make install optional!
# clean up the code!
# add description
# figure out why suppress messages doesn't work on tidyverse

load_packages <- function(cran_pkgs = NULL, 
                          bioc_pkgs = NULL, 
                          github_pkgs = NULL, 
                          verbose = 0) {
  
  if (!is.null(cran_pkgs)) {
    check(cran_pkgs)
    load_cran(cran_pkgs, verbose)
  }
  if (!is.null(bioc_pkgs)) {
    check(bioc_pkgs)
    load_bioc(bioc_pkgs, verbose)
  }
  if (!is.null(github_pkgs)) {
    check(github_pkgs, github = TRUE)
    load_github(github_pkgs, verbose)
  }
  
  all_pkgs <- c(cran_pkgs,
                bioc_pkgs,
                names(github_pkgs))
  missing <- all_pkgs %not in% (.packages()) 
  if (sum(missing) == 0) {
    print("Success! All packages loaded!")
  } else {
    msg <- paste("Not all packages loaded.\n",
                 "Missing packages: ",
                 paste(all_pkgs[missing], collapse = ", "))
    stop(msg)
  }
}

check <- function(pkgs, github = FALSE) {
  # Check if packages are of proper format
  if (sum(nchar(pkgs) < 3) > 0) {
    msg <- paste("Following pkgs names are quite short,",
                 "are you sure they are correct?",
                 "\nquestionable names:",
                 paste(pkgs[nchar(pkgs) < 3], collapse = ", "))
    warning(msg)
  }
  if (!is.character(pkgs)) {
    msg <- paste("Packages have to be a character vector!", 
                 "\nquestionable names:",
                 paste(pkgs, collapse = ", "))
    stop(msg)
  }
}

load_cran <- function(cran_pkgs, verbose = 0, cran_mirror = "https://cloud.r-project.org") {
  # add cran mirror
  options(repos = c(CRAN = cran_mirror))
  # set the parameters for verbose output
  if (verbose == 0) {
    verbose = FALSE
    quiet = TRUE
  } else if (verbose == 1) {
    verbose = quiet = TRUE
  } else {
    verbose = TRUE
    quiet = FALSE
  }
  # Load CRAN packages, installing them if necessary
  for (pkg in cran_pkgs) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      install.packages(pkg, 
                       verbose = verbose, quiet = quiet)
    }
    # Load packages
    if (verbose < 1) {
      suppressPackageStartupMessages(library(pkg, character.only = TRUE,
                                             verbose = verbose, quietly = quiet))
    } else {
      library(pkg, character.only = TRUE,
              verbose = verbose, quietly = quiet)
    }
  }
}

load_bioc <- function(bioc_pkgs, verbose = 0) {
  # set the parameters for verbose output
  if (verbose == 0) {
    verbose = FALSE
    quiet = TRUE
  } else if (verbose == 1) {
    verbose = quiet = TRUE
  } else {
    verbose = TRUE
    quiet = FALSE
  }
  
  # check if any Biocondcutor packages need to be installed
  bioc_needed <- sum(bioc_pkgs %not in% installed.packages()[,1]) > 0
  
  # Check if BiocManager needed and if installed
  if (bioc_needed && !requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", 
                     verbose = verbose, quiet = quiet)
  }
  # Load Bioconductor packages, installing them if necessary
  for (pkg in bioc_pkgs) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      BiocManager::install(pkg, update = FALSE, ask = FALSE,
                           verbose = verbose, quiet = quiet)
    }
    # Load packages
    if (verbose < 1) {
      suppressPackageStartupMessages(library(pkg, character.only = TRUE,
                                             verbose = verbose, quietly = quiet))
    } else {
      library(pkg, character.only = TRUE,
              verbose = verbose, quietly = quiet)
    }
  }
}

load_github <- function(github_pkgs, verbose = 0) {
  # set the parameters for verbose output
  if (verbose == 0) {
    verbose = FALSE
    quiet = TRUE
  } else if (verbose == 1) {
    verbose = quiet = TRUE
  } else {
    verbose = TRUE
    quiet = FALSE
  }
  
  # check if github packages are needed
  github_needed <- sum(names(github_pkgs) %not in% installed.packages()[,1]) > 0
  
  # check if any github pkgs needed and if devtools installed
  if (github_needed && "devtools" %not in% installed.packages()[,1]) {
    install.packages("devtools",
                     verbose = verbose, quiet = quiet)
  }
  
  # Load Github packages, install them if necessary
  for (i in 1:length(github_pkgs)) {
    if (!require(names(github_pkgs)[i], character.only = TRUE, quietly = TRUE)) {
      devtools::install_github(github_pkgs[i],
                               verbose = verbose, quiet = quiet)
    }
    # Load packages
    if (verbose < 1) {
      suppressPackageStartupMessages(library(names(github_pkgs)[i], 
                                             character.only = TRUE,
                                             verbose = verbose, 
                                             quietly = quiet))
    } else {
      library(names(github_pkgs)[i], character.only = TRUE,
              verbose = verbose, quietly = quiet)
    }
  }
}
