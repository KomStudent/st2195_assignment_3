# Author: Karl Munroe
# Date: January 1, 2023
# Title: R Code for ST2195 Assignment 3

#Load DBI Library
library(DBI)

#Check if database exists. Use absolute path to prevent sync with GitHub Repo
if (file.exists("c:/DATA/R/airlineInfo.db"))
  file.remove("c:/DATA/R/airlineInfo.db")

#Create the connection to the Database
conn <- dbConnect(RSQLite::SQLite(),"c:/DATA/R/airlineInfo.db")

# CSV Files are large only load and write to Database one at a time

# Year 2000
yr2000 <- read.csv("c:/DATA/2000.csv", header=TRUE)
dbWriteTable(conn, "ontime", yr2000)

#Year 2001 - Table has been created in step 1. above, append the data to the table here
yr2001 <- read.csv("c:/DATA/2001.csv", header=TRUE)
dbAppendTable(conn, "ontime", yr2001)

#Year 2002 - Table has been created in step 1. above, append the data to the table here
yr2002 <- read.csv("c:/DATA/2002.csv", header=TRUE)
dbAppendTable(conn, "ontime", yr2002)

#Year 2003 - Table has been created in step 1. above, append the data to the table here
yr2003 <- read.csv("c:/DATA/2003.csv", header=TRUE)
dbAppendTable(conn, "ontime", yr2003)

#Year 2004 - Table has been created in step 1. above, append the data to the table here
yr2004 <- read.csv("c:/DATA/2004.csv", header=TRUE)
dbAppendTable(conn, "ontime", yr2004)

#Year 2005 - Table has been created in step 1. above, append the data to the table here
yr2005 <- read.csv("c:/DATA/2005.csv", header=TRUE)
dbAppendTable(conn, "ontime", yr2005)

# Add in other data tables: planes, airports & carriers
airports <- read.csv("c:/DATA/airports.csv", header=TRUE)
carriers <- read.csv("c:/DATA/carriers.csv", header=TRUE)
plane_data <- read.csv("c:/DATA/plane-data.csv", header=TRUE)

dbWriteTable(conn, "airports", airports)
dbWriteTable(conn, "carriers", carriers)
dbWriteTable(conn, "planes", plane_data)

# QUIZ - Question 1
# Which of the following companies has th"e highest number of cancelled flights?
CancelledFlights <- dbGetQuery(conn,"SELECT carriers.Description, COUNT(ontime.Cancelled) as Total_Cancelled FROM ontime INNER JOIN carriers ON carriers.Code = ontime.UniqueCarrier WHERE Cancelled = 1 GROUP BY carriers.Description ORDER BY Total_Cancelled DESC")
CancelledFlights
head(CancelledFlights,n=1 )
write.csv(CancelledFlights,"cancelled-flights-DBI.csv")

# QUIZ - Question 2
# Which of the following airplanes has the lowest associated average departure delay (excluding cancelled and diverted flights)?
depDelay <- dbGetQuery(conn,"SELECT  planes.model AS model, AVG(ontime.DepDelay) AS avg_delay FROM ontime INNER JOIN planes ON (ontime.TailNum = planes.tailnum)WHERE ontime.Cancelled = 0 AND ontime.Diverted = 0 AND ontime.DepDelay > 0 GROUP BY model ORDER BY avg_delay ASC")
depDelay
lwrModel <- head(depDelay,n=1)["model"]
lwrModel
write.csv(depDelay, "airplaneDepDelayAvg-DBI.csv")


#Finally Close the Connection
dbDisconnect(conn)

