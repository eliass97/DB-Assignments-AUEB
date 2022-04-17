-- A)

create table flights(
    fno char(4) not null,
    fromCity varchar(20) not null,
    toCity varchar(20) not null,
    distance int not null,
    depDate date not null,
    depTime time not null,
    arrDate date not null,
    arrTime time not null,
    price int not null,
    primary key(fno),
    check (distance>=0),
    check (price>=0)
);

create table aircrafts (
    aid int not null,
    aname varchar(20) not null,
    crange int not null,
    primary key(aid)
);

create table employees (
    empid int not null,
    lastname varchar(20) not null,
    firstname varchar (20) not null,
    salary int not null,
    primary key(empid)
);

create table certified (
    empid int not null,
    aid int not null,
    primary key(empid,aid),
    constraint fk_aid foreign key (aid) references aircrafts(aid),
    constraint fk_empid foreign key (empid) references employees(empid)
);

-- B)

insert into flights values('A300','Αθήνα','Τορόντο',1000,'2017-05-01','09:00','2017-05-01','18:00',800)
insert into flights values('A301','Αθήνα','Νέα Υόρκη',1200,'2017-05-01','09:00','2017-05-01','17:00',1000)
insert into flights values('A302','Αθήνα','Λονδίνο',500,'2017-05-02','18:00','2017-05-02','21:00',500)
insert into flights values('A303','Αθήνα','Λονδίνο',600,'2017-05-02','19:00','2017-05-02','22:00',600)
insert into flights values('A400','Αθήνα','Μελβούρνη',3000,'2017-05-03','19:00','2017-05-04','05:00',2500)
insert into flights values('A401','Λονδίνο','Μελβούρνη',2500,'2017-05-03','09:00','2017-05-03','20:00',3000)
insert into flights values('A305','Λονδίνο','Αθήνα',500,'2017-05-03','10:00','2017-05-03','12:00',400)
insert into flights values('A306','Παρίσι','Αθήνα',700,'2017-05-04','11:00','2017-05-04','13:00',600)
insert into flights values('A307','Ρώμη','Νέα Υόρκη',1500,'2017-05-04','12:00','2017-05-04','23:00',1700)
insert into flights values('A308','Λονδίνο','Νέα Υόρκη',1700,'2017-05-05','13:00','2017-05-05','21:00',2000)

insert into aircrafts values(1,'Boeing 787',10000)
insert into aircrafts values(2,'Boeing 777',8000)
insert into aircrafts values(3,'Boeing B29',2000)
insert into aircrafts values(4,'Boeing 747',3000)
insert into aircrafts values(5,'Airbus A320',5000)
insert into aircrafts values(6,'Airbus A380',2000)
insert into aircrafts values(7,'Learjet 23',1000)
insert into aircrafts values(8,'Douglas DC3',7000)
insert into aircrafts values(9,'Super Jumbo',15000)
insert into aircrafts values(10,'Ilyushin',1500)

insert into employees values(10,'Αβραμίδης','Μάριος',6000)
insert into employees values(14,'Αγγελίδου','Μαρία',5000)
insert into employees values(15,'Αγγελοπούλου','Ελένη',2000)
insert into employees values(11,'Αθανασιάδης','Αγγελος',7000)
insert into employees values(16,'Αλεξάνδρου','Αννα',6000)
insert into employees values(17,'Βαμβακά','Νέλη',2000)
insert into employees values(12,'Βλαχόπουλος','Ιωάννης',1500)
insert into employees values(13,'Βούλγαρης','Δημήτρης',3000)
insert into employees values(18,'Γαλάνη','Νάντια',6000)
insert into employees values(19,'Γεωργίου','Γεώργιος',2000)

insert into certified values(10,1)
insert into certified values(10,2)
insert into certified values(10,3)
insert into certified values(10,4)
insert into certified values(11,2)
insert into certified values(11,3)
insert into certified values(12,1)
insert into certified values(12,2)
insert into certified values(12,5)
insert into certified values(12,6)
insert into certified values(13,7)
insert into certified values(13,8)
insert into certified values(13,9)
insert into certified values(14,10)
insert into certified values(14,1)
insert into certified values(14,9)
insert into certified values(15,10)
insert into certified values(16,8)
insert into certified values(16,9)

-- C)

select *
from flights
where depDate='2017-05-01' and toCity='Τορόντο'

select *
from flights
where distance between 900 and 1500
order by distance

select toCity,count(fno) as total
from flights
where depDate between '2017-05-01' and '2017-05-30'
group by toCity

select toCity,count(fno) as total
from flights
group by toCity
having count(fno) >= 3

select firstname,lastname
from employees,certified
where employees.empid = certified.empid
group by firstname,lastname
having count(aid) >= 3

select sum(salary)
from employees

select sum(salary)
from employees
where employees.empid in (select empid from certified)

select sum(salary)
from employees
where employees.empid not in (select empid from certified)

select distinct aname
from aircrafts
where crange >= (select distance from flights where fromCity = 'Αθήνα' and toCity = 'Μελβούρνη')

select distinct firstname,lastname
from employees,certified,aircrafts
where employees.empid = certified.empid and certified.aid = aircrafts.aid and aircrafts.aname like 'Boeing%'

select distinct firstname,lastname
from employees,certified,aircrafts 
where employees.empid = certified.empid and aircrafts.aid = certified.aid and aircrafts.crange > 3000
EXCEPT
select distinct firstname,lastname
from employees,certified,aircrafts
where employees.empid = certified.empid and certified.aid = aircrafts.aid and aircrafts.aname like 'Boeing%'

select firstname,lastname
from employees
where salary = (select max(salary) from employees)

select firstname,lastname
from employees
where salary = (select max(salary) from employees where salary < (select max(salary) from employees))

select aname
from aircrafts
EXCEPT
select aname
from aircrafts,certified,employees
where aircrafts.aid = certified.aid and certified.empid = employees.empid and salary < 6000

select employees.empid,max(crange) as MaxRange
from employees,certified,aircrafts
where employees.empid = certified.empid and certified.aid = aircrafts.aid
group by employees.empid
having count(certified.aid)>=3

select distinct firstname,lastname
from employees
where salary < (select min(price) from flights where toCity = 'Μελβούρνη')

select distinct firstname,lastname,salary
from employees
where employees.empid not in (select empid from certified) and salary > (select avg(salary) from employees,certified where employees.empid in (select empid from certified))

-- D)

create view Pilots as
select distinct firstname,lastname,salary
from employees,certified
where employees.empid in (select empid from certified)
create view NonPilots as
select distinct firstname,lastname,salary
from employees,certified
where employees.empid not in (select empid from certified)

select sum(salary)
from Pilots

select sum(salary)
from NonPilots

select firstname,lastname
from NonPilots
where salary > (select avg(salary) from Pilots)

create view PossibleAircraftsForFlights as
select aname,fno,fromCity,toCity
from aircrafts,flights
where crange >= distance

select aname,count(*)
from PossibleAircraftsForFlights
group by aname

-- E)

create procedure Rate_Flights as
    declare @code varchar(4)
    declare @minCode varchar(4)
    declare @cost int
    select @minCode = min(fno) from flights
    while @minCode is not null
        begin
	set @code = (select fno from flights where flights.fno = @minCode)
	set @cost = (select price from flights where flights.fno = @minCode)
	if(@cost is not null) 
	begin
	    select case
	    when @cost<=500 then @code+': Φθηνή'
	    when @cost<=1500 then @code+': Κανονική'
	    else @code+': Ακριβή'
             end
         end
         select @minCode = min(fno) from flights where @minCode < fno
     end

create procedure Certification
    @firstname varchar(20),
    @lastname varchar(20),
    @empid int,
    @aid int,
    @aname varchar(20)
    as
    begin
        declare @cP int
        declare @cA int
        declare @connection int
        select @connection = 0
        select @cP = 0
        select @cA = 0
        select @cP = count(*) from employees where firstname = @firstname and lastname = @lastname
        select @cA = count(*) from aircrafts where aname = @aname
	if(@cP = 0)
	begin
	    insert into employees values(@empid,@firstname,@lastname,3000)
	    print 'Inserted new employee.'
	end
	if(@cA = 0)
	begin
	    insert into aircrafts values(@aid,@aname,1000)
	    print 'Inserted new aircraft.'
	end
	select @connection = count(*) from certified where empid = @empid and aid = @aid
	if(@connection = 0)
	begin
	    insert into certified values(@empid,@aid)
	    print 'Certification is completed'
	end
	else
	    print 'Pilot is already certified'
    end

-- F) 

create trigger Raise
on certified
after insert as
begin
    declare @cou int
    declare @newsalary int
    declare @empid int
    set @empid = (select empid from inserted)
    select @cou = 0
    select @cou = count(*) from certified where certified.empid = @empid
    if(@cou >= 3) 
    begin
        set @newsalary = (select salary from employees where employees.empid = @empid)
        set @newsalary = @newsalary + @newsalary*0.1
        update employees set salary = @newsalary where employees.empid = @empid
        print 'Gave a 10% raise to the specific pilot.'
    end
end

create trigger PriceChange
on flights
after update as
begin
    declare @oldprice int
    declare @newprice int
    declare @datetime datetime
    declare @fno varchar(4)
    declare @user varchar(20)
    set @oldprice = (select price from deleted)
    set @newprice = (select price from inserted)
    set @fno = (select fno from inserted)
    set @datetime = getdate()
    set @user = current_user
    insert into flight_history values(@fno,@user,@datetime,@oldprice,@newprice)
end
