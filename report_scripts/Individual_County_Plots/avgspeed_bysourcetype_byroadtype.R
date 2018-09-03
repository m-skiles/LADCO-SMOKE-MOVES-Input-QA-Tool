#county_id must be entered as character

avgspeed_bysourcetype_byroadtype <- function (county_id) 
  {
  if(county_id %in% Speed_mastertable_summary$region_cd)
  {
    
  #cut down dataframe to match inputs
  newdata=Speed_mastertable_summary[Speed_mastertable_summary$region_cd==county_id,]
  #add calculated column for plotting
  newdata$avgspeed<-0
  
  #add value to calculated column
  newdata[newdata$sourcetype=="passenger_cars",]$avgspeed<-mean(newdata[newdata$sourcetype=="passenger_cars",]$ann_value)
  newdata[newdata$sourcetype=="passenger_trucks",]$avgspeed<-mean(newdata[newdata$sourcetype=="passenger_trucks",]$ann_value)
  newdata[newdata$sourcetype=="miscellaneous_trucks",]$avgspeed<-mean(newdata[newdata$sourcetype=="miscellaneous_trucks",]$ann_value)
  newdata[newdata$sourcetype=="combination_trucks",]$avgspeed<-mean(newdata[newdata$sourcetype=="combination_trucks",]$ann_value)
  
  
  graphtit2=toString(county_id)
  final=qplot(data=newdata,x=factor(sourcetype),y=avgspeed,group=roadtype,shape=roadtype,colour=roadtype)+geom_line()+labs(y="Average Speed (mph)",x="Sourcetype",title=sprintf("Average Speed by Roadtype and Sourcetype %s",graphtit2))+geom_point(size=3)+theme(axis.text.x = element_text(vjust=0.5,size=12,color="black",angle=90),plot.background = element_rect(fill = '#FF0000'),axis.text.y=element_text(size=15,color="black"),axis.title=element_text(size=15),title=element_text(size=20))
  #add LADCO footer
  final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.3,gp=gpar(fontface="italic",fontsize=18)))

  #send plot to a directory
  statename=countyxref[countyxref$indfullname==county_id,]$statefips
statename=state_lowercase[state_lowercase$stateID==statename,]$states
state=paste("\\",statename,sep="")
state=paste(state,toString(county_id),sep="\\")
state=paste(state,statename,sep="\\")
fname=paste("_avgspeed_bysourcetype_byroadtype_",toString(county_id),sep="") 
gg_path=paste(paste(ggsave_statepath,state,sep=""),paste(fname,".png",sep=""),sep="")

ggsave(plot = final,file=paste(gg_path), type = "cairo-png")    
return(final)}
  else
  {
    print(sprintf("county %s data not found",county_id))}
}


