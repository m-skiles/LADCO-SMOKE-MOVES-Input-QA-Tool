
  county_map_engine_hotelling <- function () {
  
    #cut down dataframe to match inputs
    newdata=county_map[county_map$countyID %in% Hotelling_mastertable_summary$region_cd & county_map$countyID %in% countyxref$indfullname,]
    
    #add calculated column for plotting
    newdata$engine_hotelling<-0
    
    newdata$engine_cat_percapita<-0
    
    countylist=countyxref[countyxref$indfullname %in% newdata$countyID,]$indfullname
    
    xx=length(countylist)
    
    #add value to calculated column
    for(n in 1:xx)
    {nn=countylist[n]
    newdata[newdata$countyID==nn,]$engine_hotelling<-Hotelling_mastertable_summary[Hotelling_mastertable_summary$region_cd==nn,]$county_total_engine[1]
    }
    
    #define bins to categorize calculated values
    bins=newdata[! newdata$engine_hotelling==0,]$engine_hotelling
    
    bins2=quantile(bins,seq(0,1,by=.2),na.rm=TRUE)
    
    
    #assign rows to bins
    newdata[newdata$engine_hotelling<bins2[2]+1,]$engine_cat_percapita<-1
    
    newdata[newdata$engine_hotelling>bins2[2] & newdata$engine_hotelling<bins2[3]+1,]$engine_cat_percapita<-2
    
    newdata[newdata$engine_hotelling>bins2[3] & newdata$engine_hotelling<bins2[4]+1,]$engine_cat_percapita<-3
    newdata[newdata$engine_hotelling>bins2[4] & newdata$engine_hotelling<bins2[5]+1,]$engine_cat_percapita<-4
    newdata[newdata$engine_hotelling<bins2[6]+1 & newdata$engine_hotelling>bins2[5],]$engine_cat_percapita<-5
    
    
    #define palette of colors
    pal <- c("#FFFFFF","#FFCC99","#FF9933","#FF3300","#CC3300")
    
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
      geom_polygon( colour = "grey" , aes( fill = factor( engine_cat_percapita ) ) ) +
      scale_fill_manual( values = pal,labels=c(paste("x <=",toString(format(round(bins2[2],2))),sep=" "),paste(paste(toString(format(round(bins2[2],2))),"< x <=",sep=" "),toString(format(round(bins2[3],2))),sep=" "),paste(paste(toString(format(round(bins2[3],2))),"< x <=",sep=" "),toString(format(round(bins2[4],2))),sep=" "),paste(paste(toString(format(round(bins2[4],2))),"< x <=",sep=" "),toString(format(round(bins2[5],2))),sep=" "),paste(paste(toString(format(round(bins2[5],2))),"< x <=",sep=" "),toString(format(round(bins2[6],2))),sep=" "))) +
      expand_limits( x = newdata$long, y = newdata$lat ) +
      coord_map( "polyconic" ) + 
      labs(fill="Engine Hotelling Hours") + 
      theme_clean( ) 
    #add state plot layer
    final=final+geom_path( data = state_map,aes(x=long,y=lat,group=groups) , colour = "red")+labs(title=("Engine Hotelling Hours (SMOKE)"))+theme(title=element_text(size=20))
    #add LADCO footer
    final=arrangeGrob(final,sub=textGrob("LADCO Moves Evaluation Software 2015",x=0,hjust=-0.1,vjust=0.4,gp=gpar(fontface="italic",fontsize=18)))
    
    #send plot to a directory
    gg_path=paste(ggsave_countrypath,"\\county_map_engine_hotelling.png",sep="")
    ggsave(plot = final,file=gg_path, type = "cairo-png")   
    
    return(final)

  }
  
