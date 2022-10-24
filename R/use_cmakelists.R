#'
#'
#'@export
use_cmakelists <- function(project = NULL) {
  writeLines(
    c("cmake_minimum_required(VERSION 3.0.0)",
      paste0("project(", project," VERSION 0.1.0)"),
      "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)",
      "include(CTest)",
      "enable_testing()",
      "",
      "add_subdirectory(src)",
      "set(CPACK_PROJECT_NAME ${PROJECT_NAME})",
      "set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})",
      "include(CPack)",
      "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)"
      ), "CMakeLists.txt"
  )

  if (!fs::dir_exists("src")) fs::dir_create("src")

  writeLines(
    c(paste0("add_library(", project),
      "  connection.cpp",
      "  DbColumn.cpp",
      "  DbColumnDataSource.cpp",
      "  DbColumnDataSourceFactory.cpp",
      "  DbColumnStorage.cpp",
      "  DbConnection.cpp",
      "  DbDataFrame.cpp",
      "  DbResult.cpp",
      "  encode.cpp",
      "  encrypt.cpp",
      "  logging.cpp",
      "  PqColumnDataSource.cpp",
      "  PqColumnDataSourceFactory.cpp",
      "  PqDataFrame.cpp",
      "  PqResult.cpp",
      "  PqResultImpl.cpp",
      "  PqResultSource.cpp",
      "  PqUtils.cpp",
      "  RcppExports.cpp",
      "  result.cpp",
      "  DbColumnDataSourceFactory.h",
      "  DbColumnDataSource.h",
      "  DbColumnDataType.h",
      "  DbColumn.h",
      "  DbColumnStorage.h",
      "  DbConnection.h",
      "  DbDataFrame.h",
      "  DbResult.h",
      "  DbResultImplDecl.h",
      "  DbResultImpl.h",
      "  encode.h",
      "  integer64.h",
      "  pch.h",
      "  PqColumnDataSourceFactory.h",
      "  PqColumnDataSource.h",
      "  PqDataFrame.h",
      "  PqResult.h",
      "  PqResultImpl.h",
      "  PqResultSource.h",
      "  PqUtils.h",
      "  RPostgres-init.c",
      "  RPostgres_types.h",
      ")",
      "",
      paste0("target_include_directories(", project, " PUBLIC"),
      '    "/usr/share/R/include"',
      '    "/home/gitpod/R/x86_64-pc-linux-gnu-library/3.6/Rcpp/include/"',
      '    "/home/gitpod/R/x86_64-pc-linux-gnu-library/3.6/plogr/include/"',
      '    "/usr/include/postgresql"',
      '    "vendor"',
      ")",
      "",
      paste0("target_compile_definitions(", project, " PUBLIC"),
      '    "RCPP_DEFAULT_INCLUDE_CALL=false"',
      '    "RCPP_USING_UTF8_ERROR_STRING"',
      '    "BOOST_NO_AUTO_PTR"',
      ")"
    ), "src/CMakeLists.txt"
  )
}
