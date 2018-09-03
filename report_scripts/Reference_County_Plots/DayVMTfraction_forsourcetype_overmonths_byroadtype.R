
#source_type_id must be entered as ID number i.e. (11,21,31,32.....)

  DayVMTfraction_forsourcetype_overmonths_byroadtype <- function (county_id,source_type_id) {
    
    if(county_id<10000)
    {county_id=toString(county_id)
    county_id=paste("0",county_id,sep="")
    }
    else
    {county_id=toString(county_id)}
    
    if(county_id %in% dayvmtfraction$countyID)
    { 
      
    #cut down dataframe to match inputs
     newdata=dayvmtfraction[dayvmtfraction$countyID==county_id & dayvmtfraction$sourceTypeID==source_type_id & dayvmtfraction$dayID==5,]
    
    graphtit=toString(sourcetypetable[sourcetypetable$typeID==source_type_id,]$sourcetype)
   
    graphtit2=paste(toString(county_id),graphtit,sep=" ")
    
    final=ggplot(data=newdata,aes(x=factor(monthID),y=dayVMTFraction,shape=factor(roadTypeID),colour=factor(roadTypeID)))+geom_line(aes(group=roadTypeID),size=1)+geom_point(size=7)+scale_shape_identity()+labs(title=sprintf("Fraction of VMT per Roadtype %s (MOVES)",graphtit2,sep=" "),x="Month",y="VMT Fraction")+theme(axis.text.x = element_text(vjust=0.5,size=12,color="black"),plot.background = element_rect(fill = '#00CC66'),axis.text.y=element_text(size=15,color="black"),axis.title=element_text(size=15),title=element_text(size=20))+annotate("text",x=8,y=0.6,label=c("2=rr 3=ru 4=ur 5=uu"))
  
    #add LADCO footer
    final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
    
    #send plot to a directory
    county_id2=as.numeric(county_id)
    stateid=countyxref[countyxref$indfullname==county_id2,]$statefips
    stateid=state_lowercase[state_lowercase$stateID==stateid,]$states
    
    sourceTypeID=sourcetypetable[sourcetypetable$typeID==source_type_id,]$sourcetype
    gg_path=paste(ggsave_statepath,paste("\\",stateid,sep=""),sep="")
    gg_path=paste(gg_path,paste("\\DayVMTfraction_forsourcetype_overmonths_byroadtype_",county_id,sep=""),sep="")
    gg_path=paste(gg_path,"_",sep="")
    gg_path=paste(gg_path,sourceTypeID,sep="")
    gg_path=paste(gg_path,".png",sep="")
    ggsave(plot = final,file=gg_path, type = "cairo-png")  
 
    return(final)}
    else
    {
      print(sprintf("county %s data not found",county_id))}
  }
  
  
