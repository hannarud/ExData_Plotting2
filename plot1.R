# 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

require(reshape2)
require(dplyr)

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

NEI.1 <- select(NEI, Emissions, year)
melted.NEI.1 <- melt(data = NEI.1, id.vars = c("year"))
NEI.1.final <- dcast(melted.NEI.1, year ~ variable, sum)

remove(NEI.1, melted.NEI.1)

# OK, data is ready, let's make plot1.png

png(filename = "plot1.png", width = 480, height = 480, units = "px")

with(NEI.1.final, plot(x = year, y = Emissions,
                       main = "Total emissions from PM2.5",
                       xlab = "Year", ylab = "Emissions",
                       col = "green", type = "l", lwd = 3))

# Total emissions decreased!

dev.off()
