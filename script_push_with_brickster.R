# template for pushing an R script developed in RStudio to a Databricks workspace, where it can be run as a notebook job
# following install & auth setup from https://zacdav-db.github.io/brickster/articles/setup-auth.html

# add API token from Spark configs (loaded in init script) to .Renviron
Sys.setenv(DATABRICKS_TOKEN = SparkR::sparkR.conf("spark.DATABRICKS_TOKEN")[[1]]) 
# set workspace URL from Databricks-specific Spark conf
Sys.setenv(DATABRICKS_HOST = paste0("https://" ,SparkR::sparkR.conf("spark.databricks.workspaceUrl")[[1]]))

remotes::install_github("zacdav-db/brickster")

library(brickster)

workspace_path <- "/Users/tim.lortz@databricks.com/SparkR_test"
#file <- "../databricks-r-jobs-templates/SparkR_test.r"
file <- "SparkR_test.r"

db_workspace_import(
  path = workspace_path,
  file = file,
  format = "SOURCE",
  language = "R",
  overwrite = FALSE,
  host = db_host(),
  token = db_token(),
  perform_request = TRUE
)
