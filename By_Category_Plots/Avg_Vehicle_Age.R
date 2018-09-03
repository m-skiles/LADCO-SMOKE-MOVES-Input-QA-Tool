
#source_type must be entered as ID# i.e. (11,21,31,32.....)
Avg_Vehicle_Age <- function (source_type) {
   
  
  #cut down dataframe to match inputs
    newdata=eval(sourcetypeagedistribution[sourcetypeagedistribution$sourceTypeID==source_type,])
    #add calculated column for plotting
      newdata$int_col<-newdata$ageFraction*newdata$ageID
    newdata$tot_age<-0
    
    for (count in 1:nlevels(newdata$countyID))
    {
      if (count==1)
    {v3=sum(newdata$int_col[1:31])
    lh=32
    newdata$tot_age[1:31]<-v3}
      else
      {xx=count*31
      v4=sum(newdata$int_col[lh:xx])
        newdata$tot_age[lh:xx]<-v4
          lh=lh+31
          }
    }
   
     countylist=levels(newdata$countyID)
    #organize dataframe into format for plotting 
    for (count in 1:nlevels(newdata$countyID))
    {count2=countylist[count]
      if (count==1)
      {finaldata=newdata[newdata$countyID==count2,][1,]}
    else
    {intdata=newdata[newdata$countyID==count2,][1,]
      finaldata=rbind(finaldata,intdata)}
    }
    
     #add stateID column for x axis label
     finaldata$stateid<-0
    finaldata$stateid<-state[state$countyID==finaldata$countyID,]$stateName
     
    
    
    
    
    graphtit=toString(sourcetypetable[sourcetypetable$typeID==source_type,]$sourcetype)
  graphtit2=paste(graphtit,".png",sep="")
    
    final=ggplot(data=finaldata,aes(x=factor(stateid),y=tot_age))+geom_point(colour="blue")+labs(title=sprintf("Sourcetype %s Average Age by State (MOVES)",graphtit),x="Reference County Group by State",y="Average Age")+theme(axis.text.x = element_text(vjust=0.5,angle = 90,size=12,color="black"),plot.background = element_rect(fill = '#3366FF'),axis.text.y=element_text(size=15,color="black"),axis.title=element_text(size=15),title=element_text(size=20))
#add LADCO footer
     final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.6,gp=gpar(fontface="italic",fontsize=18)))
 #send plot to a directory
     gg_patht=paste(ggsave_countrypath,"\\Avg_Vehicle_Age_",sep="")
 ggsave(plot = final,file=paste(gg_patht,graphtit2,sep=""), type = "cairo-png")    
 
 return(print(final,vp=viewport(width=unit(1000,"points"), height=unit(600,"point"))))
    }
