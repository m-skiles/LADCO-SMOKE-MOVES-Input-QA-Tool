


  county_map_population <- function () {
  
  
  #define county map
    newdata=county_map[county_map$countyID%in% countypopulation$FIP,]
    
    #add calculated column for plotting
    newdata$vehicle_pop<-0
    newdata$pop_cat<-0
    
    
    countylist=countyxref[countyxref$indfullname %in% newdata$countyID,]$indfullname
    
    xx=length(countylist)
    
    #add value to calculated column
    for(n in 1:xx)
    {nn=countylist[n]
    newdata[newdata$countyID==nn,]$vehicle_pop<-VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_total[1]
    
    
    }
    #define bins to categorize calculated values
    bins=newdata$vehicle_pop
    bins2=quantile(bins,seq(0,1,by=.1))
    
    #assign rows to bins
    newdata[newdata$vehicle_pop<=bins2[2],]$pop_cat<-1
    
    newdata[newdata$vehicle_pop>bins2[2] & newdata$vehicle_pop<=bins2[3],]$pop_cat<-2
    
    newdata[newdata$vehicle_pop>bins2[3] & newdata$vehicle_pop<=bins2[4],]$pop_cat<-3
    
    newdata[newdata$vehicle_pop>bins2[4] & newdata$vehicle_pop<=bins2[5],]$pop_cat<-4
    
    newdata[newdata$vehicle_pop>bins2[5] & newdata$vehicle_pop<=bins2[6],]$pop_cat<-5
    
    newdata[newdata$vehicle_pop>bins2[6] & newdata$vehicle_pop<=bins2[7],]$pop_cat<-6
    
    newdata[newdata$vehicle_pop>bins2[7] & newdata$vehicle_pop<=bins2[8],]$pop_cat<-7
    
    newdata[newdata$vehicle_pop>bins2[8] & newdata$vehicle_pop<=bins2[9],]$pop_cat<-8
    
    newdata[newdata$vehicle_pop>bins2[9] & newdata$vehicle_pop<=bins2[10],]$pop_cat<-9
    
    newdata[newdata$vehicle_pop>bins2[10] & newdata$vehicle_pop<=bins2[11],]$pop_cat<-10
    
    
    
    
    
    
    #define palette of colors
    greentoblue_pal <- c("#003300","#006633","#339966","#66CC99","#99FFCC","#99FFFF","#3399CC","#3366CC","#0000FF","#000099")
    
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
    final=ggplot( newdata, aes( x = long , y = lat , group=group ) ) +
      geom_polygon( colour = "grey" , aes( fill = factor(pop_cat) ) ) +
      scale_fill_manual( values = greentoblue_pal,labels=c(paste("x <=",toString(format(round(bins2[2],2))),sep=" "),paste(paste(toString(format(round(bins2[2],2))),"< x <=",sep=" "),toString(format(round(bins2[3],2))),sep=" "),paste(paste(toString(format(round(bins2[3],2))),"< x <=",sep=" "),toString(format(round(bins2[4],2))),sep=" "),paste(paste(toString(format(round(bins2[4],2))),"< x <=",sep=" "),toString(format(round(bins2[5],2))),sep=" "),paste(paste(toString(format(round(bins2[5],2))),"< x <=",sep=" "),toString(format(round(bins2[6],2))),sep=" "),paste(paste(toString(format(round(bins2[6],2))),"< x <=",sep=" "),toString(format(round(bins2[7],2))),sep=" "),paste(paste(toString(format(round(bins2[7],2))),"< x <=",sep=" "),toString(format(round(bins2[8],2))),sep=" "),paste(paste(toString(format(round(bins2[8],2))),"< x <=",sep=" "),toString(format(round(bins2[9],2))),sep=" "),paste(paste(toString(format(round(bins2[9],2))),"< x <=",sep=" "),toString(format(round(bins2[10],2))),sep=" "),paste(paste(toString(format(round(bins2[10],2))),"< x <=",sep=" "),toString(format(round(bins2[11],2))),sep=" ")))+ 
      expand_limits( x = newdata$long, y = newdata$lat ) +
      coord_map( "polyconic" ) + 
      labs(fill="Vehicle Population") + 
      theme_clean( ) 
    #add state plot layer
     final=final+geom_path( data = state_map,aes(x=long,y=lat,group=groups) , colour = "red")+labs(title="Vehicle Population")+theme(title=element_text(size=20))
     #add LADCO footer
     final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
    
     #send plot to a directory 
    gg_path=paste(ggsave_countrypath,"\\county_map_population.png",sep="")
    ggsave(plot = final,file=gg_path, type = "cairo-png")   
    
    
    return(final)


  }
  