create database spring DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
drop table if exists spring.user;
create table spring.user(
	id int(11) auto_increment,
	name varchar(128) unique not null,
	password varchar(256) not null,
	birthday varchar(256),
	salt varchar(128),
	locked int(2),
	createTime timestamp,
	primary key(id)
)DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci engine=InnoDB;

drop table if exists spring.role;
create table spring.role(
	id int(11) auto_increment,
	name varchar(128) unique not null,
	createTime timestamp,
	updateTime timestamp,
	primary key(id)
)DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci engine=InnoDB;

drop table if exists spring.path;
create table spring.path(
	id int(11) auto_increment,
	name varchar(128)  unique not null,
	createTime timestamp,
	updateTime timestamp,
	PRIMARY KEY (id) 
)DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci engine=InnoDB;

drop table if exists spring.rolepath;
create table spring.rolepath(
	id int(11) auto_increment,
	role_id int(11) not null,
	path_id int(11) not null,
	PRIMARY KEY (id) 
)DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci engine=InnoDB;

drop table if exists spring.roleuser;
create table spring.roleuser(
	id int(11) auto_increment,
	user_id int(11) ,
	role_id int(11),
	PRIMARY KEY (id) 
)DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci engine=InnoDB;