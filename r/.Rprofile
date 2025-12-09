# $XDG_CONFIG_HOME/r/.Renviron
# Last modified 2025-12-01


## =====================================================================
##                 CLEAN & FULL RSTUDIO PROFILE (Arch Linux)
## =====================================================================
## Intègre :
## - Détection RStudio + garde anti-double-exécution
## - Chargement automatique tidyverse/devtools/conflicted/usethis
## - Prompt personnalisé
## - Environnement dédié .helperEnv + chargement helpers
## - .First() et .Last()
## - Options système complètes
## - Intégration startup::startup()
## =====================================================================

# ---------------------------------------------------------------------
# 1. Garde anti-double-exécution (RStudio lance .Rprofile 2 fois)
# ---------------------------------------------------------------------
if (Sys.getenv("RSTUDIO") == "1") {
  if (Sys.getenv("RSTUDIO_PROFILE_LOADED") == "1") {
    message("(.Rprofile) Skipped (already loaded by RStudio).")
    # Pas de return, pour permettre l'exécution de .First() / .Last()
  } else {
    Sys.setenv(RSTUDIO_PROFILE_LOADED = "1")
  }
}

message("Loading RStudio user profile…")

# ---------------------------------------------------------------------
# 2. Prompt personnalisé
# ---------------------------------------------------------------------
if (interactive()) {
  options(
    prompt = paste0(
      Sys.info()[["user"]], "@", Sys.info()[["nodename"]], " [R] "
    ),
    continue = "... "
  )
}

# ---------------------------------------------------------------------
# 3. Helper environment (remplace attach())
# ---------------------------------------------------------------------
.helperEnv <- new.env(parent = baseenv())

load_helpers <- function() {
  helper_dir <- path.expand(Sys.getenv("R_HOME_USER"))

  helper_path <- file.path(helper_dir, "helper")

  if (dir.exists(helper_path)) {
    files <- list.files(helper_path, full.names = TRUE, pattern = "\\.[Rr]$")
    if (length(files) > 0) {
      for (f in files) sys.source(f, envir = .helperEnv)
    }
  }
}

# ---------------------------------------------------------------------
# 4. .First() (exécuté en mode interactif)
# ---------------------------------------------------------------------
.First <- function() {
  if (interactive()) {
    cat("Welcome back", Sys.getenv("USER"),
        "\nworking directory is:", getwd(), "\n")
  }
  load_helpers()
}

# ---------------------------------------------------------------------
# 5. .Last() (fin de session)
# ---------------------------------------------------------------------
.Last <- function() {
  if (interactive()) {
    try(save.image("/development/language/r/.RData"), silent = TRUE)
    try(savehistory("/development/language/r/R.Rhistory"))
    file.append("/development/language/r/R.Rhistory_old",
                "/development/language/r/R.Rhistory")
    file.rename("/development/language/r/R.Rhistory_old",
                "/development/language/r/R.Rhistory")
    cat("Goodbye", Sys.info()[["user"]], date(), "\n")
  }
}

# ---------------------------------------------------------------------
# 6. Options globales
# ---------------------------------------------------------------------
options(
  digits = 12,
  scipen = 999,
  width = 80,
  show.signif.stars = FALSE,
  stringsAsFactors = FALSE,
  useFancyQuotes = FALSE,
  repos = c(
    cran = "https://cran.rstudio.com/",
    ropensci = "https://ropensci.r-universe.dev",
    cloud = "https://cloud.r-project.org"
  ),

  defaultPackages = c(
    "datasets", "utils", "grDevices", "graphics",
    "stats", "methods", "readr"
  ),

  editor = "nvim",
  pager = "vimrpager",
  pdfviewer = "okular",

  googlesheets4_quiet = TRUE,
  dplyr.summarise.inform = FALSE,
  readr.show_col_types = FALSE,
  warnPartialMatchAttr = TRUE,
  warnPartialMatchDollar = TRUE,
  warnPartialMatchArgs = TRUE
)

# Parallelisation
local({
  n <- max(parallel::detectCores() - 2L, 1L)
  options(Ncpus = n, mc.cores = n)
})

# ---------------------------------------------------------------------
# 7. Packages chargés automatiquement
# ---------------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(conflicted)
  library(usethis)
  library(devtools)
})

# Conflits tidyverse
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("rename", "dplyr")

# ---------------------------------------------------------------------
# 8. RStudio/shiny integration
# ---------------------------------------------------------------------
if (requireNamespace("shiny", quietly = TRUE)) {
  options(shiny.autoreload = TRUE)
}

# ---------------------------------------------------------------------
# 9. Répertoire de travail
# ---------------------------------------------------------------------
setwd("/development/language/r")

# ---------------------------------------------------------------------
# 10. startup package (optionnel)
# ---------------------------------------------------------------------
if (requireNamespace("startup", quietly = TRUE)) {
  tryCatch(
    startup::startup(),
    error = function(ex) message(".Rprofile error: ", conditionMessage(ex))
  )
}

# ---------------------------------------------------------------------
# 11. Fin d'initialisation
# ---------------------------------------------------------------------
message("\n*** Successfully loaded .Rprofile ***\n")

utils::sessionInfo()
