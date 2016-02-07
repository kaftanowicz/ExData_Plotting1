# Reading the data
library(downloader)
library(dplyr)
library(data.table)
library(lubridate)

file_url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
download(file_url, dest="household_power_consumption.zip", mode="wb") 
unzip ("household_power_consumption.zip", exdir = ".")

# Description:
# Measurements of electric power consumption in one household 
# with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.

hpc <- fread('household_power_consumption.txt')
names(hpc) <- tolower(names(hpc))

# You may find it useful to convert the Date and Time variables to Date/Time classes in R
# using the strptime()  and as.Date() functions.

hpc$date_time <-as.POSIXct(strptime(paste(hpc$date, hpc$time), "%d/%m/%Y %H:%M:%S"))
hpc$date <-as.POSIXct(strptime(hpc$date, '%d/%m/%Y'))

#  We will only be using data from the dates 2007-02-01 and 2007-02-02.

startdate = '2007-02-01'
enddate = '2007-02-02'

hpc <- filter(hpc, date >= startdate & date <= enddate)

# Back to data frame
hpc <- as.data.frame(hpc)
# Back to numeric values
hpc[ ,3:9] <- apply(hpc[ ,3:9], c(1,2), as.numeric)

# Plotting

png('plot4.png', width = 480, height = 480, units = "px")

par(mfrow=c(2,2))

Sys.setlocale("LC_TIME", "English")

# Nr 4.1

plot(hpc$global_active_power ~ hpc$date_time, border = NULL,
     main = '',
     xlab = '',
     ylab = 'Global Active Power', type="n")

lines(hpc$global_active_power ~ hpc$date_time,  col = 'black')

# Nr 4.2

plot(hpc$voltage ~ hpc$date_time, border = NULL,
     main = '',
     xlab = 'datetime',
     ylab = 'Voltage', type="n")

lines(hpc$voltage ~ hpc$date_time,  col = 'black')

# Nr 4.3

plot(hpc$sub_metering_1 ~ hpc$date_time, border = NULL,
     main = '',
     xlab = '',
     ylab = 'Energy sub metering', type="n")

lines(hpc$sub_metering_1 ~ hpc$date_time,  col = 'black')
lines(hpc$sub_metering_2 ~ hpc$date_time,  col = 'red')
lines(hpc$sub_metering_3 ~ hpc$date_time,  col = 'blue')

legend('topright',
       c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       lty=c(1,1,1),
       lwd=c(2.5,2.5), col=c('black', 'blue', 'red'),
       cex = 0.75)

# Nr 4.4

plot(hpc$global_reactive_power ~ hpc$date_time, border = NULL,
     main = '',
     xlab = 'datetime',
     ylab = 'Global_reactive_power', type="n")

lines(hpc$global_reactive_power ~ hpc$date_time,  col = 'black')

dev.off()
