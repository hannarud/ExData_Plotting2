# 6

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California
# (fips == "06037"). Which city has seen greater changes over time in motor
# vehicle emissions?

require(reshape2)
require(dplyr)
require(ggplot2)

# Read the data first
source("data_prep.R")

# The example content of NEI variable:
#    fips  SCC      Pollutant Emissions  type year
# 4  09001 10100401  PM25-PRI    15.714 POINT 1999
# 8  09001 10100404  PM25-PRI   234.178 POINT 1999
# 12 09001 10100501  PM25-PRI     0.128 POINT 1999
# 16 09001 10200401  PM25-PRI     2.036 POINT 1999
# 20 09001 10200504  PM25-PRI     0.388 POINT 1999
# 24 09001 10200602  PM25-PRI     1.490 POINT 1999

# The example content of SCC variable (only rows needed for analysis):
#   SCC      Data.Category Short.Name
# 1 10100101         Point                   Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal
# 2 10100102         Point Ext Comb /Electric Gen /Anthracite Coal /Traveling Grate (Overfeed) Stoker
# 3 10100201         Point       Ext Comb /Electric Gen /Bituminous Coal /Pulverized Coal: Wet Bottom
# 4 10100202         Point       Ext Comb /Electric Gen /Bituminous Coal /Pulverized Coal: Dry Bottom
# 5 10100203         Point                   Ext Comb /Electric Gen /Bituminous Coal /Cyclone Furnace
# 6 10100204         Point                   Ext Comb /Electric Gen /Bituminous Coal /Spreader Stoker

# OK, I decided to go on with 'ON-ROAD' in NEI$type

# Select the necessary rows from NEI
NEI.motorveh.BL <- filter(NEI, type == "ON-ROAD",
                          fips == "24510" | fips == "06037")

# OK, then the task is similar to task 3
NEI.1 <- select(NEI.motorveh.BL, fips, Emissions, year)
melted.NEI.1 <- melt(data = NEI.1, id.vars = c("year", "fips"))
NEI.1.final <- dcast(melted.NEI.1, year + fips ~ variable, sum)

# Making better names for factores
NEI.1.final$fips[NEI.1.final$fips=="24510"] <- "Baltimore"
NEI.1.final$fips[NEI.1.final$fips=="06037"] <- "Los Angeles"

remove(NEI.motorveh.BL, NEI.1, melted.NEI.1)

# OK, data is ready, let's make plot6.png
# Do it with ggplot2

png(filename = "plot6.png", width = 480, height = 480, units = "px")

# Setup ggplot with data frame
g <- ggplot(NEI.1.final, aes(x = year, y = Emissions))

# Add layers
g + geom_line(aes(color = fips), size = 2) + facet_grid(fips ~ ., scales="free", space = "free") +
    labs(title = "Emissions from motor vehicle sources", x = "Year", y = "Emissions")

# Emisiions decreased for all types except the POINT but not monotonically

dev.off()
