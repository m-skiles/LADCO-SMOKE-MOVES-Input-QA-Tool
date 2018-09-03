#All plot functions must be placed inside their respective folders within Final_Scripts before 
#Final_Plots_Masterscript can be run.

###############################################################################################

Final_Plots_Masterscript <- function () {
  
  source(paste(Source_Directory,"State_Plots\\State_Plots_Masterscript.R",sep=""))
  source(paste(Source_Directory,"By_Category_Plots\\By_Category_Plots_Masterscript.R",sep=""))
  source(paste(Source_Directory,"Individual_County_Plots\\Individual_County_Plots_Masterscript.R",sep=""))
  source(paste(Source_Directory,"One_Run_Scripts\\One_Run_Plots_Masterscript.R",sep=""))
  source(paste(Source_Directory,"Reference_County_Plots\\Reference_County_Plots_Masterscript.R",sep=""))
  
  State_Plots_Masterscript()
  Reference_County_Plots_Masterscript()
  One_Run_Plots_Masterscript()
  Individual_County_Plots_Masterscript()
  By_Category_Plots_Masterscript()


}

