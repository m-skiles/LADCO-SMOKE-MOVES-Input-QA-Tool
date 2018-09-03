#road_type must be entered as ("rural_unrestricted",rural_restricted","urban_unrestricted","urban_restricted")
  passengercars_speed_vs_combinationtruck_speed <- function (road_type) {
    
    #cut down dataframe to match inputs
    newdata=Speed_mastertable_summary[Speed_mastertable_summary$scc %in% c(2201210200,2201210300,2201210400,2201210500,2202210200,2202210300,2202210400,2202210500,2201620200,2201620300,2201620400,2201620500,2202620200,2202620300,2202620400,2202620500) & Speed_mastertable_summary$roadtype==road_type,]
  
    counties=countyxref$indfullname 
    counties=counties[counties %in% newdata$region_cd]
    
    #add calculated column for plotting
    newdata$pass_speed<-0
    newdata$comb_speed<-0
    
    #add value to calculated column
    for (n in 1:length(counties))
    {nn=counties[n]
    newdata2=newdata[newdata$region_cd==nn,]
    newdata[newdata$region_cd==nn,]$pass_speed<-mean(newdata2[newdata2$sourcetype=="passenger_cars",]$ann_value)
    newdata[newdata$region_cd==nn,]$comb_speed<-mean(newdata2[newdata2$sourcetype=="combination_trucks",]$ann_value)
    }
    
    tit=toString(road_type)
  
    final=qplot(data=newdata,x=pass_speed,y=comb_speed,group=factor(region_cd),colour=region_cd)+scale_colour_gradient2(low="grey",high="red")+labs(title=sprintf("21 Speeds vs. 62 Speeds for %s",tit),x="21 Speeds",y="62 Speeds")+theme(axis.text.x = element_text(vjust=0.5,size=12,color="black"),plot.background = element_rect(fill = '#FF0000'),axis.text.y=element_text(size=15,color="black"),axis.title=element_text(size=15),title=element_text(size=20))
    #add LADCO footer
    final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
    
    #send plot to a directory
    gg_path=paste(ggsave_countrypath,"\\passengercar_speed_vs_combinationtruck_speed",sep="")
    gg_path=paste(gg_path,road_type,sep="_")
    gg_path=paste(gg_path,".png",sep="")
    ggsave(plot = final,file=gg_path, type = "cairo-png")   
     return(final)
    
  }

