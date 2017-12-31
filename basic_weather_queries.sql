/* very basic SELECT starting queries */

--return place based on name, basic SELECT statement
SELECT name,region,id FROM places WHERE name = 'Sheffield';

--return multiple places based on names, using OR
SELECT name,region,id FROM places 
WHERE name = 'Leeds' 
OR name ='Sheffield'
OR name = 'Wakefield';

--SELECT ALL Yorkshire locations
SELECT * FROM places WHERE region = 'yh';

--SELECT distinct regions only
SELECT DISTINCT region FROM places;

--basic join select between report and places based on id
SELECT report.screen_temp, 
	report.feels_temp,
	report.rain_chance,
	places.name,
	places.id 
	FROM report,places 
	WHERE report.id = places.id;

