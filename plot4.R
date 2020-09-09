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

png("plot4.png", width = 480, height = 480)

# Create 2 rows and 2 columns for plots with margins

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

# Create plot 1

with(hpc, plot(Global_active_power~DayOfWeek, type = "l", 
               ylab = "Global Active Power", xlab=""))

# Create plot 2

with(hpc, plot(Voltage~DayOfWeek, type = "l", 
               ylab = "Voltage", xlab="datetime"))

# Create plot 3 with legends

with(hpc, plot(Sub_metering_1~DayOfWeek, type = "l", 
               ylab = "Energy sub metering", xlab=""))

with(hpc, lines(Sub_metering_2~DayOfWeek, type = "l", col = "red"))

with(hpc, lines(Sub_metering_3~DayOfWeek, type = "l", col = "blue"))

legend("topright", col=c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Create plot 4

with(hpc, plot(Global_reactive_power~DayOfWeek, type = "l", 
               ylab = "Global_reactive_power", xlab="datetime"))

# Close device

dev.off()