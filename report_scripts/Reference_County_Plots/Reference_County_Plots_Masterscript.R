

Reference_County_Plots_Masterscript <- function () {
 
  #source the functions to be called
  Reference_County_Pathway=paste(Source_Directory,"Reference_County_Plots",sep="")
  Reference_County_Pathway=paste(Reference_County_Pathway,"\\",sep="")
  source(paste(Reference_County_Pathway,"Average_Speed_by_Hour_Roadtype_sourcetype.R",sep=""))
  source(paste(Reference_County_Pathway,"annual_travel_fraction_byageID.R",sep=""))
  source(paste(Reference_County_Pathway,"DayVMTfraction_forsourcetype_overmonths_byroadtype.R",sep=""))
  source(paste(Reference_County_Pathway,"Drafthours_bycounty_ageID_month.R",sep=""))
  source(paste(Reference_County_Pathway,"HourVMTfraction_bysourcetype_byhour.R",sep=""))
  source(paste(Reference_County_Pathway,"MonthVMTfraction_bymonth.R",sep=""))
   
  countylist=county_table$countyID
  sourcelist=sourcetypetable$typeID
  
  dayid=c(5,2)
  
  for (n in 1:length(countylist))
  {countyloop=toString(countylist[n])
  print(sprintf("plotting %s",countyloop))
  print(date())
  countyloop=as.numeric(countyloop)
  print(countyloop)
  annual_travel_fraction_byageID(countyloop)
  MonthVMTfraction_bymonth(countyloop)
  
  
  for (nnnn in 1:12)
  {monthloop=nnnn
  Drafthours_bycounty_ageID_month(countyloop,monthloop)}
  
  
  for (nn in 1:length(sourcelist))
  {sourceloop=sourcelist[nn]
  Average_Speed_by_Hour_Roadtype_sourcetype(countyloop,sourceloop)
  DayVMTfraction_forsourcetype_overmonths_byroadtype(countyloop,sourceloop)
  
  
  for (nnn in 1:length(dayid))
  {dayloop=dayid[nnn]
  HourVMTfraction_bysourcetype_byhour(countyloop,sourceloop,dayloop)
  
  }
  }
  }
}
