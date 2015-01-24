# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot1.R

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

EmissionsPerYear <- aggregate(Emissions ~ year, Summary, sum)

png(filename='plot1.png',width=480,height=480,units='px')
plot(
  EmissionsPerYear$year,
  EmissionsPerYear$Emissions,
  main='Total US PM2.5 Emissions per Year',
  xlim=c(1998,2008),
  xlab='Year',
  ylab='PM2.5 Emmisions (tons)',
  type='b')
dev.off()

