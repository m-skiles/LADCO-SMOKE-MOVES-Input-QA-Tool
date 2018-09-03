

Reference_County_Plots_Masterscript_LADCO_States <- function () {
  #source the functions to be called
  Reference_County_Pathway="C:\\Users\\Jeff\\Documents\\matt\\LADCOwork\\Scripts_Final\\Reference_County_Plots\\"
  source(paste(Reference_County_Pathway,"Average_Speed_by_Hour_Roadtype_sourcetype.R",sep=""))
  source(paste(Reference_County_Pathway,"annual_travel_fraction_byageID.R",sep=""))
  source(paste(Reference_County_Pathway,"DayVMTfraction_forsourcetype_overmonths_byroadtype.R",sep=""))
  source(paste(Reference_County_Pathway,"Drafthours_bycounty_ageID_month.R",sep=""))
  source(paste(Reference_County_Pathway,"HourVMTfraction_bysourcetype_byhour.R",sep=""))
  source(paste(Reference_County_Pathway,"MonthVMTfraction_bymonth.R",sep=""))
  
  countylist=state[state$stateID %in% c(17,18,19,26,27,39,55),]$countyID
  sourcelist=sourcetypetable$typeID
  
  
  
  dayid=c(5,2)
  
  for (n in 1:length(countylist))
  {countyloop=toString(countylist[n])
  print(sprintf("plotting %s",countyloop))
  print(date())
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