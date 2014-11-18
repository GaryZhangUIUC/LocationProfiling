create table locations(
	id int not null AUTO_INCREMENT,
	name varchar(255),
	region varchar(255),
	lat float,
	lon float,
	primary key (id)
);


SET @lat = 40.1125;
SET @lon = -88.2269;
SET @rad = 0.000621371*300;
SELECT name,id,lat,lon,region, ((ACOS(SIN(@lat * PI() / 180) * SIN(lat * PI() / 180) + COS(@lat * PI() / 180) * COS(lat * PI() / 180) * COS((@lon-lon) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS `distance` FROM `locations` HAVING `distance`<=@rad ORDER BY `distance` ASC;