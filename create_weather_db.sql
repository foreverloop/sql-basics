/* Postgres SQL to create places and weather reports table, 
as well as populate it from tab delimited file */

CREATE TABLE places (elevation decimal, 
		name varchar(80),
		region varchar(5),  
		longitude decimal,  
		latitude decimal,
		authority varchar(50), 
		place_id int PRIMARY KEY);

--load 'location' data from tab delimited file
COPY places FROM 'location-list-fixed.txt';

CREATE TABLE report (rain_chance int, 
		wind_direction varchar(4),
		wind_gust int,
		feels_temp int,  
		screen_humidity int,
		wind_speed int,  
		ultraviolet int, 
		screen_temp int, 
		weather_code int,
		visibility varchar(4), 
		time int, 
		place_id int FOREIGN KEY
		report_id serial PRIMARY KEY);

--load data from tab delimited file
COPY report FROM 'five_days_f.txt';