# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot4.R

# Q: Across the United States, how have emissions from coal 
#    combustion-related sources changed from 1999–2008?
# A: Coal emissions have dropped from 1999 to 2008, the the
#    decline has not been uninterrupted

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
ClassCode  <- readRDS(file_scc_rds)

ShortNames <- subset(ClassCode,select=c('SCC','Short.Name'))
SummaryShortNames <- merge(Summary, ShortNames, by='SCC', all=TRUE)

CoalSources <- SummaryShortNames[grep("Coal", SummaryShortNames$Short.Name), ]

EmissionsPerYear <- aggregate(Emissions ~ year, CoalSources, sum)

png(filename='plot4.png',width=480,height=480,units='px')
plot(
  EmissionsPerYear$year,
  EmissionsPerYear$Emissions,
  main='Total US PM2.5 Coal Emissions per Year',
  xlim=c(1998,2008),
  xlab='Year',
  ylab='PM2.5 Emmisions (tons)',
  cex.sub = 0.85,
  sub= 'A decline in Coal Emissions from 1999 to 2008, but not uninterrupted',
  type='b')
dev.off()

