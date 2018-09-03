midwest_county_map_vmt_plot <- function () {
  
  #define palette of colors
  pal <- c("#F7FCF5","#74C476","#41AB5D","#238B45","#006D2C","#00441B")
  
  #cut down dataframe to match inputs
  newdata=county_map[county_map$region%in% c("wisconsin","illinois","minnesota","iowa","michigan","indiana","ohio"),]
newstate=state_map[state_map$region%in% c("wisconsin","illinois","minnesota","iowa","michigan","indiana","ohio"),]
  
#add calculated column for plotting
newdata$county_vmt<-0
  countylist=countyxref$indfullname
  countylist=countylist[countylist %in% newdata$countyID]
  #add value to calculated column
  for(n in 1:length(countylist))
  {nn=countylist[n]
  newdata[newdata$countyID==nn,]$county_vmt<-VMT_mastertable_summary[VMT_mastertable_summary$region_cd==nn,]$county_total[1]
  
  }
 
  #define bins to categorize calculated values and #assign rows to bins 
  newdata$vmt_cat<-0
  
  newdata[newdata$county_vmt<750000001,]$vmt_cat<-1
  
  newdata[newdata$county_vmt>750000000 & newdata$county_vmt<1000000001,]$vmt_cat<-2
  
  newdata[newdata$county_vmt>1000000000 & newdata$county_vmt<3000000001,]$vmt_cat<-3
  newdata[newdata$county_vmt>3000000000 & newdata$county_vmt<5000000001,]$vmt_cat<-4
  newdata[newdata$county_vmt>5000000000 & newdata$county_vmt<80000000001,]$vmt_cat<-5
  newdata[newdata$county_vmt>8000000000,]$vmt_cat<-6
  
  
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
  
  #make county plot
  final=ggplot( newdata, aes( x = long , y = lat , group=countyID ) ) +
    geom_polygon( colour = "grey" , aes( fill = factor( vmt_cat ) ) ) +
    scale_fill_manual( values = pal, labels=c("< 750 thousand","750 thousand< x < 1 billion","1 billion < x < 3 billion","3 billion < x < 5 billion","5 billion < x < 8 billion","> 8 billion")) +
    expand_limits( x = newdata$long, y = newdata$lat ) +
    coord_map( "polyconic" ) + 
    labs(fill="County VMT Size") + 
    theme_clean( )+labs(title="Vehicile Miles Travled per County")+theme(title=element_text(size=20))
  #add state plot layer
  final=final+geom_path(data=newstate,aes(x=long,y=lat,group=groups),colour="red")
  #add LADCO footer
  final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.6,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory
  gg_pathtt=paste(ggsave_countrypath,"\\midwest_county_map_vmt_plot.png",sep="")
  ggsave(plot = final,file=gg_pathtt, type = "cairo-png")    
  
  return(print(final,vp=viewport(width=unit(1400,"points"), height=unit(600,"point"))))
  }
