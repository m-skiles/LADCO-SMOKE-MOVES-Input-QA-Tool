
Individual_County_Plots_Masterscript <- function () {
  
  #source the functions to be called
  Individual_pathway=paste(Source_Directory,"Individual_County_Plots",sep="")
  Individual_pathway=paste(Individual_pathway,"\\",sep="")
  source(paste(Individual_pathway,"avgspeed_bysourcetype_byroadtype.R",sep=""))
  
  countylist=countyxref$indfullname
  countylist=countylist[countylist %in% Speed_mastertable_summary$region_cd]
  
  for (n in 1:length(countylist))
  {countyloop=countylist[n]
  print(sprintf("Plotting %s",countyloop))
  avgspeed_bysourcetype_byroadtype(countyloop)}
}