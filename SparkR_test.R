# Databricks notebook source
# COMMAND ----------
library(SparkR)
library(magrittr)

sparkR.session()
tables <- SparkR::sql("SHOW TABLES") %>% collect()
print(tables)
