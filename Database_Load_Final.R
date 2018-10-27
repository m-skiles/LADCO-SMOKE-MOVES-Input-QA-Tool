######Detailed instructions on LADCO file upload process are available 
######in the "File Loading Manual" word document

####MySQL and R 3.2.2 must be installed 

####Locations of all documents, servers, programs must be modified to match computer





#create a list of county directories to pull from (county folders within large folder of data)
filelist=list.files(paste(MySQL_directory),pattern='y2011')
print(filelist)

if (file.exists(Speed)) print("Speed Exists") else print("Speed  Missing --------------------------")
if (file.exists(Speedpro)) print("Speedpro Exists") else print("Speedpro   Missing -------------------------- --------------------------")
if (file.exists(VMT)) print("VMT Exists") else print("VMT   Missing -------------------------- --------------------------")
if (file.exists(VPOP)) print("VPOP Exists") else print("VPOP   Missing -------------------------- --------------------------")
if (file.exists(Hotelling)) print("Hotelling Exists") else print(" Hoteling  Missing --------------------------")
if (file.exists(population_table)) print("Population Table Exists") else print("Population Table  Missing --------------------------")
if (file.exists(countyxref_loc)) print("CountyXref Exists") else print("County Xref  Missing --------------------------")
if (file.exists(countylist_table)) print("Countylist_table Exists") else print("Countlist Table  Missing --------------------------")
################################!!!!!!!!!!!!!!!!!!!!!!!!!!#####################################

Sys.time()      
print("Step 0.10")


################################!!!!!!!!!!!!!!!!!!!!!!!!!!#####################################
#pause script to check that packages are installed and activated

#cat ("Check that packages: codetools, ggmap, ggplot2, gridExtra, plyr, RMySQL 
#     are activated by checkbox. Check the box if it is not already and press enter  ")
#line <- readline()
################################!!!!!!!!!!!!!!!!!!!!!!!!!!#####################################


Sys.time()      
print("Step 1.10 Starting MYSQL Import")


#make a loop to cycle through each county
#county database must be represented as one folder with folders for each individual county inside.  
#The loop cycles through each county folder adding the data for each table one county at a time to the mastertables
column=sub("y2011_20150301","",filelist)
columnf=sub("c","",column)
for (count in 1:284)
{#produce a query for each of the 284 county databases in mysql, disconnect afterwards as there is a max of 16 connections
  
  
  #use MySQL package to connect to MySQL database. 
  Sys.time()      
  print("Step 1.20 Loading County group:") 
  print(filelist[count])
  
  #annual
  #define path to MySQL database as variable county
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  
  #open query with database and define file to pull
  countyq = dbSendQuery(county, "select * from annual")
  #pull in data from folders
  countydata=fetch(countyq,n=-1)
  #disconnect the query (limit of 15 open queries)
  dbDisconnect(county)
  #combine each set of county data with the master table 
  #if count=1 the data is the original data to be put in the mastertable
  if (count<2)
  {annual=countydata}
  #after the first run through the loop the new countydata is bound to the existing mastertable
  else 
  {annual=rbind(annual,countydata)}
  
  #appusage
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from apuusage")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  
  #some files do not have a column displaying county ID.
  #The variable countyID represents a list of values that are bound as a column to the data
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  
  #combine each set of county data with the master table   
  #if count=1 the data is the original data to be put in the mastertable
  if (count<2)
  {
    apuusage=countydata}
  #after the first run through the loop the new countydata is bound to the existing mastertable
  else 
  {
    apuusage=rbind(apuusage,countydata)}
  
  
  #auditlog
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from auditlog")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {auditlog=countydata}
  else 
  {auditlog=rbind(auditlog,countydata)}
  
  
  #avft
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from avft")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    avft=countydata}
  else 
  {
    avft=rbind(avft,countydata)}
  
  #avgspeeddistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from avgspeeddistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    avgspeeddistribution=countydata} 
  else 
  {
    avgspeeddistribution=rbind(avgspeeddistribution,countydata)}
  
  
  #converttempmessages
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from converttempmessages")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {converttempmessages=countydata}
  else 
  {converttempmessages=rbind(converttempmessages,countydata)}
  
  
  #county_table
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from county")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {county_table=countydata}
  else 
  {county_table=rbind(county_table,countydata)}
  
  
  #countyyear
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from countyyear")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {countyyear=countydata}
  else 
  {countyyear=rbind(countyyear,countydata)}
  
  
  #dayvmtfraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from dayvmtfraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    dayvmtfraction=countydata}
  else 
  {
    dayvmtfraction=rbind(dayvmtfraction,countydata)}
  
  #drafthotellinghours
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from drafthotellinghours")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {drafthotellinghours=countydata}
  else 
  {drafthotellinghours=rbind(drafthotellinghours,countydata)}
  
  #drafthours
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from drafthours")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {drafthours=countydata}
  else 
  {drafthours=rbind(drafthours,countydata)}
  
  
  #driveschedulesecondlink
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from driveschedulesecondlink")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {driveschedulesecondlink=countydata}
  else 
  {driveschedulesecondlink=rbind(driveschedulesecondlink,countydata)}
  
  
  #fuelformulation
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from fuelformulation")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {fuelformulation=countydata}
  else 
  {fuelformulation=rbind(fuelformulation,countydata)}
  
  
  #fuelsupply
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from fuelsupply")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {fuelsupply=countydata}
  else 
  {fuelsupply=rbind(fuelsupply,countydata)}
  
  
  #fuelusagefraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from fuelusagefraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {fuelusagefraction=countydata}
  else 
  {fuelusagefraction=rbind(fuelusagefraction,countydata)}
  
  
  #hotellingactivitydistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from hotellingactivitydistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    hotellingactivitydistribution=countydata}
  else 
  {
    hotellingactivitydistribution=rbind(hotellingactivitydistribution,countydata)}
  
  #hotellinghours
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from hotellinghours")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    hotellinghours=countydata}
  else 
  {
    hotellinghours=rbind(hotellinghours,countydata)}
  
  #hourvmtfraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from hourvmtfraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    hourvmtfraction=countydata}
  else 
  {
    hourvmtfraction=rbind(hourvmtfraction,countydata)}
  
  #hpmsvtypeyear
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from hpmsvtypeyear")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    hpmsvtypeyear=countydata}
  else 
  {
    hpmsvtypeyear=rbind(hpmsvtypeyear,countydata)}
  
  #imcoverage
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from imcoverage")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {imcoverage=countydata}
  else 
  {imcoverage=rbind(imcoverage,countydata)}
  
  
  #importstartsopmodedistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from importstartsopmodedistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {importstartsopmodedistribution=countydata}
  else 
  {importstartsopmodedistribution=rbind(importstartsopmodedistribution,countydata)}
  
  
  #link
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from link")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {link=countydata}
  else 
  {link=rbind(link,countydata)}
  
  
  #linksourcetypehour
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from linksourcetypehour")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {linksourcetypehour=countydata}
  else 
  {linksourcetypehour=rbind(linksourcetypehour,countydata)}
  
  
  #monthly
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from monthly")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {monthly=countydata}
  else 
  {monthly=rbind(monthly,countydata)}
  
  
  #monthvmt
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from monthvmt")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    monthvmt=countydata}
  else 
  {
    monthvmt=rbind(monthvmt,countydata)}
  
  #monthvmtfraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from monthvmtfraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    monthvmtfraction=countydata}
  else 
  {
    monthvmtfraction=rbind(monthvmtfraction,countydata)}
  
  #offnetworklink
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from offnetworklink")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {offnetworklink=countydata}
  else 
  {offnetworklink=rbind(offnetworklink,countydata)}
  
  
  #onroadretrofit
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from onroadretrofit")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {onroadretrofit=countydata}
  else 
  {onroadretrofit=rbind(onroadretrofit,countydata)}
  
  
  #opmodedistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from opmodedistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {opmodedistribution=countydata}
  else 
  {opmodedistribution=rbind(opmodedistribution,countydata)}
  
  #regioncounty
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from regioncounty")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {regioncounty=countydata}
  else 
  {regioncounty=rbind(regioncounty,countydata)}
  
  
  #roadtype
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from roadtype")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {roadtype=countydata}
  else 
  {roadtype=rbind(roadtype,countydata)}
  
  
  #roadtypedistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from roadtypedistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    roadtypedistribution=countydata}
  else 
  {
    roadtypedistribution=rbind(roadtypedistribution,countydata)}
  
  #sourcetypeagedistribution
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from sourcetypeagedistribution")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    sourcetypeagedistribution=countydata}
  else 
  {
    sourcetypeagedistribution=rbind(sourcetypeagedistribution,countydata)}
  
  
  #sourcetypeyear
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from sourcetypeyear")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    sourcetypeyear=countydata}
  else 
  {
    sourcetypeyear=rbind(sourcetypeyear,countydata)}
  
  #starts
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from starts")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {starts=countydata}
  else 
  {starts=rbind(starts,countydata)}
  
  
  #startshourfraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from startshourfraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {startshourfraction=countydata}
  else 
  {startshourfraction=rbind(startshourfraction,countydata)}
  
  
  #startsmonthadjust
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from startsmonthadjust")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {startsmonthadjust=countydata}
  else 
  {startsmonthadjust=rbind(startsmonthadjust,countydata)}
  
  #startsperday
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from startsperday")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {startsperday=countydata}
  else 
  {startsperday=rbind(startsperday,countydata)}
  
  
  #startssourcetypefraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from startssourcetypefraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {startssourcetypefraction=countydata}
  else 
  {startssourcetypefraction=rbind(startssourcetypefraction,countydata)}
  
  
  #state
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from state")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    state=countydata}
  else 
  {
    state=rbind(state,countydata)}
  
  
  #travelfraction
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from travelfraction")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    travelfractiontable=countydata}
  else 
  {
    travelfractiontable=rbind(travelfractiontable,countydata)}
  
  
  
  #year
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from year")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    year=countydata}
  else 
  {
    year=rbind(year,countydata)}
  
  #zone
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from zone")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {zone=countydata}
  else 
  {zone=rbind(zone,countydata)}
  
  
  #zonemonthhour
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from zonemonthhour")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  if (count<2)
  {zonemonthhour=countydata}
  else 
  {zonemonthhour=rbind(zonemonthhour,countydata)}
  
  
  #zoneroadtype
  county=dbConnect(MySQL(), user=paste(MySQL_user), password=paste(MySQL_password), dbname=filelist[count], host=paste(MySQL_host))
  countyq = dbSendQuery(county, "select * from zoneroadtype")
  countydata=fetch(countyq,n=-1)
  dbDisconnect(county)
  #combine each set of county data with the master table   
  countyID=columnf[count]
  countydata=cbind(countyID,countydata)
  if (count<2)
  {
    zoneroadtype=countydata}
  else 
  {
    zoneroadtype=rbind(zoneroadtype,countydata)}
  
  Sys.time()      
  print("Step 1.90 Finished Group")
  
  
}

Sys.time()      
print("Step 2.10")

print("Starting SMOKE Input LOAD for CSV Files")
if (file.exists(Speed)) print("Speed Exists") else print("Speed  Missing --------------------------")
if (file.exists(Speedpro)) print("Speedpro Exists") else print("Speedpro  Missing --------------------------")
if (file.exists(VMT)) print("VMT Exists") else print("VMT  Missing --------------------------")
if (file.exists(VPOP)) print("VPOP Exists") else print("VP
                                                       

OP  Missing --------------------------")
if (file.exists(Hotelling)) print("Hotelling Exists") else print(" Hoteling  Missing --------------------------")
if (file.exists(population_table)) print("Population Table Exists") else print("Population Table  Missing --------------------------")
if (file.exists(countyxref_loc)) print("CountyXref Exists") else print("County Xref  Missing --------------------------")
if (file.exists(countylist_table)) print("Countylist_table Exists") else print("Countlist Table  Missing --------------------------")


#Load excel data using read comma seperated values function
#no headers to skip comments before data, skip correct amount of pre-data lines
#ignore columns with no values
Speed_mastertable<-read.csv(Speed,header=FALSE,skip=28,blank.lines.skip=TRUE)
VPOP_mastertable<-read.csv(VPOP,header=FALSE,skip=31,blank.lines.skip=TRUE)
VMT_mastertable<-read.csv(VMT,header=FALSE,skip=33,blank.lines.skip=TRUE)
Hotelling_mastertable<-read.csv(Hotelling, header=FALSE,skip=38,blank.lines.skip=TRUE)

#assign headers to columns
colnames(Speed_mastertable)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment");
colnames(VPOP_mastertable)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment");
colnames(VMT_mastertable)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment");
colnames(Hotelling_mastertable)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment");
Sys.time()    
print("Step 2.20")

#state_lowercase
for (n in 1:55)
{
  states=c("alaska", "alabama", "arkansas", "american_samoa", "arizona", "california", "colorado", "connecticut", "district of columbia", "delaware", "florida", "georgia", "guam", "hawaii", "iowa", "idaho", "illinois", "indiana", "kansas", "kentucky", "louisiana", "massachusetts", "maryland", "maine", "michigan", "minnesota", "missouri", "mississippi", "montana", "north carolina", "north dakota", "nebraska", "new hampshire", "new jersey", "new mexico", "nevada", "new york", "ohio", "oklahoma", "oregon", "pennsylvania", "puerto rico", "rhode island", "south carolina", "south dakota", "tennessee", "texas", "utah", "virginia", "virgin islands", "vermont", "washington", "wisconsin", "west virginia", "wyoming")
  stateID=c(02, 01, 05, 60, 04, 06, 08, 09, 11, 10, 12, 13, 66, 15, 19, 16, 17, 18, 20, 21, 22, 25, 24, 23, 26, 27, 29, 28, 30,	37, 38, 31, 33, 34, 35, 32, 36, 39, 40, 41, 42, 72, 44, 45, 46, 47, 48, 49, 51, 78,	50, 53, 55, 54, 56)
  state_lowercase=data.frame(stateID,states)
}
Sys.time()     
print("Step 2.30")
#countylist
countylist_table=read.csv(countylist_table,header=FALSE)
colnames(countylist_table)=c("countyID","countyName","stateabrev")
countylist_table$name_lower<-0
countylist_table$state_name<-0
countylist_table$state_num<-0

for(n in 1:nrow(countylist_table))
{
  countylist_table$name_lower[n]<-tolower(countylist_table$countyName[n])
  
  countylist_table$state_name[n]<-toString(state_lowercase[state_lowercase$stateID==countylist_table$state_num[n],]$states)
  
}

Sys.time()      
print("Step 2.40")
#countyxref
countyxref<-read.csv(countyxref_loc, header=FALSE,skip=13,blank.lines.skip=TRUE)
colnames(countyxref)=c("countryfips","statefips","countyfips","repcountry","repstatefips","repcountyfips")
countyxref$indfullname<-0
countyxref$repfullname<-0
countyxref$written_name<-0
countyxref$repstringname<-0
for (n in 1:3224)
{
  countyxref[n,]$indfullname<-countyxref[n,]$statefips*1000+countyxref[n,]$countyfips
  countyxref[n,]$repfullname<-countyxref[n,]$statefips*1000+countyxref[n,]$repcountyfips
  countyxref$written_name[n]<-toString(countylist_table[countylist_table$countyID==countyxref$indfullname[n],]$name_lower)
  if(countyxref[n,]$repfullname<10000)
  {new<-toString(countyxref[n,]$repfullname)
  countyxref[n,]$repstringname<-paste("0",new,sep="")
  }
  else
  {countyxref[n,]$repstringname<-toString(countyxref[n,]$repfullname)}
  }
countyxref[countyxref$written_name=="dekalb",]$written_name<-"de kalb"
countyxref[countyxref$written_name=="st. clair",]$written_name<-"st clair"
countyxref[countyxref$written_name=="st. francis",]$written_name<-"st francis"
countyxref[countyxref$written_name=="st. johns",]$written_name<-"st johns"
countyxref[countyxref$written_name=="st. lucie",]$written_name<-"st lucie"
countyxref[countyxref$written_name=="dupage",]$written_name<-"du page"
countyxref[countyxref$written_name=="st. joseph",]$written_name<-"st joseph"
countyxref[countyxref$written_name=="o'brien",]$written_name<-"obrien"
countyxref[countyxref$written_name=="st. bernard",]$written_name<-"st bernard"
countyxref[countyxref$written_name=="st. charles",]$written_name<-"st charles"
countyxref[countyxref$written_name=="st. helena",]$written_name<-"st helena"
countyxref[countyxref$written_name=="st. james",]$written_name<-"st james"
countyxref[countyxref$written_name=="st. john the baptist",]$written_name<-"st john the baptist"
countyxref[countyxref$written_name=="st. landry",]$written_name<-"st landry"
countyxref[countyxref$written_name=="st. martin",]$written_name<-"st martin"
countyxref[countyxref$written_name=="st. mary",]$written_name<-"st mary"
countyxref[countyxref$written_name=="st. tammany",]$written_name<-"st tammany"
countyxref[countyxref$written_name=="prince george's",]$written_name<-"prince georges"
countyxref[countyxref$written_name=="queen anne's",]$written_name<-"queen annes"
countyxref[countyxref$written_name=="st. mary's",]$written_name<-"st marys"
countyxref[countyxref$written_name=="baltimore (city)",]$written_name<-"baltimore city"
countyxref[countyxref$written_name=="st. louis",]$written_name<-"st louis"
countyxref[countyxref$written_name=="st. francois",]$written_name<-"st francois"
countyxref[countyxref$written_name=="st. louis (city)",]$written_name<-"st louis city"
countyxref[countyxref$written_name=="ste. genevieve",]$written_name<-"ste genevieve"
countyxref[countyxref$written_name=="yellowstone",]$written_name<-"yellowstone national"
countyxref[countyxref$written_name=="carson (city)",]$written_name<-"carson city"
countyxref[countyxref$written_name=="debaca",]$written_name<-"de baca"
countyxref[countyxref$written_name=="st. lawrence",]$written_name<-"st lawrence"
countyxref[countyxref$written_name=="lamoure",]$written_name<-"la moure"
countyxref[countyxref$written_name=="charles city (city)",]$written_name<-"charles city"
countyxref[countyxref$written_name=="james city (city)",]$written_name<-"james city"
countyxref[countyxref$written_name=="newport news (city)",]$written_name<-"newport news"
countyxref[countyxref$written_name=="virginia beach (city)",]$written_name<-"virginia beach"
countyxref[countyxref$written_name=="st. croix",]$written_name<-"st croix"
countyxref[countyxref$written_name=="desoto",]$written_name<-"de soto"
countyxref[countyxref$written_name=="dewitt",]$written_name<-"de witt"
countyxref[countyxref$written_name=="suffolk (city)",]$written_name<-"suffolk"
countyxref[countyxref$written_name=="hampton (city)",]$written_name<-"hampton"
countyxref[countyxref$written_name=="norfolk (city)",]$written_name<-"norfolk"

Sys.time()      
print("Step 2.50")

#county_map
county_map <- map_data("county")
county_map$stateID<-0
county_map$countyID<-0
county_map[county_map$subregion=="washington" & county_map$group==289,]$subregion<-"district of columbia"
county_map[county_map$subregion=="yellowstone",]$subregion<-"yellowstone national"

for (n in 1:nrow(county_map))
{county_map$stateID[n]<-state_lowercase[state_lowercase$states==county_map$region[n],]$stateID
county_map$countyID[n]<-countyxref[countyxref$repstatefips==county_map$stateID[n] & countyxref$written_name==county_map$subregion[n],]$indfullname}
Sys.time()      
print("Step 2.60")
#countypopulation
countypopulation=read.csv(population_table,skip=2)
colnames(countypopulation)=c("FIP","name","population")


#Hotelling_mastertable_summary
Hotelling_mastertable_summary<-read.csv(Hotelling, header=FALSE,skip=38,blank.lines.skip=TRUE)
colnames(Hotelling_mastertable_summary)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment")

Hotelling_mastertable_summary$power_unit<-0

Hotelling_mastertable_summary$county_total_engine<-0
Hotelling_mastertable_summary$county_total_auxiliary<-0
Hotelling_mastertable_summary$county_total<-0

Hotelling_mastertable_summary$nat_total_engine<-0
Hotelling_mastertable_summary$nat_total_auxiliary<-0
Hotelling_mastertable_summary$nat_total<-0

Hotelling_mastertable_summary[Hotelling_mastertable_summary$scc==2202620153,]$power_unit<-"auxiliary"
Hotelling_mastertable_summary[Hotelling_mastertable_summary$scc==2202620191,]$power_unit<-"engine"

Hotelling_mastertable_summary$nat_total_engine<-sum(Hotelling_mastertable_summary[Hotelling_mastertable_summary$scc==2202620191,]$ann_value)
Hotelling_mastertable_summary$nat_total_auxiliary<-sum(Hotelling_mastertable_summary[Hotelling_mastertable_summary$scc==2202620153,]$ann_value)
Hotelling_mastertable_summary$nat_total<-sum(Hotelling_mastertable_summary$ann_value)

Sys.time()     
print("Step 2.70")

countylist=countyxref[countyxref$indfullname %in% Hotelling_mastertable_summary$region_cd,]$indfullname
for(n in 1:length(countylist))
{nn=countylist[n]
Hotelling_mastertable_summary[Hotelling_mastertable_summary$region_cd==nn,]$county_total_engine<-sum(Hotelling_mastertable_summary[Hotelling_mastertable_summary$power_unit=="engine" & Hotelling_mastertable_summary$region_cd==nn,]$ann_value) 
Hotelling_mastertable_summary[Hotelling_mastertable_summary$region_cd==nn,]$county_total_auxiliary<-sum(Hotelling_mastertable_summary[Hotelling_mastertable_summary$power_unit=="auxiliary" & Hotelling_mastertable_summary$region_cd==nn,]$ann_value) 
Hotelling_mastertable_summary[Hotelling_mastertable_summary$region_cd==nn,]$county_total<-sum(Hotelling_mastertable_summary[Hotelling_mastertable_summary$region_cd==nn,]$ann_value) 

}
Sys.time()     
print("Step 2.80")
#monthID
monthid=c(1,2,3,4,5,6,7,8,9,10,11,12)
monthname=c("January","February","March","April","May","June","July","August","September","October","November","December")
monthID=data.frame(monthid,monthname)


#sourcetypetable
a=c(11,21,31,32,41,42,43,51,52,53,54,61,62)
b= c("Motorcycles","Passenger_Cars","Passenger_Trucks","Light_Commercial Trucks","Intercity_Buses","Transit_Buses","School_Buses","Refuse_Trucks","Single_Unit_Shorthaul_Trucks","Single_Unit_Longhaul_Trucks","Motor_Homes","Combination_Shorthaul_Trucks","Combination_Longhaul_Trucks") 
sourcetypetable=data.frame(a,b)
colnames(sourcetypetable)=c("typeID","sourcetype")
Sys.time()     
print("Step 2.90")
#Speed_mastertable_summary

Speed_mastertable_summary<-read.csv(Speed,header=FALSE,skip=28,blank.lines.skip=TRUE)
colnames(Speed_mastertable_summary)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment")

Speed_mastertable_summary$roadtype<-0
Speed_mastertable_summary[Speed_mastertable_summary$scc %in% c(2201110200,2201210200,2201310200,2201320200,2201410200,2201420200,2201430200,2201510200,2201520200,2201530200,2201540200,2201610200,2201620200,2202110200,2202210200,2202310200,2202320200,2202410200,2202420200,2202430200,2202510200,2202520200,2202530200,2202540200,2202610200,2202620200,2203420200),]$roadtype<-"rural_restricted"
Speed_mastertable_summary[Speed_mastertable_summary$scc %in% c(2201110300,2201210300,2201310300,2201320300,2201410300,2201420300,2201430300,2201510300,2201520300,2201530300,2201540300,2201610300,2201620300,2202110300,2202210300,2202310300,2202320300,2202410300,2202420300,2202430300,2202510300,2202520300,2202530300,2202540300,2202610300,2202620300,2203420300),]$roadtype<-"rural_unrestricted"
Speed_mastertable_summary[Speed_mastertable_summary$scc %in% c(2201110400,2201210400,2201310400,2201320400,2201410400,2201420400,2201430400,2201510400,2201520400,2201530400,2201540400,2201610400,2201620400,2202110400,2202210400,2202310400,2202320400,2202410400,2202420400,2202430400,2202510400,2202520400,2202530400,2202540400,2202610400,2202620400,2203420400),]$roadtype<-"urban_restricted"
Speed_mastertable_summary[Speed_mastertable_summary$scc %in% c(2201110500,2201210500,2201310500,2201320500,2201410500,2201420500,2201430500,2201510500,2201520500,2201530500,2201540500,2201610500,2201620500,2202110500,2202210500,2202310500,2202320500,2202410500,2202420500,2202430500,2202510500,2202520500,2202530500,2202540500,2202610500,2202620500,2203420500),]$roadtype<-"urban_unrestricted"

Speed_mastertable_summary$sourcetype<-0
Speed_mastertable_summary[Speed_mastertable_summary$scc%in% c(2201110200,2201110300,2201110400,2201110500,2201210200,2201210300,2201210400,2201210500,2202210200,2202210300,2202210400,2202210500),]$sourcetype<-"passenger_cars"
Speed_mastertable_summary[Speed_mastertable_summary$scc%in% c(2201310200,2201310300,2201310400,2201310500,2202310200,2202310300,2202310400,2202310500,2201320200,2201320300,2201320400,2201320500,2202320200,2202320300,2202320400,2202320500),]$sourcetype<-"passenger_trucks"
Speed_mastertable_summary[Speed_mastertable_summary$scc%in% c(2201410200,2201410300,2201410400,2201410500,2202410200,2202410300,2202410400,2202410500,2201420200,2201420300,2201420400,2201420500,2202420200,2202420300,2202420400,2202420500,2203420200,2203420300,2203420400,2203420500,2201430200,2201430300,2201430400,2201430500,2202430200,2202430300,2202430400,2202430500,2201510200,2201510300,2201510400,2201510500,2202510200,2202510300,2202510400,2202510500,2201520200,2201520300,2201520400,2201520500,2202520200,2202520300,2202520400,2202520500,2201530200,2201530300,2201530400,2201530500,2202530200,2202530300,2202530400,2202530500,2201540200,2201540300,2201540400,2201540500,2202540200,2202540300,2202540400,2202540500),]$sourcetype<-"miscellaneous_trucks"
Speed_mastertable_summary[Speed_mastertable_summary$scc%in% c(2201610200,2201610300,2201610400,2201610500,2202610200,2202610300,2202610400,2202610500,2201620200,2201620300,2201620400,2201620500,2202620200,2202620300,2202620400,2202620500),]$sourcetype<-"combination_trucks"

#speedpro_mastertable_summary
Speedpro_mastertable<-read.csv(Speedpro,header=FALSE,skip=19,blank.lines.skip=TRUE)
Speedpro_mastertable_summary<-read.csv(Speedpro,header=FALSE,skip=19,blank.lines.skip=TRUE)
colnames(Speedpro_mastertable_summary)=c("region_cd","scc","weekday","hr01a","hr02a","hr03a","hr04a","hr05a","hr06a","hr07a","hr08a","hr09a","hr10a","hr11a","hr12a","hr13a","hr14a","hr15a","hr16a","hr17a","hr18a","hr19a","hr20a","hr21a","hr22a","hr23a","hr24a","weekend","hr01b","hr02b","hr03b","hr04b","hr05b","hr06b","hr07b","hr08b","hr09b","hr10b","hr11b","hr12b","hr13b","hr14b","hr15b","hr16b","hr17b","hr18b","hr19b","hr20b","hr21b","hr22b","hr23b","hr24b","")
colnames(Speedpro_mastertable)=c("region_cd","scc","weekday","hr01a","hr02a","hr03a","hr04a","hr05a","hr06a","hr07a","hr08a","hr09a","hr10a","hr11a","hr12a","hr13a","hr14a","hr15a","hr16a","hr17a","hr18a","hr19a","hr20a","hr21a","hr22a","hr23a","hr24a","weekend","hr01b","hr02b","hr03b","hr04b","hr05b","hr06b","hr07b","hr08b","hr09b","hr10b","hr11b","hr12b","hr13b","hr14b","hr15b","hr16b","hr17b","hr18b","hr19b","hr20b","hr21b","hr22b","hr23b","hr24b","")

Speedpro_mastertable_summary$roadtype<-0
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc %in% c(2201110200,2201210200,2201310200,2201320200,2201410200,2201420200,2201430200,2201510200,2201520200,2201530200,2201540200,2201610200,2201620200,2202110200,2202210200,2202310200,2202320200,2202410200,2202420200,2202430200,2202510200,2202520200,2202530200,2202540200,2202610200,2202620200,2203110200,2203210200,2203310200,2203320200,2203410200,2203420200,2203430200,2203510200,2203520200,2203530200,2203540200,2203610200,2203620200,2205110200,2205210200,2205310200,2205320200,2205410200,2205420200,2205430200,2205510200,2205520200,2205530200,2205540200,2205610200,2205620200,2209110200,2209210200,2209310200,2209320200,2209410200,2209420200,2209430200,2209510200,2209520200,2209530200,2209540200,2209610200,2209620200),]$roadtype<-"rural_restricted"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc %in% c(2201110300,2201210300,2201310300,2201320300,2201410300,2201420300,2201430300,2201510300,2201520300,2201530300,2201540300,2201610300,2201620300,2202110300,2202210300,2202310300,2202320300,2202410300,2202420300,2202430300,2202510300,2202520300,2202530300,2202540300,2202610300,2202620300,2203110300,2203210300,2203310300,2203320300,2203410300,2203420300,2203430300,2203510300,2203520300,2203530300,2203540300,2203610300,2203620300,2205110300,2205210300,2205310300,2205320300,2205410300,2205420300,2205430300,2205510300,2205520300,2205530300,2205540300,2205610300,2205620300,2209110300,2209210300,2209310300,2209320300,2209410300,2209420300,2209430300,2209510300,2209520300,2209530300,2209540300,2209610300,2209620300),]$roadtype<-"rural_unrestricted"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc %in% c(2201110400,2201210400,2201310400,2201320400,2201410400,2201420400,2201430400,2201510400,2201520400,2201530400,2201540400,2201610400,2201620400,2202110400,2202210400,2202310400,2202320400,2202410400,2202420400,2202430400,2202510400,2202520400,2202530400,2202540400,2202610400,2202620400,2203110400,2203210400,2203310400,2203320400,2203410400,2203420400,2203430400,2203510400,2203520400,2203530400,2203540400,2203610400,2203620400,2205110400,2205210400,2205310400,2205320400,2205410400,2205420400,2205430400,2205510400,2205520400,2205530400,2205540400,2205610400,2205620400,2209110400,2209210400,2209310400,2209320400,2209410400,2209420400,2209430400,2209510400,2209520400,2209530400,2209540400,2209610400,2209620400),]$roadtype<-"urban_restricted"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc %in% c(2201110500,2201210500,2201310500,2201320500,2201410500,2201420500,2201430500,2201510500,2201520500,2201530500,2201540500,2201610500,2201620500,2202110500,2202210500,2202310500,2202320500,2202410500,2202420500,2202430500,2202510500,2202520500,2202530500,2202540500,2202610500,2202620500,2203110500,2203210500,2203310500,2203320500,2203410500,2203420500,2203430500,2203510500,2203520500,2203530500,2203540500,2203610500,2203620500,2205110500,2205210500,2205310500,2205320500,2205410500,2205420500,2205430500,2205510500,2205520500,2205530500,2205540500,2205610500,2205620500,2209110500,2209210500,2209310500,2209320500,2209410500,2209420500,2209430500,2209510500,2209520500,2209530500,2209540500,2209610500,2209620500),]$roadtype<-"urban_unrestricted"


Speedpro_mastertable_summary$sourcetype<-0
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc%in% c(2201110200,2201110300,2201110400,2201110500,2201210200,2201210300,2201210400,2201210500,2202110200,2202110300,2202110400,2202110500,2202210200,2202210300,2202210400,2202210500,2203110200,2203110300,2203110400,2203110500,2203210200,2203210300,2203210400,2203210500,2205110200,2205110300,2205110400,2205110500,2205210200,2205210300,2205210400,2205210500,2209110200,2209110300,2209110400,2209110500,2209210200,2209210300,2209210400,2209210500),]$sourcetype<-"passenger_cars"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc%in% c(2201310200,2201310300,2201310400,2201310500,2202310200,2202310300,2202310400,2202310500,2203310200,2203310300,2203310400,2203310500,2205310200,2205310300,2205310400,2205310500,2209310200,2209310300,2209310400,2209310500,2201320200,2201320300,2201320400,2201320500,2202320200,2202320300,2202320400,2202320500,2203320200,2203320300,2203320400,2203320500,2205320200,2205320300,2205320400,2205320500,2209320200,2209320300,2209320400,2209320500),]$sourcetype<-"passenger_trucks"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc%in% c(2201410200,2201410300,2201410400,2201410500,2202410200,2202410300,2202410400,2202410500,2203410200,2203410300,2203410400,2203410500,2205410200,2205410300,2205410400,2205410500,2209410200,2209410300,2209410400,2209410500,2201420200,2201420300,2201420400,2201420500,2202420200,2202420300,2202420400,2202420500,2203420200,2203420300,2203420400,2203420500,2205420200,2205420300,2205420400,2205420500,2209420200,2209420300,2209420400,2209420500,2201430200,2201430300,2201430400,2201430500,2202430200,2202430300,2202430400,2202430500,2203430200,2203430300,2203430400,2203430500,2205430200,2205430300,2205430400,2205430500,2209430200,2209430300,2209430400,2209430500,2201510200,2201510300,2201510400,2201510500,2202510200,2202510300,2202510400,2202510500,2203510200,2203510300,2203510400,2203510500,2205510200,2205510300,2205510400,2205510500,2209510200,2209510300,2209510400,2209510500,2201520200,2201520300,2201520400,2201520500,2202520200,2202520300,2202520400,2202520500,2203520200,2203520300,2203520400,2203520500,2205520200,2205520300,2205520400,2205520500,2209520200,2209520300,2209520400,2209520500,2201530200,2201530300,2201530400,2201530500,2202530200,2202530300,2202530400,2202530500,2203530200,2203530300,2203530400,2203530500,2205530200,2205530300,2205530400,2205530500,2209530200,2209530300,2209530400,2209530500,2201540200,2201540300,2201540400,2201540500,2202540200,2202540300,2202540400,2202540500,2203540200,2203540300,2203540400,2203540500,2205540200,2205540300,2205540400,2205540500,2209540200,2209540300,2209540400,2209540500),]$sourcetype<-"miscellaneous_trucks"
Speedpro_mastertable_summary[Speedpro_mastertable_summary$scc%in% c(2201610200,2201610300,2201610400,2201610500,2202610200,2202610300,2202610400,2202610500,2203610200,2203610300,2203610400,2203610500,2205610200,2205610300,2205610400,2205610500,2209610200,2209610300,2209610400,2209610500,2201620200,2201620300,2201620400,2201620500,2202620200,2202620300,2202620400,2202620500,2203620200,2203620300,2203620400,2203620500,2205620200,2205620300,2205620400,2205620500,2209620200,2209620300,2209620400,2209620500),]$sourcetype<-"combination_trucks"

Sys.time()     
print("Step 2.91")


#state_map
state_map <- map_data("state")
colnames(state_map)=c("long","lat","groups","order","region","subregion")


#VMT_mastertable_summary

VMT_mastertable_summary<-read.csv(VMT,header=FALSE,skip=33,blank.lines.skip=TRUE)
colnames(VMT_mastertable_summary)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment")

VMT_mastertable_summary$roadtype<-0
VMT_mastertable_summary[VMT_mastertable_summary$scc %in% c(2201110200,2201210200,2201310200,2201320200,2201410200,2201420200,2201430200,2201510200,2201520200,2201530200,2201540200,2201610200,2201620200,2202110200,2202210200,2202310200,2202320200,2202410200,2202420200,2202430200,2202510200,2202520200,2202530200,2202540200,2202610200,2202620200,2203420200),]$roadtype<-"rural_restricted"
VMT_mastertable_summary[VMT_mastertable_summary$scc %in% c(2201110300,2201210300,2201310300,2201320300,2201410300,2201420300,2201430300,2201510300,2201520300,2201530300,2201540300,2201610300,2201620300,2202110300,2202210300,2202310300,2202320300,2202410300,2202420300,2202430300,2202510300,2202520300,2202530300,2202540300,2202610300,2202620300,2203420300),]$roadtype<-"rural_unrestricted"
VMT_mastertable_summary[VMT_mastertable_summary$scc %in% c(2201110400,2201210400,2201310400,2201320400,2201410400,2201420400,2201430400,2201510400,2201520400,2201530400,2201540400,2201610400,2201620400,2202110400,2202210400,2202310400,2202320400,2202410400,2202420400,2202430400,2202510400,2202520400,2202530400,2202540400,2202610400,2202620400,2203420400),]$roadtype<-"urban_restricted"
VMT_mastertable_summary[VMT_mastertable_summary$scc %in% c(2201110500,2201210500,2201310500,2201320500,2201410500,2201420500,2201430500,2201510500,2201520500,2201530500,2201540500,2201610500,2201620500,2202110500,2202210500,2202310500,2202320500,2202410500,2202420500,2202430500,2202510500,2202520500,2202530500,2202540500,2202610500,2202620500,2203420500),]$roadtype<-"urban_unrestricted"

VMT_mastertable_summary$sourcetype<-0
VMT_mastertable_summary[VMT_mastertable_summary$scc%in% c(2201110200,2201110300,2201110400,2201110500,2201210200,2201210300,2201210400,2201210500,2202210200,2202210300,2202210400,2202210500),]$sourcetype<-"passenger_cars"
VMT_mastertable_summary[VMT_mastertable_summary$scc%in% c(2201310200,2201310300,2201310400,2201310500,2202310200,2202310300,2202310400,2202310500,2201320200,2201320300,2201320400,2201320500,2202320200,2202320300,2202320400,2202320500),]$sourcetype<-"passenger_trucks"
VMT_mastertable_summary[VMT_mastertable_summary$scc%in% c(2201410200,2201410300,2201410400,2201410500,2202410200,2202410300,2202410400,2202410500,2201420200,2201420300,2201420400,2201420500,2202420200,2202420300,2202420400,2202420500,2203420200,2203420300,2203420400,2203420500,2201430200,2201430300,2201430400,2201430500,2202430200,2202430300,2202430400,2202430500,2201510200,2201510300,2201510400,2201510500,2202510200,2202510300,2202510400,2202510500,2201520200,2201520300,2201520400,2201520500,2202520200,2202520300,2202520400,2202520500,2201530200,2201530300,2201530400,2201530500,2202530200,2202530300,2202530400,2202530500,2201540200,2201540300,2201540400,2201540500,2202540200,2202540300,2202540400,2202540500),]$sourcetype<-"miscellaneous_trucks"
VMT_mastertable_summary[VMT_mastertable_summary$scc%in% c(2201610200,2201610300,2201610400,2201610500,2202610200,2202610300,2202610400,2202610500,2201620200,2201620300,2201620400,2201620500,2202620200,2202620300,2202620400,2202620500),]$sourcetype<-"combination_trucks"

counties=countyxref$indfullname 
counties=counties[counties %in% VMT_mastertable_summary$region_cd]

VMT_mastertable_summary$countytot_rr<-0
VMT_mastertable_summary$countytot_uu<-0
VMT_mastertable_summary$countytot_ru<-0
VMT_mastertable_summary$countytot_ur<-0

VMT_mastertable_summary$countytot_pc<-0
VMT_mastertable_summary$countytot_pt<-0
VMT_mastertable_summary$countytot_mt<-0
VMT_mastertable_summary$countytot_ct<-0

VMT_mastertable_summary$county_total<-0

VMT_mastertable_summary$nat_tot_interstate<-0
VMT_mastertable_summary$nat_tot_local<-0

VMT_mastertable_summary$nat_total_pc<-0
VMT_mastertable_summary$nat_total_pt<-0
VMT_mastertable_summary$nat_total_mt<-0
VMT_mastertable_summary$nat_total_ct<-0

Sys.time()      
print("Step 2.92")

for (n in 1:length(counties))
{nn=counties[n]
newdata=VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]
countytotalrr=sum(newdata[newdata$roadtype=="rural_restricted",]$ann_value)
countytotaluu=sum(newdata[newdata$roadtype=="urban_unrestricted",]$ann_value)
countytotalru=sum(newdata[newdata$roadtype=="rural_unrestricted",]$ann_value)
countytotalur=sum(newdata[newdata$roadtype=="urban_restricted",]$ann_value)

countytotalpc=sum(newdata[newdata$sourcetype=="passenger_cars",]$ann_value)
countytotalpt=sum(newdata[newdata$sourcetype=="passenger_trucks",]$ann_value)
countytotalmt=sum(newdata[newdata$sourcetype=="miscellaneous_trucks",]$ann_value)
countytotalct=sum(newdata[newdata$sourcetype=="combination_trucks",]$ann_value)

VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_rr<-countytotalrr
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_uu<-countytotaluu
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_ru<-countytotalru
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_ur<-countytotalur

VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_pc<-countytotalpc
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_pt<-countytotalpt
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_mt<-countytotalmt
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$countytot_ct<-countytotalct
VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$county_total<-sum(newdata$ann_value)
}

VMT_mastertable_summary$nat_tot_local<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype %in% c("urban_unrestricted","rural_unrestricted"),]$ann_value)
VMT_mastertable_summary$nat_tot_interstate<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype %in% c("urban_restricted","rural_restricted"),]$ann_value)

VMT_mastertable_summary$nat_total_pc<-sum(VMT_mastertable_summary[VMT_mastertable_summary$sourcetype == "passenger_cars",]$ann_value)
VMT_mastertable_summary$nat_total_pt<-sum(VMT_mastertable_summary[VMT_mastertable_summary$sourcetype == "passenger_trucks",]$ann_value)
VMT_mastertable_summary$nat_total_mt<-sum(VMT_mastertable_summary[VMT_mastertable_summary$sourcetype == "miscellaneous_trucks",]$ann_value)
VMT_mastertable_summary$nat_total_ct<-sum(VMT_mastertable_summary[VMT_mastertable_summary$sourcetype == "combination_trucks",]$ann_value)

VMT_mastertable_summary$nat_total_rr<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype == "rural_restricted",]$ann_value)
VMT_mastertable_summary$nat_total_uu<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype == "urban_unrestricted",]$ann_value)
VMT_mastertable_summary$nat_total_ru<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype == "rural_unrestricted",]$ann_value)
VMT_mastertable_summary$nat_total_ur<-sum(VMT_mastertable_summary[VMT_mastertable_summary$roadtype == "urban_restricted",]$ann_value)



#VPOP_mastertable_summary

VPOP_mastertable_summary<-read.csv(VPOP,header=FALSE,skip=31,blank.lines.skip=TRUE)
colnames(VPOP_mastertable_summary)=c("country_cd","region_cd","tribal_code","census_tract_cd","shape_id","scc","CD","MSR","activity_type","ann_value","calc_year","date_updated","data_set_id","jan_val","feb_val","mar_val","apr_val","may_val","jun_val","jul_val","aug_val","sep_val","oct_val","nov_val","dec_val","comment")



VPOP_mastertable_summary$sourcetype<-0
VPOP_mastertable_summary[VPOP_mastertable_summary$scc%in% c(2201110100,2201110300,2201110400,2201110500,2201210100,2201210300,2201210400,2201210500,2202210100,2202210300,2202210400,2202210500),]$sourcetype<-"passenger_cars"
VPOP_mastertable_summary[VPOP_mastertable_summary$scc%in% c(2201310100,2201310300,2201310400,2201310500,2202310100,2202310300,2202310400,2202310500,2201320100,2201320300,2201320400,2201320500,2202320100,2202320300,2202320400,2202320500),]$sourcetype<-"passenger_trucks"
VPOP_mastertable_summary[VPOP_mastertable_summary$scc%in% c(2201410100,2201410300,2201410400,2201410500,2202410100,2202410300,2202410400,2202410500,2201420100,2201420300,2201420400,2201420500,2202420100,2202420300,2202420400,2202420500,2203420100,2203420300,2203420400,2203420500,2201430100,2201430300,2201430400,2201430500,2202430100,2202430300,2202430400,2202430500,2201510100,2201510300,2201510400,2201510500,2202510100,2202510300,2202510400,2202510500,2201520100,2201520300,2201520400,2201520500,2202520100,2202520300,2202520400,2202520500,2201530100,2201530300,2201530400,2201530500,2202530100,2202530300,2202530400,2202530500,2201540100,2201540300,2201540400,2201540500,2202540100,2202540300,2202540400,2202540500),]$sourcetype<-"miscellaneous_trucks"
VPOP_mastertable_summary[VPOP_mastertable_summary$scc%in% c(2201610100,2201610300,2201610400,2201610500,2202610100,2202610300,2202610400,2202610500,2201620100,2201620300,2201620400,2201620500,2202620100,2202620300,2202620400,2202620500),]$sourcetype<-"combination_trucks"

counties=countyxref$indfullname 
counties=counties[counties %in% VPOP_mastertable_summary$region_cd]

VPOP_mastertable_summary$county_passenger_cars<-0
VPOP_mastertable_summary$county_passenger_trucks<-0
VPOP_mastertable_summary$county_miscellaneous_trucks<-0
VPOP_mastertable_summary$county_combination_trucks<-0
VPOP_mastertable_summary$county_total<-0

Sys.time()     
print("Step 2.94")

for(n in 1:length(counties))
{nn=counties[n]
newdata=VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]
VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_passenger_cars<-sum(newdata[newdata$sourcetype=="passenger_cars",]$ann_value)
VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_passenger_trucks<-sum(newdata[newdata$sourcetype=="passenger_trucks",]$ann_value)
VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_miscellaneous_trucks<-sum(newdata[newdata$sourcetype=="miscellaneous_trucks",]$ann_value)
VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_combination_trucks<-sum(newdata[newdata$sourcetype=="combination_trucks",]$ann_value)
VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_total<-sum(newdata$ann_value)
}  
rm(newdata)
Sys.time()      
print("Step 2.95")

#create individual plot folders for each state 

for (n in 1:nrow(state_lowercase))
{dir.create(file.path(ggsave_statepath,state_lowercase$states[n]))}
Sys.time()  
readline(paste("Place groups of plot functions in corresponding folders inside of the following directory and press enter:",Source_Directory,sep=" "))

print("Step 2.96")                                                                  

