

county_map_population_percapita <- function () {
  
  #cut down dataframe to match inputs
  newdata=county_map[county_map$countyID%in% countypopulation$FIP,]
  
  #add calculated column for plotting
   newdata$vehicle_pop<-0
  newdata$population<-0
  newdata$poppercapita<-0
  newdata$pop_cat_percapita<-0
  
  countylist=countyxref[countyxref$indfullname %in% newdata$countyID,]$indfullname
  
  xx=length(countylist)
  
  #add value to calculated column
  for(n in 1:xx)
  {nn=countylist[n]
  newdata[newdata$countyID==nn,]$vehicle_pop<-VPOP_mastertable_summary[VPOP_mastertable_summary$region_cd==nn,]$county_total[1]
  newdata[newdata$countyID==nn,]$population<-countypopulation[countypopulation$FIP==nn,]$population
  newdata[newdata$countyID==nn,]$poppercapita<-newdata[newdata$countyID==nn,]$vehicle_pop[1]/newdata[newdata$countyID==nn,]$population[1]
  
  }
  
  #define bins to categorize calculated values
  bins=newdata$poppercapita
  bins2=quantile(bins,seq(0,1,by=.1))
  
  
  #add value to calculated column
  newdata[newdata$poppercapita<=bins2[2],]$pop_cat_percapita<-1
  
  newdata[newdata$poppercapita>bins2[2] & newdata$poppercapita<=bins2[3],]$pop_cat_percapita<-2
  
  newdata[newdata$poppercapita>bins2[3] & newdata$poppercapita<=bins2[4],]$pop_cat_percapita<-3
  
  newdata[newdata$poppercapita>bins2[4] & newdata$poppercapita<=bins2[5],]$pop_cat_percapita<-4
  
  newdata[newdata$poppercapita>bins2[5] & newdata$poppercapita<=bins2[6],]$pop_cat_percapita<-5
  
  newdata[newdata$poppercapita>bins2[6] & newdata$poppercapita<=bins2[7],]$pop_cat_percapita<-6
  
  newdata[newdata$poppercapita>bins2[7] & newdata$poppercapita<=bins2[8],]$pop_cat_percapita<-7
  
  newdata[newdata$poppercapita>bins2[8] & newdata$poppercapita<=bins2[9],]$pop_cat_percapita<-8
  
  newdata[newdata$poppercapita>bins2[9] & newdata$poppercapita<=bins2[10],]$pop_cat_percapita<-9
  
  newdata[newdata$poppercapita>bins2[10] & newdata$poppercapita<=bins2[11],]$pop_cat_percapita<-10
  
  
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
    geom_polygon( colour = "grey" , aes( fill = factor( pop_cat_percapita ) ) ) +
    scale_fill_manual( values = greentoblue_pal,labels=c(paste("x <=",toString(format(round(bins2[2],2))),sep=" "),paste(paste(toString(format(round(bins2[2],2))),"< x <=",sep=" "),toString(format(round(bins2[3],2))),sep=" "),paste(paste(toString(format(round(bins2[3],2))),"< x <=",sep=" "),toString(format(round(bins2[4],2))),sep=" "),paste(paste(toString(format(round(bins2[4],2))),"< x <=",sep=" "),toString(format(round(bins2[5],2))),sep=" "),paste(paste(toString(format(round(bins2[5],2))),"< x <=",sep=" "),toString(format(round(bins2[6],2))),sep=" "),paste(paste(toString(format(round(bins2[6],2))),"< x <=",sep=" "),toString(format(round(bins2[7],2))),sep=" "),paste(paste(toString(format(round(bins2[7],2))),"< x <=",sep=" "),toString(format(round(bins2[8],2))),sep=" "),paste(paste(toString(format(round(bins2[8],2))),"< x <=",sep=" "),toString(format(round(bins2[9],2))),sep=" "),paste(paste(toString(format(round(bins2[9],2))),"< x <=",sep=" "),toString(format(round(bins2[10],2))),sep=" "),paste(paste(toString(format(round(bins2[10],2))),"< x <=",sep=" "),toString(format(round(bins2[11],2))),sep=" ")))+ 
    expand_limits( x = newdata$long, y = newdata$lat ) +
    coord_map( "polyconic" ) + 
    labs(fill="Population per Capita") + 
    theme_clean( ) 
   #add state plot layer
  final=final+geom_path( data = state_map,aes(x=long,y=lat,group=groups) , colour = "red")+labs(title="Vehicle Population per Capita")+theme(title=element_text(size=20))
  #add LADCO footer
  final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
  
  #send plot to a directory 
  gg_path=paste(ggsave_countrypath,"\\county_map_population_percapita.png",sep="")
  ggsave(plot = final,file=gg_path, type = "cairo-png")   
return(final)
  }




