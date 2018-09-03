
#month_id must be entered as number 1-12

Drafthours_bycounty_ageID_month <- function (county_id,month_id) {
  
  if(county_id<10000)
  {county_id=toString(county_id)
  county_id=paste("0",county_id,sep="")
  }
  else
  {county_id=toString(county_id)}
  
  if(county_id %in% drafthours$countyid)
  { 
    
  #cut down dataframe to match inputs
  newdata=drafthours[drafthours$countyid==county_id & drafthours$monthid==month_id,]
  
  graphtit=toString(county_id)
  graphtit2=paste(toString(monthID[monthID$monthid==month_id,]$monthname),graphtit,sep=" ")
  
  final=ggplot(data=newdata,aes(x=factor(hourid),y=drafthours,colour=factor(ageid),shape=factor(ageid)))+geom_line(aes(group=ageid),size=1)+geom_point(size=7)+scale_shape_manual(values=1:31)+theme(plot.background = element_rect(fill = '#FF6633'),axis.text=element_text(color="black"),axis.text=element_text(size=12),axis.title=element_text(size=15),title=element_text(size=20),legend.position="top")+labs(title=sprintf("Draft Hours by Hour for the Month of %s (MOVES)",graphtit2),x="Hour",y="Draft Hours")

  #add LADCO footer
  final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory 
  monthid=monthID[monthID$monthid==month_id,]$monthname
  
  county_id2=as.numeric(county_id)
  stateid=countyxref[countyxref$indfullname==county_id2,]$statefips
  stateid=state_lowercase[state_lowercase$stateID==stateid,]$states
  
  gg_path=paste(ggsave_statepath,paste("\\",stateid,sep=""),sep="")
  gg_path=paste(gg_path,paste("\\Drafthours_bycounty_ageID_month_",county_id,sep=""),sep="")
  gg_path=paste(gg_path,monthid,sep="_")
  gg_path=paste(gg_path,".png",sep="")
  ggsave(plot = final,file=gg_path, type = "cairo-png")  
  return(final)}
  else
  {
    print(sprintf("county %s data not found",county_id))}
}
