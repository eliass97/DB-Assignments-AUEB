create table Patient (
PatID varchar(50),
SSN int(11),
Firstname varchar(50),
Lastname varchar(50),
Phonenumber varchar(14),
Email varchar(254),
primary key(PatID)
);

create table Employee (
EmpID varchar(50),
Firstname varchar(50),
Lastname varchar(50),
Sex set('Male','Female'),
Salary decimal(6,3),
EmpType set('Doctor','Nurse','Administrative','Reception'),
Experience decimal(2,1),
primary key(EmpID)
);

create table Doctor (
DocID varchar(50),
DocType set('Permanent','Visitor','Practising'),
primary key(DocID),
foreign key(DocID) references Employee(EmpID)
);

create table Appointment (
AppID varchar(50),
AppDate date,
PatID varchar(50),
DocID varchar(50),
primary key(AppID),
foreign key(PatID) references Patient(PatID),
foreign key(DocID) references Doctor(DocID)
);

create table Drug (
DruID int(15),
DruName varchar(50),
DruCompany varchar(100),
primary key(DruID)
);

create table Drug_Prices (
DruID int(15),
Price decimal(5,3),
PriceStartDate date,
PriceEndDate date,
primary key(DruID),
foreign key(DruID) references Drug(DruID)
);

create table Room (
RooID varchar(50),
RooNumber varchar(5),
BedsNumber int(2),
AssignedEmpID varchar(50),
primary key(RooID),
foreign key(AssignedEmpID) references Employee(EmpID)
);

create table Equipment (
EquID varchar(50),
Model varchar(50),
SN varchar(20),
ConstructorName varchar(100),
Description text,
AcquireDate date,
UseCost decimal(5,3),
RooID varchar(50),
primary key(EquID),
foreign key(RooID) references Room(RooID)
);

create table Equipment_NextCheck (
EquID varchar(50),
NextCheckDate date,
primary key(EquID),
foreign key(EquID) references Equipment(EquID)
);

create table Insertion (
InsID varchar(50),
PatID varchar(50),
RooID varchar(50),
DocID varchar(50),
TotalCost decimal(6,3),
primary key(InsID),
foreign key(PatID) references Patient(PatID),
foreign key(RooID) references Room(RooID),
foreign key(DocID) references Doctor(DocID)
);

create table Insertion_Drug (
InsID varchar(50),
DruID int(15),
primary key(insID,DruID),
foreign key(InsID) references Insertion(InsID),
foreign key(DruID) references Drug(DruID)
);

create table Insertion_Equipment (
InsID varchar(50),
EquID varchar(50),
primary key(InsID,EquID),
foreign key(InsID) references Insertion(InsID),
foreign key(EquID) references Equipment(EquID)
);

create table Insertion_Visitors (
InsID varchar(50),
DocID varchar(50),
primary key(InsID,DocID),
foreign key(InsID) references Insertion(InsID),
foreign key(DocID) references Doctor(DocID)
);
