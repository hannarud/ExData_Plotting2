
# Prepare the data set

data.archive <- "exdata_data_NEI_data.zip"
if (!file.exists(data.archive)){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  destfile=data.archive, method="curl")
}

data.emiss.rds <- "summarySCC_PM25.rds"
data.sourcecode.rds <- "Source_Classification_Code.rds"
if (!file.exists(data.emiss.rds) | !file.exists(data.sourcecode.rds)) {
    unzip(data.archive, files = NULL, list = FALSE,
          overwrite = FALSE)
}

# OK, data files are ready in the working directory

# Read the data set

## This first line will likely take a few seconds. Be patient!
if (!exists(x = "NEI") | !exists(x = "SCC")) {
    NEI <- readRDS(data.emiss.rds)
    SCC <- readRDS(data.sourcecode.rds)
}

remove(data.archive, data.emiss.rds, data.sourcecode.rds)

# Data is ready for the analysis
