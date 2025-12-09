.chatgpt_request <- function(prompt, model = Sys.getenv("CHATGPT_MODEL", "gpt-5")) {
  key <- Sys.getenv("OPENAI_API_KEY")
  if (key == "") stop("OPENAI_API_KEY not set")

  body <- list(
    model = model,
    agent = Sys.getenv("CHATGPT_CODE_AGENT", "codex"),
    messages = list(list(role = "user", content = prompt))
  )

  httr::POST(
    url = "https://api.openai.com/v1/chat/completions",
    httr::add_headers(
      Authorization = paste("Bearer", key),
      "Content-Type" = "application/json"
    ),
    body = jsonlite::toJSON(body, auto_unbox = TRUE)
  ) -> res

  jsonlite::fromJSON(httr::content(res, as="text"))$choices$message.content
}

# Helpers haut niveau ------------------------------------------------------------

gpt <- function(prompt) {
  .chatgpt_request(prompt)
}

gpt_code <- function(code, instruction = "Améliore ce code R") {
  prompt <- paste0(instruction, ":\n```r\n", code, "\n```")
  .chatgpt_request(prompt)
}

gpt_debug <- function(code) {
  prompt <- paste0("Explique l'erreur et propose une correction :\n```r\n", code, "\n```")
  .chatgpt_request(prompt)
}

gpt_explain <- function(code) {
  prompt <- paste0("Explique clairement ce que fait ce code R :\n```r\n", code, "\n```")
  .chatgpt_request(prompt)
}

gpt_optimize <- function(code) {
  prompt <- paste0("Optimise ce code R pour les performances :\n```r\n", code, "\n```")
  .chatgpt_request(prompt)
}
