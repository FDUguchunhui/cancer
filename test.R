one_factor <- function(data, row_var_list, col_var, keep_one_row_name = TRUE, ...) {
  
  table_lst <- list()
  for (i in 1:length(row_var_list)) {
    table_lst[[i]] <- two_way_table(data, row_var_list[i], ...)
  }
  
  com_indep <-  bind_rows(table_lst)
  
  return(com_indep)
}

var_lst <- c('age_gp', 'gender', 'race_gp', 'region', 'n_comorbity_gp', 
             'n_posi_comorb_gp', 'surgery4wk')
one_factor(rawdata_cancer, var_lst, 'death')