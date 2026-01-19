# Profil R minimal pour compatibilité toolchain
# Ne rien mettre ici sauf logique essentielle

# Charger un profil RStudio si présent
if (Sys.getenv("RSTUDIO") == "1") {
  local_profile <- "~/.config/r/.Rprofile"
  if (file.exists(local_profile)) source(local_profile)
}
