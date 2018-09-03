

MonthVMTfraction_bymonth <- function (county_id) {
  
  if(county_id<10000)
  {county_id=toString(county_id)
  county_id=paste("0",county_id,sep="")
  }
  else
  {county_id=toString(county_id)}
  
  if(county_id %in% monthvmtfraction$countyID)
  { 
    
  #cut down dataframe to match inputs
  newdata=monthvmtfraction[monthvmtfraction$countyID==county_id,]
  
  graphtit=toString(county_id)
  
  final=ggplot()+geom_histogram(data=newdata,aes(x=factor(monthID),y=(monthVMTFraction),fill=factor(sourceTypeID)),stat="identity",position="fill")+labs(title=sprintf("Fraction of VMT per Month by Sourcetype %s (MOVES)",graphtit),x="Month",y="VMT Fraction")+theme(axis.text.x = element_text(vjust=0.5,size=12,color="black"),plot.background = element_rect(fill = '#00CC66'),axis.text.y=element_text(size=15,color="black"),axis.title=element_text(size=15),title=element_text(size=20))
  
  #add LADCO footer
  final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory
  county_id2=as.numeric(county_id)
  stateid=countyxref[countyxref$indfullname==county_id2,]$statefips
  stateid=state_lowercase[state_lowercase$stateID==stateid,]$states
  
  
  gg_path=paste(ggsave_statepath,paste("\\",stateid,sep=""),sep="")
  gg_path=paste(gg_path,paste("\\MonthVMTfraction_bymonth_",county_id,sep=""),sep="")
  gg_path=paste(gg_path,".png",sep="")
  ggsave(plot = final,file=gg_path, type = "cairo-png")
  
  return(final)}
  else
  {
    print(sprintf("county %s data not found",county_id))}
}
