# 5

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?

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

# OK, I decided to go on with 'ON-ROAD' in NEI$type

# Select the necessary rows from NEI
NEI.motorveh.Baltimore <- filter(NEI, type == "ON-ROAD", fips == "24510")

# OK, then the task is similar to task 2
NEI.1 <- select(NEI.motorveh.Baltimore, Emissions, year)
melted.NEI.1 <- melt(data = NEI.1, id.vars = c("year"))
NEI.1.final <- dcast(melted.NEI.1, year ~ variable, sum)

remove(NEI.motorveh.Baltimore, NEI.1, melted.NEI.1)

# OK, data is ready, let's make plot5.png

png(filename = "plot5.png", width = 480, height = 480, units = "px")

with(NEI.1.final, plot(x = year, y = Emissions,
                       main = "Emissions from motor vehicle sources\nin Baltimore City",
                       xlab = "Year", ylab = "Emissions",
                       col = "green", type = "l", lwd = 3))

# Emissions from motor vehicle sources in Baltimore decreased!

dev.off()
