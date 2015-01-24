# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot6.R

# Q: Compare emissions from motor vehicle sources in Baltimore City 
#      with emissions from motor vehicle sources in Los Angeles County, 
#      California (fips == 06037). 
#    Which city has seen greater changes over time in motor vehicle emissions?
# A: Baltimore 66% decreate
#    Los Angeles County 5% increase
#    Abs(% change):   low: LA Country =  5 ; high: Baltimore =  66"

require("ggplot2")

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

VehicleSources <- SummaryL2[grep("Vehicle", SummaryL2$SCC.Level.Two), ]

# Baltimore subset
BaltimoreVehicleSource <- 
  subset(VehicleSources, fips=='24510', select=c("Emissions","year"))
BaltimoreVehicleSource$Location <- 'Baltimore'

# Los Angeles County subset
LosAngelesCountyVehicleSource <- 
  subset(VehicleSources, fips=='06037', select=c("Emissions","year"))
LosAngelesCountyVehicleSource$Location <- 'Los Angeles County'

# combine data
data <- rbind(BaltimoreVehicleSource,LosAngelesCountyVehicleSource)

# set up agregate data: year, Location, Emissions 
EmissionsPerYear <- aggregate(
  Emissions ~ year * Location, 
  data=data, 
  sum)

# determine which location had the largest percent change
locationYear <- function(l,y) {
  EmissionsPerYear[
    EmissionsPerYear$Location == l & EmissionsPerYear$year==y, 'Emissions']
}
Baltimore1999<-locationYear('Baltimore',1999)
Baltimore2008<-locationYear('Baltimore',2008)
ChangeBaltimore <- (Baltimore2008-Baltimore1999)/Baltimore1999
ChangeBaltimore 

LA1999<-locationYear('Los Angeles County',1999)
LA2008<-locationYear('Los Angeles County',2008)
ChangeLA<- (LA2008-LA1999)/LA1999
ChangeLA

# create plot
png(filename='plot6.png',width=480,height=480,units='px')
qplot(
  year ,
  Emissions,
  data=EmissionsPerYear,
  geom='line',
  color=Location
  ) +
ggtitle('Baltimore City vs. Los Angeles County Vechicle Emissions') +
ylab('PM2.5 Emmisions (tons)') +
xlab(
  expression(
    atop("Year",
    atop(italic('Largest absolute percent change: Baltimore')),"")
  )
)
dev.off()

