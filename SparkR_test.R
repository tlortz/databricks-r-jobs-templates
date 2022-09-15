# Databricks notebook source

library(SparkR)
library(magrittr)

sparkR.session()
tables <- SparkR::sql("SHOW TABLES") %>% collect()
print(tables)