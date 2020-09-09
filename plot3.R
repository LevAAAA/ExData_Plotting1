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

png("plot3.png", width = 480, height = 480)

# Create plot for column Sub_metering_1 

with(hpc, plot(Sub_metering_1~DayOfWeek, type = "l", 
               ylab = "Energy sub metering", xlab=""))

# Add to plot lines for column Sub_metering_2

with(hpc, lines(Sub_metering_2~DayOfWeek, type = "l", col = "red"))

# Add to plot lines for column Sub_metering_3

with(hpc, lines(Sub_metering_3~DayOfWeek, type = "l", col = "blue"))

# Add to plot legends

legend("topright", col=c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Close device

dev.off()