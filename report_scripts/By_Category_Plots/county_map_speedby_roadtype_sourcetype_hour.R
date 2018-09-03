#source_type must be entered as ("passenger_cars","passenger_trucks","miscellaneous_trucks",combination_trucks")
#road_type must be entered as ("rural_unrestricted",rural_restricted","urban_unrestricted","urban_restricted")
county_map_speedby_roadtype_sourcetype_hour <- function (road_type,source_type,hour_id) {
  
  
  
  newdata=county_map
  
  #add calculated columns for plotting
  newdata$speed<-0
  newdata$speed_cat<-0
  
  countylist=countyxref[countyxref$indfullname %in% newdata$countyID,]$indfullname
  
  xx=length(countylist)
  #add value to calculated columns
  for(n in 1:xx)
  {nn=countylist[n]
  newdata[newdata$countyID==nn,]$speed<-mean(Speedpro_mastertable_summary[Speedpro_mastertable_summary$region_cd==nn & Speedpro_mastertable_summary$roadtype==road_type & Speedpro_mastertable_summary$sourcetype==source_type,hour_id+3])
  }
  #define bins to categorize calculated values
  bins=newdata$speed
  aa=min(newdata$speed)
  bb=max(newdata$speed)
  bins2=seq(from=aa,to=bb,by=(bb-aa)/9)
  
  #assign rows to bins
  for (n in 1:nrow(newdata))
  { 
    if (newdata$speed[n]<=bins2[2])
    {newdata$speed_cat[n]<-1}
    else if(newdata$speed[n]>bins2[2] & newdata$speed[n]<=bins2[3])
    {newdata$speed_cat[n]<-2}
    else if(newdata$speed[n]>bins2[3] & newdata$speed[n]<=bins2[4])
    {newdata$speed_cat[n]<-3}
    else if(newdata$speed[n]>bins2[4] & newdata$speed[n]<=bins2[5])
    {newdata$speed_cat[n]<-4}
    else if(newdata$speed[n]>bins2[5] & newdata$speed[n]<=bins2[6])
    {newdata$speed_cat<-5}
    else if(newdata$speed[n]>bins2[6] & newdata$speed[n]<=bins2[7])
    {newdata$speed_cat[n]<-6}
    else if(newdata$speed[n]>bins2[7] & newdata$speed[n]<=bins2[8])
    {newdata$speed_cat[n]<-7}
    else if(newdata$speed[n]>bins2[8] & newdata$speed[n]<=bins2[9])
    {newdata$speed_cat[n]<-8}
    else if(newdata$speed[n]>bins2[9] & newdata$speed[n]<=bins2[10])
    {newdata$speed_cat[n]<-9}
  
  }
  
  #define palette of colors
  red_pal <- c("#FFFFFF","#FF99CC","#FF6699","#FF0066","#FF0000","#CC0000","#990000","#660000","#330000")
  
  theme_clean <- function(base_size = 12) {
    require(grid)
    theme_grey(base_size) %+replace%
      theme(
        axis.title      =   element_blank(),
        axis.text       =   element_blank(),
        panel.background    =   element_blank(),
        panel.grid      =   element_blank(),
        axis.ticks.length   =   unit(0,"cm"),
        axis.ticks.margin   =   unit(0,"cm"),
        panel.margin    =   unit(0,"lines"),
        plot.margin     =   unit(c(0,0,0,0),"lines"),
        complete = TRUE
      )
  }
  hourid=toString(hour_id)
  tit=paste(hourid,paste(toString(road_type),toString(source_type),sep="_"),sep="_")
  #make county plot
  g=ggplot( newdata, aes( x = long , y = lat , group=group ) ) +
    geom_polygon( colour = "grey" , aes( fill = factor( speed_cat ) ) ) +
    scale_fill_manual( values = red_pal,labels=c(paste("x <=",toString(format(round(bins2[2],2))),sep=" "),paste(paste(toString(format(round(bins2[2],2))),"< x <=",sep=" "),toString(format(round(bins2[3],2))),sep=" "),paste(paste(toString(format(round(bins2[3],2))),"< x <=",sep=" "),toString(format(round(bins2[4],2))),sep=" "),paste(paste(toString(format(round(bins2[4],2))),"< x <=",sep=" "),toString(format(round(bins2[5],2))),sep=" "),paste(paste(toString(format(round(bins2[5],2))),"< x <=",sep=" "),toString(format(round(bins2[6],2))),sep=" "),paste(paste(toString(format(round(bins2[6],2))),"< x <=",sep=" "),toString(format(round(bins2[7],2))),sep=" "),paste(paste(toString(format(round(bins2[7],2))),"< x <=",sep=" "),toString(format(round(bins2[8],2))),sep=" "),paste(paste(toString(format(round(bins2[8],2))),"< x <=",sep=" "),toString(format(round(bins2[9],2))),sep=" "),paste(paste(toString(format(round(bins2[9],2))),"< x <=",sep=" "),toString(format(round(bins2[10],2))),sep=" "))) +
    expand_limits( x = newdata$long, y = newdata$lat ) +
    coord_map( "polyconic" ) + 
    labs(fill="Speed (mph)") + 
    theme_clean( ) 
  #add state plot layer
  g=g+geom_path( data = state_map,aes(x=long,y=lat,group=groups) , colour = "black")+labs(title=paste("Speed for",tit,sep=" "))+theme(title=element_text(size=20))
  #add LADCO footer
  g=arrangeGrob(g,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory
  gg_pathttt=paste(ggsave_countrypath,"\\county_map_speedby_roadtype_sourcetype_hour_",sep="")
  fname=paste(tit,".png",sep="")
  ggsave(plot = g,file=paste(gg_pathttt,fname,sep=""), type = "cairo-png")
  
  return(g)
}