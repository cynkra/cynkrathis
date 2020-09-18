data = tibble::tribble(
  ~id, ~r_version, ~date,
  301, "4.0.2", "2020-07-13"
)

jsonlite::write_json(data, "snapshots/snapshots.json")

gert::git_add("snapshots/snapshots.json")
gert::git_commit("update snapshots.json")
gert::git_push()
