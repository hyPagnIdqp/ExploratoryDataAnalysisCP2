# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot5.R

# Q: How have emissions from motor vehicle sources changed from 
#    1999–2008 in Baltimore City?
# A: Baltimore City vehicle emission show a steady decline between
#    1999 and 2008


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

L2 <- subset(ClassCode,select=c('SCC','SCC.Level.Two'))
SummaryL2 <- merge(Summary, L2, by='SCC', all=TRUE)

# using Vehicle in Level Two to represent motor vechicles
# Motor Vichicles is a somewhat vague category.  Does it
#  include farm vechicles, does it include vehicles with
#  electric engines and if so, how is generation of electricity
#  included.  I choose to use this, straight forward classification
#  because it fits within the pedogical purpose of the lesson
#  without becoming an huge time sink disproportial with my 
#  objectives in taking the class.
VehicleSources <- SummaryL2[grep("Vehicle", SummaryL2$SCC.Level.Two), ]

BaltimoreVehicleSource <- 
  subset(VehicleSources, fips=='24510', select=c("Emissions","year"))

EmissionsPerYear <- aggregate(Emissions ~ year, BaltimoreVehicleSource, sum)

png(filename='plot5.png',width=480,height=480,units='px')
plot(
  EmissionsPerYear$year,
  EmissionsPerYear$Emissions,
  main='Baltimore Vehicle PM2.5 Emissions per Year',
  xlim=c(1998,2008),
  xlab='Year',
  ylab='PM2.5 Emmisions (tons)',
  cex.sub = 0.85,
  sub= 'an uninterrupted decline in motor vehicle emissions between 1999 and 2008',
  type='b')
dev.off()
