# 4

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

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

# Looking for what SCCs should we analyse
SCC.cols.needed.1 <- grepl("coal", SCC$EI.Sector, ignore.case=TRUE)
SCC.cols.needed.2 <- grepl("comb", SCC$EI.Sector, ignore.case=TRUE)
SCC.cols.needed <- SCC.cols.needed.1 & SCC.cols.needed.2

# Select the necessary SCCs
SCC.coal.comb <- as.character(SCC[SCC.cols.needed, ]$SCC)

remove(SCC.cols.needed.1, SCC.cols.needed.2, SCC.cols.needed)

# Select the necessary rows from NEI
NEI.coal.comb <- filter(NEI, SCC %in% SCC.coal.comb)

# OK, then the task is similar to task 1
NEI.1 <- select(NEI.coal.comb, Emissions, year)
melted.NEI.1 <- melt(data = NEI.1, id.vars = c("year"))
NEI.1.final <- dcast(melted.NEI.1, year ~ variable, sum)

remove(SCC.coal.comb, NEI.coal.comb, NEI.1, melted.NEI.1)

# OK, data is ready, let's make plot4.png

png(filename = "plot4.png", width = 480, height = 480, units = "px")

with(NEI.1.final, plot(x = year, y = Emissions,
                       main = "Emissions from PM2.5\nfrom coal combustion-related sources",
                       xlab = "Year", ylab = "Emissions",
                       col = "green", type = "l", lwd = 3))

# Emissions from coal combustion-related sources decreased!

dev.off()
