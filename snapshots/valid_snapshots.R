# https://packagemanager.rstudio.com/client/#/repos/2/overview

data = tibble::tribble(
  ~id, ~r_version, ~date, ~type,
  301, "4.0.2", "2020-07-13", "recommended",
  314, "4.0.2", "2020-08-24", ""

)

jsonlite::write_json(data, "snapshots/snapshots.json")

gert::git_add(c("snapshots/snapshots.json", "snapshots/valid_snapshots.R"))
gert::git_commit("update snapshots.json")
gert::git_push()
