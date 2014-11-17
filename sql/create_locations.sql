create table locations(
	id int not null AUTO_INCREMENT,
	name varchar(255),
	region varchar(255),
	lat float,
	lon float,
	primary key (id)
);