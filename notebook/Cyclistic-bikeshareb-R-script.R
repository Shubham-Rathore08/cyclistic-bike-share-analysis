library(tidyverse)
library(conflicted) #Use the conflicted package to manage conflicts.

#Set dplyr:filter & lag as default choices
conflict_prefer("filter","dplyr")
conflict_prefer("lag","dplyr")

#upload datasets
q1_2019<-read_csv("2019_Q1.csv")
q1_2020<-read_csv("2020_q1.csv")

#check colnames
colnames(q1_2019)
colnames(q1_2020)

#rename column names in 2019 dataset to match 2020 dataset
q1_2019<- rename(q1_2019,
                 ride_id = trip_id,
                 rideable_type = bikeid,
                 started_at = start_time,
                 ended_at = end_time,
                 start_station_name = from_station_name,
                 start_station_id = from_station_id,
                 end_station_name = to_station_name,
                 end_station_id = to_station_id,
                 member_casual = usertype)

#inspect the dataframes (datatypes...etc)
str(q1_2019)
str(q1_2020)
##FINDINGS:- 1.different datatype for ride_id & rideable_type
            #2. different data filled in member_casual column
            #3. different type of data filled in rideable_type
            

#change datatype of ride_id & ridetype to character
q1_2019<- mutate(q1_2019,
                 ride_id = as.character(ride_id),
                 rideable_type = as.character(rideable_type))

#combine data in one dataframe
all_trips<- bind_rows(q1_2019,q1_2020)

#Remove unwanted columns from combined data
all_trips<- all_trips %>% 
  select(-c(start_lat,start_lng,end_lat,end_lng,gender,birthyear,"tripduration"))


####### CLEANING PART

#(12)Recheck colnames
colnames(all_trips)

#(28)recheck structure & check dimension and summary
nrow(all_trips)
dim(all_trips)
head(all_trips)
str(all_trips)
summary(all_trips)

#checking member_casual list
table(all_trips$member_casual)

#converting to only two type : member & casual
all_trips <-  all_trips %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))


#(58)Recheck member_casual list
table(all_trips$member_casual)

#Add column named as date, month, year, day of week

all_trips$date <- as.Date(all_trips$started_at)
all_trips$month<- format(as.Date(all_trips$date),"%m")
all_trips$day<- format(as.Date(all_trips$date),"%d")
all_trips$year<- format(as.Date(all_trips$date),"%Y")
all_trips$day_of_week<- format(as.Date(all_trips$date),"%A")

#(48) check column names & structure
colnames(all_trips)
str(all_trips)
 
# Adding starting hour for ride
all_trips$dt <- as_datetime(all_trips$started_at)

all_trips$start_hour <- format(as_datetime(all_trips$dt),"%H")

#(79) Recheck column names & structure
colnames(all_trips)
str(all_trips)

# removing unwanted columns(i.e. dt....etc) 
all_trips <- all_trips %>% 
  select(-c(hour,hour00,h2r,dt))

#(88) recheck structure
str(all_trips)

# view data in table format(starting & ending six rows)
View(head(all_trips))
View(tail(all_trips))

#  ADD Ride length column (in seconds)

all_trips$ride_length<- difftime(all_trips$ended_at,all_trips$started_at)

#(96) Recheck structure
str(all_trips)

#checking whether all values in ride length is numeric

is.factor(all_trips$ride_length)    #------------------answer is FALSE
#making(numeric)
all_trips$ride_length<- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)   #------------------answer is TRUE

# REMOVING bad data & CREATING new version of data

all_trips_v2 <- all_trips[!(all_trips$start_station_name=="HQ QR"| all_trips$ride_length<0),]


##### ANALYSIS PART

#summarize data

mean(all_trips_v2$ride_length)        #---average
median(all_trips_v2$ride_length)      #---midpoint in asc order
max(all_trips_v2$ride_length)
min(all_trips_v2$ride_length)

# Aggregate data to find trend

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual,FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual,FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual,FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual,FUN = min)

#aggregate by weekdays
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,FUN = mean)

# set order in day_of_week column
all_trips_v2$day_of_week<-ordered(all_trips_v2$day_of_week, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

#(141) repeat 
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,FUN = mean)


# Analyse ridership data by type and weekday
 
all_trips_v2 %>%
  mutate(weekday = wday(started_at,label = TRUE)) %>%    
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday)


####### VISUALIZATION PART

#weekday_vs_no_of_rides

all_trips_v2 %>%
  mutate(weekday = wday(started_at,label = TRUE)) %>%    
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday) %>%
  ggplot(aes(x=weekday,y=number_of_rides,fill = member_casual))+geom_col(position = "dodge")


#weekday vs average duration

all_trips_v2 %>%
  mutate(weekday = wday(started_at,label = TRUE)) %>%    
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>%
  arrange(member_casual,weekday) %>%
  ggplot(aes(x=weekday,y=average_duration,fill = member_casual))+geom_col(position = "dodge")










