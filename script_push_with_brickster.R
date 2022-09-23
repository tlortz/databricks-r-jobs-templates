# template for pushing an R script developed in RStudio to a Databricks workspace, where it can be run as a notebook job
# following install & auth setup from https://zacdav-db.github.io/brickster/articles/setup-auth.html

# Prereqs:
## create a Personal Access Token (PAT) and store it as a Secret in your Databricks workspace, using the Secrets API
### https://docs.databricks.com/dev-tools/api/latest/authentication.html#generate-a-personal-access-token
### https://docs.databricks.com/security/secrets/secrets.html#create-a-secret
## run on a Databricks Machine Learning Runtime cluster with the following Spark config in the cluster configuration:
### spark.DATABRICKS_TOKEN {{secrets/{scope-containing-PAT-secret}/{PAT-secret-key}}}
# add API token from Spark configs (loaded in init script) to .Renviron
Sys.setenv(DATABRICKS_TOKEN = SparkR::sparkR.conf("spark.DATABRICKS_TOKEN")[[1]]) 
# set workspace URL from Databricks-specific Spark conf
Sys.setenv(DATABRICKS_HOST = paste0("https://" ,SparkR::sparkR.conf("spark.databricks.workspaceUrl")[[1]], "/"))


remotes::install_github("zacdav-db/brickster")

library(brickster)

# simple test - listing workspace clusters
clusters <- db_cluster_list(host = db_host(), token = db_token())

# another simple test - get details of current cluster
cluster_id <- SparkR::sparkR.conf("spark.databricks.clusterUsageTags.clusterId")[[1]]
cluster_details <- db_cluster_get(cluster_id)

# more advanced test - pushing an R script from RStudio to the Databricks workspace as a notebook source file
# note that this script has the file extension changed from ".R" to ".r"
workspace_path <- "/Users/tim.lortz@databricks.com/SparkR_test"
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
