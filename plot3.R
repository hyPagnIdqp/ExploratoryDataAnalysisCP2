# Exploratory Data Analysis -- Class Project 2
#  Mark Anderson
#  plot1.R

# Q: Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999–2008 
# for Baltimore City? 
# A: decrease in nonpoint, onroad, nonroad emissions

# Q:Which have seen increases in emissions from 1999–2008?
# A: increase in point emmissions

library('ggplot2')

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

Baltimore <- subset(Summary, fips=='24510')
BaltimoreYearType <- aggregate(
  Emissions ~ year * type, 
  data=Baltimore, 
  FUN=sum)

png(filename='plot3.png',width=480,height=480,units='px')
qplot(
  year,
  Emissions,
  data=BaltimoreYearType,
  geom='line',
  color=type
  ) +
ggtitle('Total Baltimore PM2.5 Emissions per Year') +
ylab('PM2.5 Emmisions (tons)') +
xlab(
  expression(
    atop("Year", 
    atop(italic("increase:point, decrease:nonpoint, on-road, non-road"), "")
    )
  )
)
dev.off()
