
#source_type_id must be entered as number c(11,21,31,32....)
Average_Speed_by_Hour_Roadtype_sourcetype <- function (county_id,source_type_id) {
 
  if(county_id<10000)
  {county_id=toString(county_id)
  county_id=paste("0",county_id,sep="")
  }
  else
  {county_id=toString(county_id)}
  if(county_id %in% avgspeeddistribution$countyID)
  { 
    
  
   binspeed=c(2,5,10,15,20,25,30,35,40,45,50,55,60,65,70,73)
  hourlist=c(15,25,35,45,55,65,75,85,95,105,115,125,135,145,155,165,175,185,195,205,215,225,235,245)
  roadtypelist=c(2,3,4,5)
  #cut down dataframe to match inputs
   newdata=avgspeeddistribution[avgspeeddistribution$countyID==county_id & avgspeeddistribution$hourDayID%in% c(15,25,35,45,55,65,75,85,95,105,115,125,135,145,155,165,175,185,195,205,215,225,235,245) & avgspeeddistribution$sourceTypeID==source_type_id,]
   #add calculated column for plotting
   newdata$intcol<-0
  newdata$avgspeed<-0

  #add value to calculated column
for (n in 1:nrow(newdata))
{
  newdata$intcol[n]<-newdata[n,]$avgSpeedFraction*binspeed[newdata[n,]$avgSpeedBinID]
}
xx=nrow(newdata)/16

for (n in 1:xx){
  n1=n*16-15
  n2=n*16
  xxx=sum(newdata$intcol[n1:n2])
  
  newdata$avgspeed[n1:n2]<-xxx
}

newdata=newdata[newdata$avgSpeedBinID==1,]

newdata[newdata$hourDayID==15,]$hourDayID<-1
newdata[newdata$hourDayID==25,]$hourDayID<-2
newdata[newdata$hourDayID==35,]$hourDayID<-3
newdata[newdata$hourDayID==45,]$hourDayID<-4
newdata[newdata$hourDayID==55,]$hourDayID<-5
newdata[newdata$hourDayID==65,]$hourDayID<-6
newdata[newdata$hourDayID==75,]$hourDayID<-7
newdata[newdata$hourDayID==85,]$hourDayID<-8
newdata[newdata$hourDayID==95,]$hourDayID<-9
newdata[newdata$hourDayID==105,]$hourDayID<-10
newdata[newdata$hourDayID==115,]$hourDayID<-11
newdata[newdata$hourDayID==125,]$hourDayID<-12
newdata[newdata$hourDayID==135,]$hourDayID<-13
newdata[newdata$hourDayID==145,]$hourDayID<-14
newdata[newdata$hourDayID==155,]$hourDayID<-15
newdata[newdata$hourDayID==165,]$hourDayID<-16
newdata[newdata$hourDayID==175,]$hourDayID<-17
newdata[newdata$hourDayID==185,]$hourDayID<-18
newdata[newdata$hourDayID==195,]$hourDayID<-19
newdata[newdata$hourDayID==205,]$hourDayID<-20
newdata[newdata$hourDayID==215,]$hourDayID<-21
newdata[newdata$hourDayID==225,]$hourDayID<-22
newdata[newdata$hourDayID==235,]$hourDayID<-23
newdata[newdata$hourDayID==245,]$hourDayID<-24

sourcetypeID=toString(sourcetypetable[sourcetypetable$typeID==source_type_id,]$sourcetype)
county=toString(county_id)
sourcetype2=paste(toString(sourcetypeID),county,sep=" ")

ft <- function(){
  function(x) format(x,nsmall = 2,scientific = FALSE)
}

final=ggplot(data=newdata,aes(x=factor(hourDayID),y=avgspeed,colour=factor(roadTypeID),shape=factor(roadTypeID)))+geom_line(aes(group=roadTypeID),size=1)+geom_point(size=7)+scale_shape_identity()+labs(title=sprintf("Average Speed by Hour and Roadtype %s",sourcetype2),x="Hour",y="Average Speed (mph)")+theme(plot.background = element_rect(fill = '#FF0033'),axis.text=element_text(color="black"),axis.text=element_text(size=12),axis.title=element_text(size=15),title=element_text(size=20))+annotate("text",x=20,y=20,label=c("2=rr 3=ru 4=ur 5=uu"))

#add LADCO footer
final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))

#send plot to a directory 
county_id2=as.numeric(county_id)
stateid=countyxref[countyxref$indfullname==county_id2,]$statefips
stateid=state_lowercase[state_lowercase$stateID==stateid,]$states

gg_path=paste(ggsave_statepath,paste("\\",stateid,sep=""),sep="")
gg_path=paste(gg_path,paste("\\Average_Speed_by_Hour_Roadtype_sourcetype_",county_id,sep=""),sep="")
gg_path=paste(gg_path,sourcetypeID,sep="_")
gg_path=paste(gg_path,".png",sep="")
ggsave(plot = final,file=gg_path, type = "cairo-png")  

return(final)}
  else
  {
    print(sprintf("county %s data not found",county_id))}
}
