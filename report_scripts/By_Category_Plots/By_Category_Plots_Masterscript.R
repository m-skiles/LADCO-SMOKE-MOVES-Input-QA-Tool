

By_Category_Plots_Masterscript <- function () {
  #source the functions to be called
  
 
  source(paste(By_Category_Pathway,"Avg_Vehicle_Age.R",sep=""))
  source(paste(By_Category_Pathway,"county_map_avg_speed_bysourcetype_byroadtype.R",sep=""))
  source(paste(By_Category_Pathway,"county_map_speedby_roadtype_sourcetype_hour.R",sep=""))
  source(paste(By_Category_Pathway,"midwest_county_map_vmt_plot.R",sep=""))
  source(paste(By_Category_Pathway,"passengercar_speed_vs_combinationtruck_speed.R",sep=""))
  
  
  
  
  sourcelist=sourcetypetable$typeID
  sourcelist2=c("passenger_cars","passenger_trucks","miscellaneous_trucks","combination_trucks")
  hourlist=1:24
  roadlist=c("rural_unrestricted","rural_restricted","urban_unrestricted","urban_restricted")
 print("Making midwest county vmt plot")
 print(date())
   midwest_county_map_vmt_plot()
  print("Making passenger car vs. combination truck plots")
  print(date())
  for(nnnnn in 1:length(roadlist))
     {roadloop=roadlist[nnnnn]
    passengercars_speed_vs_combinationtruck_speed(roadloop)
  }
  
  print("Making Average Vehicle Age Plots")
  print(date())
  for (n in 1:length(sourcelist))
    {sourceloop=sourcelist[n]
  
  Avg_Vehicle_Age(sourceloop)}
  
  for (n in 1:length(sourcelist2))
    {sourceloop2=sourcelist2[n]
  print(sprintf("Making %s plots",sourceloop2))
  print(date())
  for (nn in 1:length(roadlist))
  {roadloop=roadlist[nn]
  county_map_avg_speed_bysourcetype_byroadtype(sourceloop2,roadloop)
  
  for (nnn in 1:24)
  {hourloop=hourlist[nnn]
  county_map_speedby_roadtype_sourcetype_hour(roadloop,sourceloop2,hourloop)
  }
  }
  }
}
