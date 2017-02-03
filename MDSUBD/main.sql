DROP TABLE USER;
DROP TABLE AIRPLANE;
DROP TABLE AIRPORT;
DROP TABLE TIMETABLE;
DROP TABLE HISTORY;

BEGIN TRANSACTION;

/* Create a table called NAMES */
CREATE TABLE USER (
    ID int AUTO_INCREMENT,
    Username varchar(20) NOT NULL,
    Email varchar(20) NOT NULL,
    Password varchar(20) NOT NULL,
    Access_level varchar(20) NOT NULL,
    PRIMARY KEY (ID)
);


CREATE TABLE AIRPLANE (
    ID int AUTO_INCREMENT,
    Price int NOT NULL,
    Seats int NOT NULL,
    Free_seats int NOT NULL,
    PRIMARY KEY (ID)
);


CREATE TABLE AIRPORT (
    ID int AUTO_INCREMENT,
    Name varchar(20) NOT NULL,
    Country varchar(20) NOT NULL,
    PRIMARY KEY(ID)
);


CREATE TABLE TIMETABLE (
    ID int AUTO_INCREMENT,
    Airplane_ID int,
    Departure_date datetime,
    Arrival_date datetime,
    Airport_from_ID int,
    Airport_to_ID int,
    PRIMARY KEY(ID),
    FOREIGN KEY(Airplane_ID) REFERENCES AIRPLANE (Airplane_ID),
    FOREIGN KEY(Airport_from_ID) REFERENCES AIRPORT (Airport_ID),
    FOREIGN KEY(Airport_to_ID)  REFERENCES AIRPORT (Airport_ID)
);


CREATE TABLE HISTORY (
    ID int AUTO_INCREMENT,
    User_ID int NOT NULL,
    Timetable_ID int NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (Timetable_ID) REFERENCES TIMETABLE (Timetable_ID),
    FOREIGN KEY (User_ID) REFERENCES USER (User_ID)
);

/* Create few records in this table */

--add to USER table

INSERT INTO USER (Username, Email, Password, Access_level)
VALUES("Admin", "admin@gmail.com", "admin_boss", 1);

INSERT INTO USER (Username, Email, Password, Access_level)
VALUES("Katte", "katte@gmail.com", "katte1996", 0);

INSERT INTO USER (Username, Email, Password, Access_level)
VALUES("Denis", "denis@gmail.com", "DSvidunovich", 0);

INSERT INTO USER (Username, Email, Password, Access_level)
VALUES("Vladd", "brom_vlad@gmail.com", "dovlad", 0);

/* Display all the records from the table */
SELECT * FROM USER;

