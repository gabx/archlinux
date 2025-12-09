
# Coffre persistant : répertoire XDG (~/.local/share/portfolio-vault)
.vault_dir <- function(root = NULL) {
  base <- if (is.null(root) || root == "") {
    file.path(Sys.getenv("XDG_DATA_HOME", "~/.local/share"), "portfolio-vault")
  } else {
    root
  }
  if (!dir.exists(base)) dir.create(base, recursive = TRUE, mode = "0700")
  base
}

# Coffre mémoire (séparé du .GlobalEnv)
vault_env <- new.env(parent = emptyenv())

# Sauvegarde versionnée (RDS). Nom de fichier: <name>_<YYYYmmdd-HHMMSS>.rds
vault_save <- function(obj, name, root = NULL, compress = TRUE) {
  stopifnot(is.character(name), nzchar(name))
  dir <- .vault_dir(root)
  ts  <- format(Sys.time(), "%Y%m%d-%H%M%S")
  path <- file.path(dir, sprintf("%s_%s.rds", name, ts))
  tmp  <- paste0(path, ".tmp-", Sys.getpid())

  # Écriture atomique
  saveRDS(obj, file = tmp, compress = compress)
  ok <- file.rename(tmp, path)
  if (!ok) stop("Impossible de finaliser l’écriture: ", path)

  # Garder une copie en mémoire (environnement “safe”)
  assign(name, obj, envir = vault_env)

  message("Sauvé: ", path)
  invisible(path)
}

# Lister versions
vault_list <- function(name = NULL, root = NULL) {
  dir <- .vault_dir(root)
  files <- list.files(dir, pattern = "\\.rds$", full.names = TRUE)
  if (!is.null(name)) {
    pat <- paste0("^", name, "_\\d{8}-\\d{6}\\.rds$")
    files <- files[grepl(pat, basename(files))]
  }
  data.frame(
    file = files,
    name = sub("_(\\d{8}-\\d{6})\\.rds$", "", basename(files)),
    timestamp = sub("^.*_(\\d{8}-\\d{6})\\.rds$", "\\1", basename(files)),
    stringsAsFactors = FALSE
  )[order(files), ]
}

# Charger la dernière version (ou une version précise)
vault_load <- function(name, root = NULL, timestamp = NULL) {
  df <- vault_list(name, root)
  if (nrow(df) == 0) stop("Aucune version trouvée pour '", name, "'.")
  if (!is.null(timestamp)) {
    df <- df[df$timestamp == timestamp, , drop = FALSE]
    if (nrow(df) == 0) stop("Version '", timestamp, "' introuvable pour '", name, "'.")
  } else {
    # choisir la plus récente
    ord <- order(df$timestamp, decreasing = TRUE)
    df <- df[ord, , drop = FALSE]
  }
  obj <- readRDS(df$file[1])
  # Charger aussi dans l'env mémoire
  assign(name, obj, envir = vault_env)
  obj
}

# Optionnel: ne garder que N versions les plus récentes
vault_prune <- function(name, keep = 5, root = NULL) {
  df <- vault_list(name, root)
  if (nrow(df) <= keep) return(invisible(NULL))
  ord <- order(df$timestamp, decreasing = TRUE)
  to_remove <- df$file[ord][-(1:keep)]
  file.remove(to_remove)
  invisible(to_remove)
}

