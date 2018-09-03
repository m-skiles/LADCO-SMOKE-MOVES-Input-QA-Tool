

#define location of perl for use in converting MySQL files
perl="C:\\Perl64\\bin\\perl.exe"

#define the location of county database folders.  Individual folders for each rep county shoud be in the 'data' folder
#or whatever folder your MySQL_directory represents
MySQL_directory="C:\\ProgramData\\MySQL\\MySQL Server 5.6\\data"

#Define the user and password for your MySQL files (previously set by user)
##############!!!!!!!!!!!!!!!!!!###############
MySQL_user="root"
MySQL_password="xxxxx"
#usully can be localhost if files are saved on the same computer
MySQL_host="localhost"
##############!!!!!!!!!!!!!!!!!!###############

Base_Directory="xxxxxxx"

#define pathway to MOVES tables
Speed<-paste(Base_Directory,"SPEED_NEI_v2_2011_29sep2014_v3.csv",sep="")
print(Speed)
Speedpro<-paste(Base_Directory,"SPDPRO_NEI_v2_2011_18sep2014_v0.csv",sep="")
print(Speedpro)
VMT<-paste(Base_Directory,"VMT_NEI_v2_2011_no_E85_30sep2014_v1.csv",sep="")
print(VMT)
VPOP<-paste(Base_Directory,"VPOP_NEI_v2_2011_no_E85_29sep2014_v0.csv",sep="")
print(VPOP)
Hotelling<-paste(Base_Directory,"HOTELING_NEI_v2_2011_20oct2014_v2.csv",sep="")
print(Hotelling)
population_table=paste(Base_Directory,"population_chart.csv",sep="")
print(population_table)
countyxref=paste(Base_Directory,"MCXREF_2011eg_22aug2014_v0.csv",sep="")
print(countyxref)
countylist_table=paste(Base_Directory,"countylist.csv",sep="")
print(countylist_table)
################################!!!!!!!!!!!!!!!!!!!!!!!!!!#####################################
#file directories for sending function outputs.  Must be modified for each individual computer
ggsave_countrypath=paste(Base_Directory,"Scripts_Final\\Country_Plots\\Plots",sep="")
ggsave_statepath=paste(Base_Directory,"Scripts_Final\\State_Plots\\Plots",sep="")
################################!!!!!!!!!!!!!!!!!!!!!!!!!!#####################################

By_Category_Pathway=paste(Base_Directory,"Scripts_Final\\By_Category_Plots\\",sep="")
Individual_pathway=paste(Base_Directory,"Scripts_Final\\Individual_County_Plots\\",sep="")
Reference_County_Pathway=paste(Base_Directory,"Scripts_Final\\Reference_County_Plots\\",sep="")
state_pathway=paste(Base_Directory,"Scripts_Final\\State_Plots\\",sep="")
One_Run_Pathway=paste(Base_Directory,"Scripts_Final\\One_Run_Scripts\\Plots\\",sep="")
                      
                      
                      
                      
                      