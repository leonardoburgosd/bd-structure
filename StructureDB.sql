CREATE DATABASE BCreateBD
GO
USE BCreateBD
GO
CREATE SCHEMA Person
GO
CREATE SCHEMA Publication
GO
CREATE SCHEMA Record
GO
CREATE TABLE Person.bc_Person(
PersonID INT IDENTITY PRIMARY KEY,
PersonName NVARCHAR(50) NOT NULL,
PersonLastName NVARCHAR(80),
PersonImage NVARCHAR(90) NOT NULL DEFAULT 'noimage.png',
PersonBirthday DATE,
PersonState CHAR(2) NOT NULL CHECK (
									PersonState='AC' AND /*ACTIVE*/
									PersonState='IN'AND /*INACTIVE*/
									PersonState='RM' /*REMOVED*/
								)					
)
GO
CREATE TABLE Person.bc_LevelAuth(
LevelAuthID INT IDENTITY PRIMARY KEY,
LevelAuthName NVARCHAR(20) NOT NULL  ,
LevelAuthState CHAR(2) NOT NULL CHECK (
									LevelAuthState='AC' AND /*ACTIVE*/
									LevelAuthState='IN'AND /*INACTIVE*/
									LevelAuthState='RM' /*REMOVED*/
								)
)
GO
CREATE TABLE Person.bc_User(
UserID INT IDENTITY PRIMARY KEY,
UserName NVARCHAR(15) NOT NULL UNIQUE,
UserPassword NVARCHAR(30) NOT NULL,
UserPareo NVARCHAR(200) , /*Add LATCH - https://latch.elevenpaths.com */
UserEmail NVARCHAR(60) NOT NULL,
UserState CHAR(2) NOT NULL CHECK (
									UserState='AC' AND /*ACTIVE*/
									UserState='IN'AND /*INACTIVE*/
									UserState='RM' AND /*REMOVED*/
									UserState = 'MN' /*Mail not confirmed*/
								),
LevelID INT,
PersonID INT
CONSTRAINT LevelIDFKU FOREIGN KEY (LevelID)
	REFERENCES Person.bc_LevelAuth(LevelAuthID),
CONSTRAINT PersonIDFKU FOREIGN KEY(PersonID)
	REFERENCES Person.bc_Person(PersonID)
)
GO
CREATE TABLE Publication.bc_Post(
PostID INT IDENTITY PRIMARY KEY,
PostURL NVARCHAR(60) NOT NULL,
PostTitle NVARCHAR(200),
PostDetail NVARCHAR(MAX),
PostDate DATETIME DEFAULT SYSDATETIME(),
PostDateModified DATETIME,
PostState CHAR(2) NOT NULL CHECK (
									PostState='PB' AND /*PUBLISHED*/
									PostState='DR'AND /*DRAFT*/
									PostState='RM' AND /*REMOVED*/
									PostState ='HD' /*HIDDEN*/
								),
UserID INT
CONSTRAINT UserIDFKP FOREIGN KEY(UserID)
	REFERENCES Person.bc_User(UserID)
)
GO
CREATE TABLE Publication.bc_Commentary(
	CommentaryID INT IDENTITY PRIMARY KEY,
	CommentaryName NVARCHAR(20) DEFAULT 'Anonymous user',
	CommentaryDetail NVARCHAR(500) NOT NULL,
	CommentaryDate DATETIME DEFAULT SYSDATETIME(),
	CommentaryState CHAR(2) NOT NULL CHECK (
									CommentaryState='AC' AND /*ACTIVE*/
									CommentaryState='IN'AND /*INACTIVE*/
									CommentaryState='RM' AND /*REMOVED*/
									CommentaryState='SM' /*SPAMM*/
								),
	PostID INT
CONSTRAINT PostIDFKC FOREIGN KEY (PostID)
	REFERENCES Publication.bc_Post(PostID)
)
GO
CREATE TABLE Publication.cb_Category(
	CategoryID INT IDENTITY PRIMARY KEY,
	CategoryName VARCHAR(1) NOT NULL UNIQUE,
	CategoryState CHAR(2) NOT NULL CHECK (
									CategoryState='AC' AND /*ACTIVE*/
									CategoryState='IN'AND /*INACTIVE*/
									CategoryState='RM'/*REMOVED*/
								),
	PostID INT
CONSTRAINT PostIDFKCG FOREIGN KEY(PostID)
	REFERENCES Publication.bc_Post(PostID)
)
GO
/*It serves to relate post to post (example: post A (part 1) with post B (part 2)).*/
CREATE TABLE Publication.bc_Link(
	LinkID INT IDENTITY PRIMARY KEY,
	PostIDFROM INT,
	PostIDTO INT,
	PostState CHAR(2) NOT NULL CHECK (
									PostState='AC' AND /*ACTIVE*/
									PostState='IN'AND /*INACTIVE*/
									PostState='RM' /*REMOVED*/
								),
CONSTRAINT PostIDFROMFKL FOREIGN KEY (PostIDFROM)
	REFERENCES Publication.bc_Post(PostID),
CONSTRAINT PostIDTOMFKL FOREIGN KEY (PostIDTO)
	REFERENCES Publication.bc_Post(PostID),
)
GO
CREATE TABLE Record.bc_HistUser(
	HistUserID INT IDENTITY PRIMARY KEY,
	HistUserState CHAR(2) NOT NULL CHECK (
									HistUserState='CD' AND /*CREATED*/
									HistUserState='UD'AND /*UPDATE*/
									HistUserState='RM' AND/*REMOVED*/
									HistUserState='MN'AND /*Mail not confirmed*/
									HistUserState='MC' /*Confirmed mail*/
								),
	HistUserDate DATETIME DEFAULT SYSDATETIME(),
	HistUserRegister INT, /*Registers the user who made the modifications. If there is no user, -1 must be set*/
	UserID INT,
	UserName NVARCHAR(15) NOT NULL UNIQUE,
	UserPassword NVARCHAR(30) NOT NULL,
	UserPareo NVARCHAR(200) , /*LATCH*/
	UserEmail NVARCHAR(60) NOT NULL,
	
)
GO
CREATE TABLE Record.bc_HistPerson(
	HistPersonID INT IDENTITY PRIMARY KEY,
	HistPersonState CHAR(2) NOT NULL CHECK (
									HistPersonState='CD' AND /*CREATED*/
									HistPersonState='UD'AND /*UPDATE*/
									HistPersonState='RM' AND /*REMOVED*/
									HistPersonState='MN' AND /*Mail not confirmed*/
									HistPersonState='MC' /*Confirmed mail*/
								),
	HistPersonDate DATETIME DEFAULT SYSDATETIME(),
	HistPersonRegister INT, /*Registers the user who made the modifications. If there is no user, -1 must be set*/
	PersonID INT ,
	PersonName NVARCHAR(50) NOT NULL,
	PersonLastName NVARCHAR(80),
	PersonImage NVARCHAR(90) NOT NULL DEFAULT 'noimage.png',
	PersonBirthday DATE,
)
GO
CREATE TABLE Record.bc_HistPost(
	HistPostID INT IDENTITY PRIMARY KEY,
	HistPostState CHAR(2) NOT NULL CHECK (
									HistPostState='CD' AND /*CREATED*/
									HistPostState='UD'AND /*UPDATE*/
									HistPostState='RM' AND /*REMOVED*/
									HistPostState='MN' AND/*Mail not confirmed*/
									HistPostState='MC' /*Confirmed mail*/
								),
	HistPostDate DATETIME DEFAULT SYSDATETIME(),
	HistPostRegister INT, /*Registers the user who made the modifications. If there is no user, -1 must be set*/
	PostID INT,
	PostURL NVARCHAR(60) NOT NULL,
	PostTitle NVARCHAR(200),
	PostDetail NVARCHAR(MAX),
	PostDate DATETIME DEFAULT SYSDATETIME(),
	PostDateModified DATETIME,
	UserID INT
)