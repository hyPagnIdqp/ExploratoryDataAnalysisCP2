# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot1.R

# Q: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# A: Yes, the graph shows a decline in the total PM2.5 emmissions

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

strn <- "Year\n\n\n\nThis is a silly and overly long\n
         title that I want to use on my plot"

png(filename='plot1.png',width=480,height=480,units='px')
plot(
  EmissionsPerYear$year,
  EmissionsPerYear$Emissions,
  main='Total US PM2.5 Emissions per Year',
  xlim=c(1998,2008),
  xlab='Year',
  ylab='PM2.5 Emmisions (tons)',
  cex.sub = 0.85,
  sub= 'A decline in Emissions is seen year over year.',
  type='b')
dev.off()

