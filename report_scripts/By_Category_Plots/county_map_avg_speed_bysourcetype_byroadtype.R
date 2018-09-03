#source_type must be entered as ("passenger_cars","passenger_trucks","miscellaneous_trucks",combination_trucks")
#road_type must be entered as ("rural_unrestricted",rural_restricted","urban_unrestricted","urban_restricted")

county_map_avg_speed_bysourcetype_byroadtype <- function (source_type,road_type) {
  
  #cut down dataframe to match inputs
  map=county_map[county_map$countyID%in% Speed_mastertable_summary$region_cd,]
  #add calculated column for plotting
  map$meanspeed<-0
  map$meanspeed_cat<-0
  
  
  newdata2=Speed_mastertable_summary[Speed_mastertable_summary$roadtype==road_type & Speed_mastertable_summary$sourcetype==source_type & Speed_mastertable_summary$region_cd %in% county_map$countyID,]
  newdata2$meanspeed<-0
  
  
  counties=countyxref$indfullname 
  counties=counties[counties %in% newdata2$region_cd]
  
  #add value to calculated column
  for (n in 1:length(counties))
  {nn=counties[n]
  
  newdata=newdata2[newdata2$region_cd==nn,]
  avgspeed=mean(newdata$ann_value)
  
  newdata2[newdata2$region_cd==nn,]$meanspeed<-avgspeed
 
   }
  
  
  countylist=counties[counties %in% map$countyID]
  
  xx=length(countylist)
  
  
  for(n in 1:xx)
  {nn=countylist[n]
  map[map$countyID==nn,]$meanspeed<-newdata2[newdata2$region_cd==nn,]$meanspeed[1]
  }
  
  #define bins to categorize calculated values
  bins=map$meanspeed
  aa=min(map$meanspeed)
  bb=max(map$meanspeed)
  bins2=seq(from=aa,to=bb,by=(bb-aa)/9)
  
  
  #assign rows to bins
  for (n in 1:nrow(map))
  { 
  if (map$meanspeed[n]<=bins2[2])
          {map$meanspeed_cat[n]<-1}
  else if(map$meanspeed[n]>bins2[2] & map$meanspeed[n]<=bins2[3])
              {map$meanspeed_cat[n]<-2}
  else if(map$meanspeed[n]>bins2[3] & map$meanspeed[n]<=bins2[4])
    {map$meanspeed_cat[n]<-3}
  else if(map$meanspeed[n]>bins2[4] & map$meanspeed[n]<=bins2[5])
  {map$meanspeed_cat[n]<-4}
  else if(map$meanspeed[n]>bins2[5] & map$meanspeed[n]<=bins2[6])
  {map$meanspeed_cat<-5}
  else if(map$meanspeed[n]>bins2[6] & map$meanspeed[n]<=bins2[7])
    {map$meanspeed_cat[n]<-6}
  else if(map$meanspeed[n]>bins2[7] & map$meanspeed[n]<=bins2[8])
    {map$meanspeed_cat[n]<-7}
  else if(map$meanspeed[n]>bins2[8] & map$meanspeed[n]<=bins2[9])
    {map$meanspeed_cat[n]<-8}
  else if(map$meanspeed[n]>bins2[9] & map$meanspeed[n]<=bins2[10])
    {map$meanspeed_cat[n]<-9}
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
  
  
  title=source_type
  title2=paste(road_type,title,sep=" ")
  
  #make county plot
  g=ggplot( map, aes( x = long , y = lat , group=group ) ) +
    geom_polygon( colour = "grey" , aes( fill = factor( meanspeed_cat ) ) ) +
    scale_fill_manual( values = red_pal,labels=c(paste("x <=",toString(format(round(bins2[2],2))),sep=" "),paste(paste(toString(format(round(bins2[2],2))),"< x <=",sep=" "),toString(format(round(bins2[3],2))),sep=" "),paste(paste(toString(format(round(bins2[3],2))),"< x <=",sep=" "),toString(format(round(bins2[4],2))),sep=" "),paste(paste(toString(format(round(bins2[4],2))),"< x <=",sep=" "),toString(format(round(bins2[5],2))),sep=" "),paste(paste(toString(format(round(bins2[5],2))),"< x <=",sep=" "),toString(format(round(bins2[6],2))),sep=" "),paste(paste(toString(format(round(bins2[6],2))),"< x <=",sep=" "),toString(format(round(bins2[7],2))),sep=" "),paste(paste(toString(format(round(bins2[7],2))),"< x <=",sep=" "),toString(format(round(bins2[8],2))),sep=" "),paste(paste(toString(format(round(bins2[8],2))),"< x <=",sep=" "),toString(format(round(bins2[9],2))),sep=" "),paste(paste(toString(format(round(bins2[9],2))),"< x <=",sep=" "),toString(format(round(bins2[10],2))),sep=" ")))+ expand_limits( x = map$long, y = map$lat ) +
    coord_map( "polyconic" ) + 
    labs(fill=sprintf("%s Avg Speed",title2)) + 
    theme_clean( ) 
  #add state plot layer
  g=g+geom_path( data = state_map,aes(x=long,y=lat,group=groups) , colour = "black")+labs(title=paste("Average Speed for",title2,sep=" "))
  #add LADCO footer
  g=arrangeGrob(g,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.6,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory
   fname=paste(title2,".png",sep="")
  gg_pathtttt=paste(ggsave_countrypath,"\\county_map_avg_speed_bysourcetype_byroadtype_",sep="")
  ggsave(plot = g,file=paste(gg_pathtttt,fname,sep=""), type = "cairo-png")
  
  return(print(g,vp=viewport(width=unit(1400,"points"), height=unit(600,"point"))))
  
  
}