filename<-"power.zip"

# Download file

if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method = "curl")
}

# Unzip file

if (!file.exists("household_power_consumption.txt")) { 
  unzip(filename) 
}

# get list of column names

colnames<-read.csv(".\\household_power_consumption.txt", sep=";", header = TRUE, 
                   nrows=1)

# get data for limited number of rows

hpc<-read.table(".\\household_power_consumption.txt", sep=";", header = FALSE, 
                skip=66637, nrows=2880, col.names = names(colnames), na.strings = "?")

library(lubridate)

# add DateTime based on Date and Time columns

hpc<- transform(hpc, DateTime=dmy(Date)+hms(Time))

# add DayOfWeek based on DateTime column

hpc<- transform(hpc, DayOfWeek=(DateTime))

# Create png device

png("plot2.png", width = 480, height = 480)

# Create plot

with(hpc, plot(Global_active_power~DayOfWeek, type = "l", 
               ylab = "Global Active Power (kilowatts)", xlab=""))

# Close device

dev.off()