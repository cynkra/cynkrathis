use_cynkra_upkeep <- function(repo = NULL) {
  repo <- repo %||% gh_repo()
  issue <- gh::gh(
    sprintf("POST /repos/%s/issues", repo),
    title = "Spring cleaning @ cynkra dev day :soap:",
    body = upkeep_text()
  )
  browseURL(issue[["html_url"]])
}

gh_repo <- function() {
  repo <- usethis::proj_get()
  remote <- gert::git_remote_info("origin")[["url"]]
  sub(
    "git@github.com\\:",
    "",
    sub(
      "\\.git",
      "",
      remote
    )
  )
}

upkeep_text <- function() {
  todos <- read.csv(system.file("upkeep.csv", package = "cynkrathis"))
  sections_in_order <- unique(todos[["Section"]])
  todos <- split(todos, todos[["Section"]])
  todos <- todos[sections_in_order]

  paste(
    lapply(todos, upkeep_section),
    collapse = ""
  )
}

upkeep_section <- function(df) {
  title <- sprintf("\n## %s\n\n", df[["Section"]][[1]])
  text <- lapply(
    split(df, seq_len(nrow(df))),
    upkeep_item
  ) |>
    unlist()

  paste(c(title, text), collapse = "")
}

upkeep_item <- function(df) {
  if (nzchar(df[["Description"]])) {
    sprintf(
      "- [ ] %s <details><summary>:bulb:</summary>%s</details>\n",
      df[["Title"]],
      df[["Description"]]
    )
  } else {
    sprintf("- [ ] %s\n", df[["Title"]])
  }
}
