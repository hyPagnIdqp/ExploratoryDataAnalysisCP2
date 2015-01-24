# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot2.R

# Q: Have total emissions from PM2.5 decreased in the 
#    Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# A: Yes, but the decline has not been uninterrupted.

url  <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
zipfile <- 'exdata-data-NEI_data.zip'
file_scc_rds <- 'Source_Classification_Code.rds'
file_sum_rds <- 'summarySCC_PM25.rds'

if (file.exists(file_scc_rds) && file.exists(file_sum_rds)) {
  sprintf( "%s %s already exist",file_scc_rds,file_sum_rds)
} else {
  if (!file.exists(zipfile)) {
    download.file(url,zipfile,method='curl')
  }
  dateDownloaded <- date()
  unzip(zipfile)
}

Summary    <- readRDS(file_sum_rds)

Baltimore <- subset(Summary, fips=='24510', select=c("Emissions","year"))
BaltimoreEmissionsPerYear <- aggregate(Emissions ~ year, Baltimore, sum)

png(filename='plot2.png',width=480,height=480,units='px')
plot(
  BaltimoreEmissionsPerYear$year,
  BaltimoreEmissionsPerYear$Emissions,
  main='Total Baltimore PM2.5 Emissions per Year',
  xlim=c(1998,2008),
  xlab='Year',
  ylab='PM2.5 Emmisions (tons)',
  cex.sub = 0.85,
  sub = 'A decline from 1999, to 2008, but not an ininterrupted decline.',
  type='b')
dev.off()

