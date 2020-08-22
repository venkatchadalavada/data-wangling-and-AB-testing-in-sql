--Table creation for ERD diagram illustration 

--Note: Using microsoft SQL server

CREATE TABLE CompanyBranch 
	(branchID VARCHAR(8) NOT NULL, 
	branchName VARCHAR(20) NOT NULL, 
	phone VARCHAR(20) NOT NULL,
	[Address] VARCHAR(50) NOT NULL, 
	CONSTRAINT PK_CompanyBranch PRIMARY KEY (branchID) ) ;

CREATE TABLE Department
	(deptID VARCHAR(8) NOT NULL, 
	[name] VARCHAR(20) NOT NULL,
	phone VARCHAR(20) NOT NULL, 
	CONSTRAINT PK_Department PRIMARY KEY (deptID) ) ;


CREATE TABLE Employee 
	(empID VARCHAR(8) NOT NULL, 
	firstName VARCHAR(20) NOT NULL, 
	LastName VARCHAR(20) NOT NULL,
	[Address] VARCHAR(50) NOT NULL, 
	email VARCHAR(250) NOT NULL,
	deptID VARCHAR(8) NOT NULL,
	branchID VARCHAR(8) NOT NULL,
	CONSTRAINT PK_Employee PRIMARY KEY (empID), 
	CONSTRAINT FK_deptID FOREIGN KEY (deptID) 
	REFERENCES Department (deptID),
	CONSTRAINT FK_branchID FOREIGN KEY (branchID) 
	REFERENCES CompanyBranch (branchID) );

CREATE TABLE Skill
	(skill VARCHAR(20) NOT NULL, 
	skill_elaboration VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Skill PRIMARY KEY (skill) ) ;

CREATE TABLE EmployeeSkill
	(empID VARCHAR(8) NOT NULL,
	skill VARCHAR(20) NOT NULL,
	skill_level VARCHAR(10) NOT NULL,
	constraint PK_EmployeeSkill primary key(empID,skill),
	constraint FK_empID foreign key(empID) references Employee (empID),
	constraint FK_skill foreign key(skill) references Skill (skill));
