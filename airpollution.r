# == Load in the data ==

airpollution = read.csv("airpollution.csv", stringsAsFactors = FALSE)
latlong = read.csv("latlong.csv", stringsAsFactors = FALSE)

# Source: http://www.who.int/phe/health_topics/outdoorair/databases/cities/en/
# 

# == Load modules ==

install.packages("RColorBrewer")
library(RColorBrewer)
install.packages('rworldmap',dependencies=TRUE) 
library(rworldmap)
install.packages('ggmap',dependencies=TRUE) 
library(ggmap)

# == Geocode the addresses ==

addresses = paste(airpollution$city, airpollution$country)
latlong = geocode(addresses[1:2400])
latlong2 = geocode(addresses[2401:2972])

write.csv(latlong, file="latlong.csv")
write.csv(latlong2, file="latlong2.csv")


# Turn it into a dataframe and set colour threshold
pmtemp <- data.frame(lon = latlong$lon, lat = latlong$lat, pm10 = airpollution$pm10, region = airpollution$region.1, logic = airpollution$pm10 > 20, stringsAsFactors = FALSE)
logic <- airpollution$pm10 > 20 

# == Make the PM10 map ==

png('airpollution.png', width=2500, height=1000, units="px", bg="white")

mapBubbles(dF = pmtemp,
           nameX = "lon",
           nameY = "lat",
           nameZSize = "pm10",
           #nameZColour = "#d95f0240",
           symbolSize = 2,
           lwdSymbols = 2,
           nameZColour = "logic",
           colourPalette = c("#055d8b40",
                             "#d95f0240"),
           fill = TRUE,
           main = "PM10 Concentrations in World Cities",
           catMethod = "categorical",
           landCol = "grey",
           borderCol = "white",
           addLegend = TRUE,
           legendVals = c(600,400,200, 20),
           legendHoriz = TRUE,
           bty = 0
           )

#mapBubbles(nameZColour = adjustcolor('black', alpha.f = 0.7), fill=FALSE, add=TRUE)

dev.off()
