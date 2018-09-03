

One_Run_Plots_Masterscript <- function () {
  
  #source the functions to be called
 
  source(paste(One_Run_Pathway,"county_map_auxiliary_hotelling.R",sep=""))
  source(paste(One_Run_Pathway,"county_map_engine_hotelling.R",sep=""))
  source(paste(One_Run_Pathway,"county_map_population.R",sep=""))
  source(paste(One_Run_Pathway,"county_map_population_percapita.R",sep=""))
  source(paste(One_Run_Pathway,"county_map_vmt.R",sep=""))
  source(paste(One_Run_Pathway,"county_map_vmt_percapita.R",sep=""))
  
  
  print("plotting auxiliary hotelling map")
  print(date())
  county_map_auxiliary_hotelling()
  print("plotting engine hotelling map")
  print(date())
  county_map_engine_hotelling()
  print("plotting population map")
  print(date())
  county_map_population()
  print("plotting population per capita map")
  print(date())
  county_map_population_percapita()
  print("plotting vmt map")
  print(date())
  county_map_vmt()
  print("plotting vmt per capita map")
  print(date())
  county_map_vmt_percapita()
}

