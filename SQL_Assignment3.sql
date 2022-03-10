Drop TABLE InStoreStaffPayment
DROP TABLE DriverPayment
DROP TABLE Payment
DROP TABLE QIngredientOrderIngredient
DROP TABLE QMenuItemIngredient
DROP TABLE IngredientOrder
DROP TABLE QSupplierIngredient
DROP TABLE Supplier
DROP TABLE Ingredient
DROP TABLE QOrderMenuItem
DROP TABLE MenuItem
DROP TABLE Delivery
DROP TABLE PickUp
DROP TABLE PhoneOrder
DROP TABLE WalkInOrder
DROP TABLE Orders
DROP TABLE InStoreShift
DROP TABLE driverShift
DROP TABLE Shift
DROP TABLE Driver
DROP TABLE InStoreStaff
DROP TABLE Employee
DROP TABLE Customer
--DROP TABLE


CREATE TABLE Customer(
	customerID CHAR(15) PRIMARY KEY,
	firstName VARCHAR(15) NOT NULL,
	lastName VARCHAR(15) NOT NULL,
	address VARCHAR(15) NOT NULL,
	phoneNumber VARCHAR(10) NOT NULL,
	status VARCHAR(10) DEFAULT 'unverified',
	CHECK(status IN('verified','unverified'))
)
go

CREATE TABLE Employee(
	staffNo CHAR(10) PRIMARY KEY,
	firstName VARCHAR(20) NOT NULL,
	lastName VARCHAR(20) NOT NULL,
	postalAddress VARCHAR(50) NOT NULL,
	contactNumber CHAR(10) NOT NULL,
	taxFileNumber CHAR(10) NOT NULL,
	bankDetails VARCHAR(25) NOT NULL,
	paymentRate VARCHAR(15) NOT NULL,
	dateOfBirth DATETIME,
	status VARCHAR(20) NOT NULL
)
go

CREATE TABLE InStoreStaff(
	staffNo CHAR(10) PRIMARY KEY,
	hourlySalary CHAR(10) NOT NULL,
	description VARCHAR(50),
	FOREIGN KEY (staffNo) REFERENCES Employee(staffNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE Driver(
	staffNo CHAR(10) PRIMARY KEY,
	driverLicenseNumber CHAR(10),
	description VARCHAR(50),
	FOREIGN KEY (staffNo) REFERENCES Employee(staffNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go
CREATE TABLE Shift(
	shiftNo CHAR(10) PRIMARY KEY,
	startDate DATETIME2,
	startTime VARCHAR(20) NOT NULL,
	endDate DATETIME2,
	endTime VARCHAR(20) NOT NULL,
	shiftType VARCHAR(20) NOT NULL,
	staffNo CHAR(10) NOT NULL,
	FOREIGN KEY (staffNo) REFERENCES Employee(staffNo) ON UPDATE CASCADE ON DELETE CASCADE

)
go
CREATE TABLE driverShift(
	shiftNo CHAR(10) PRIMARY KEY,
	deliveryQuantity CHAR(10) DEFAULT '0',
	deliveryRate CHAR(10) NOT NULL,
	
	FOREIGN KEY (shiftNo) References Shift(shiftNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE InStoreShift(
	shiftNo CHAR(10) PRIMARY KEY,
	hourlyRate CHAR(10) NOT NULL,
	numberOfdelivers CHAR(10) NOT NULL,
	FOREIGN KEY (shiftNo) References Shift(shiftNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE Orders(
	orderNo CHAR(10) PRIMARY KEY,
	orderDateTime DATETIME,
	totalAmountDue FLOAT,
	orderType VARCHAR(10) CHECK(orderType IN('walkIn','phone')),
	paymentMethod VARCHAR(20) NOT NULL,
	approvalNo VARCHAR(20) NOT NULL,
	orderStatus VARCHAR(20),
	customerID CHAR(15),
	FOREIGN KEY(customerID) REFERENCES Customer(customerID) ON UPDATE CASCADE ON DELETE CASCADE,

)

go

CREATE TABLE WalkInOrder(
	orderNo CHAR(10) PRIMARY KEY,
	pickUpTime DATETIME2,
	FOREIGN KEY(orderNo) REFERENCES Orders(orderNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE PhoneOrder(
	orderNo CHAR(10) PRIMARY KEY,
	description VARCHAR(20),
	FOREIGN KEY(orderNo) REFERENCES Orders(orderNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE PickUp(
	orderNo CHAR(10) PRIMARY KEY,
	pickUpTime DATETIME2,
	FOREIGN KEY(orderNo) REFERENCES Orders(orderNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE Delivery(
	orderNo CHAR(10) PRIMARY KEY,
	deliveryTime DATETIME2,
	driverInfo VARCHAR(20) NOT NULL,
	description VARCHAR(20),
	staffNo CHAR(10),
	FOREIGN KEY(orderNo) REFERENCES Orders(orderNo) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(staffNo) REFERENCES Driver(staffNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE MenuItem(
	itemNo CHAR(10) PRIMARY KEY,
	name VARCHAR(15) NOT NULL,
	size VARCHAR(8) NOT NULL,
	currentSellingPrice FLOAT,
	description VARCHAR(50)
)
go

CREATE TABLE QOrderMenuItem(
	orderNo CHAR(10) NOT NULL,
	itemNo CHAR(10) NOT NULL,
	quantity INT NOT NULL,
	PRIMARY KEY (orderNO, itemNo),
	FOREIGN KEY(orderNo) REFERENCES Orders(orderNo) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(itemNo) REFERENCES MenuItem(itemNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE Ingredient(
	code CHAR(10) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	type VARCHAR(20) NOT NULL,
	description VARCHAR(50),
	stockLevelAtCurrentPeriod VARCHAR(20) NOT NULL,
	stockLevelAtLastPeriod VARCHAR(20) NOT NULL,
	suggestStockLevel VARCHAR(20) NOT NULL,
	reorderLevel VARCHAR(20) NOT NULL,
	putInTime DATETIME2,
	shelfLife INT NOT NULL,
)
go

CREATE TABLE Supplier(
	supplierNo CHAR(10) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	address VARCHAR(20) NOT NULL,
	phone CHAR(10) NOT NULL,
	email VARCHAR(20) NOT NULL,
	contactPerson VARCHAR(20) NOT NULL
)
go

CREATE TABLE QSupplierIngredient(
	supplierNo CHAR(10) NOT NULL,
	code CHAR(10) NOT NULL,
	quantity INT NOT NULL,
	price FLOAT NOT NULL,
	PRIMARY KEY(supplierNo,code),
	FOREIGN KEY (supplierNo) REFERENCES Supplier(supplierNo) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(code) REFERENCES Ingredient(code) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE IngredientOrder(
	orderID CHAR(10) PRIMARY KEY,
	dateOfTheOrder DATETIME2,
	recevedOrder DATETIME2,
	totalAmount CHAR(10),
	status VARCHAR(10),
	description VARCHAR(50),
	supplierNo CHAR(10),
	FOREIGN KEY (supplierNo) REFERENCES Supplier(supplierNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE QMenuItemIngredient(
	itemNo CHAR(10) NOT NULL,
	code CHAR(10) NOT NULL,
	quantity INT NOT NULL,
	PRIMARY KEY(code, itemNo),
	FOREIGN KEY(itemNo) REFERENCES MenuItem(itemNo) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(code) REFERENCES Ingredient(code) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE QIngredientOrderIngredient(
	orderID CHAR(10) NOT NULL,
	code CHAR(10) NOT NULL,
	quantity INT NOT NULL,
	price FLOAT NOT NULL,
	PRIMARY KEY(orderID,code),
	FOREIGN KEY(orderID) REFERENCES IngredientOrder(orderID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(code) REFERENCES Ingredient(code) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE Payment(
	paymentRecordID CHAR(10) PRIMARY KEY,
	grossPayment CHAR(10),
	taxWithheld CHAR(10),
	totalAmountPaid CHAR(10),
	paymentDate DATETIME2,
	patmentPeriodStartDate DATETIME2,
	paymentPeriodEndDate DATETIME2,
	bankDetails VARCHAR(20) NOT NULL,
	staffNo CHAR(10) NOT NULL,
	FOREIGN KEY(staffNo) REFERENCES Employee(staffNo) ON UPDATE CASCADE ON DELETE CASCADE
)
go

CREATE TABLE DriverPayment(
    paymentRecordID CHAR(10) PRIMARY KEY,
	deliveryQuantity CHAR(10) DEFAULT'0',
	moneyForEachDelivery INT DEFAULT '10',
	FOREIGN KEY(paymentRecordID) REFERENCES Payment(paymentRecordID) ON UPDATE CASCADE ON DELETE CASCADE,
)
go

CREATE TABLE InStoreStaffPayment(
	paymentRecordID CHAR(10) PRIMARY KEY,
	numberOfWorkingHours CHAR(10) NOT NULL,
	hourlyRate CHAR(10) NOT NULL,
	FOREIGN KEY(paymentRecordID) REFERENCES Payment(paymentRecordID) ON UPDATE CASCADE ON DELETE CASCADE,

)
go

INSERT INTO Customer
VALUES('Cus1234','Jared','Okeno','33 King Street,Bootree NSW,2225','0123335678','verified');
INSERT INTO Customer
VALUES('Cus1235','Tom','Fuke','11 Glo Street,Crown NSW,2345','0455568748','verified');
INSERT INTO Customer
VALUES('Cus1277','Jerry','Moon','5 Ham,Newcastle West NSW,2988','0418656212','unverified');
INSERT INTO Customer
VALUES('Cus1290','Fang','Wei','8 Star Street,Newcastle NSW,2255','0256555879','verified');
INSERT INTO Customer
VALUES('Cus1300','lucy','Lia','22 Green Street,Newcastle west NSW,2296','0565412392','unverified');
INSERT INTO Customer
VALUES('Cus1333','Black','Zhen','10 Queen Street,Newcastle NSW, 2223','0526678819','verified');

INSERT INTO Orders
VALUES('Ord001','2020-9-10 11:0:0',55.50,'walkIn','card','pay0123456','picked','Cus1234');
INSERT INTO Orders
VALUES('Ord002','2020-9-11 11:0:0',77.50,'phone','cash','pay0123568','picked','Cus1235');
INSERT INTO Orders
VALUES('Ord003','2020-9-13 12:0:0',46.50,'walkIn','cash','pay0123457','picked','Cus1277');
INSERT INTO Orders
VALUES('Ord004','2020-9-13 15:0:0',87.50,'phone','cash','pay0123445','picked','Cus1290');
INSERT INTO Orders
VALUES('Ord005','2020-9-14 12:0:0',45.50,'phone','card','pay0123488','picked','Cus1300');
INSERT INTO Orders
VALUES('Ord006','2020-9-15 12:0:0',66.50,'walkIn','cash','pay0123111','picked','Cus1333');


INSERT INTO WalkInOrder
VALUES('Ord001','2020-9-10 11:0:0');
INSERT INTO WalkInOrder
VALUES('Ord003','2020-9-13 12:0:0');
INSERT INTO WalkInOrder
VALUES('Ord006','2020-9-15 12:0:0');

INSERT INTO PhoneOrder
VALUES('Ord002','Need more onions');
INSERT INTO PhoneOrder
VALUES('Ord003','NO Vegetables');
INSERT INTO PhoneOrder
VALUES('Ord004','Need fox and knife');

INSERT INTO MenuItem
VALUES('Menu001','Chicken','Small',12,'fresh chicken');
INSERT INTO MenuItem
VALUES('Menu002','Beef','Small',13.5,'spicy beef and vegetables');
INSERT INTO MenuItem
VALUES('Menu003','Super','Large',15.5,'Chicken and beef');

INSERT INTO QOrderMenuItem
VALUES('Ord001','Menu001',3);
INSERT INTO QOrderMenuItem
VALUES('Ord002','Menu001',6);
INSERT INTO QOrderMenuItem
VALUES('Ord003','Menu003',4);

INSERT INTO Employee
VALUES('S0001','Ting','Li','11 Star Street, Newcastle NSW 2339','0455566329','10056555','CommBank','20','1993-7-4','working');
INSERT INTO Employee
VALUES('S0002','Dan','Wen','23 Moon Street, Newcastle NSW 2309','0887554268','10023660','CommBank','20','1995-11-2','working');
INSERT INTO Employee
VALUES('S0003','Yu','Ying','12 Star Street, Newcastle NSW 2339','0544412759','10122782','CommBank','22','1989-12-2','rest');
INSERT INTO Employee
VALUES('S0004','Jack','Zhou','9 King Street, Newcastle West NSW 2222','0557898777','10025666','CommBank','23','1992-7-11','working');
INSERT INTO Employee
VALUES('S0005','Tan','Jou','9 Star Street, Newcastle NSW 2339','0411123223','10457746','CommBank','24','1984-5-12','working');
INSERT INTO Employee
VALUES('S0006','Molly','Zhou','15 Sunshine Street, Newcastle NSW 2000','0433669894','10554444','CommBank','22','1995-1-15','working');

INSERT INTO Driver
VALUES('S0001','100222','Driving a SUV to deliver food');
INSERT INTO Driver
VALUES('S0002','100987','Driving a SUV to deliver food');
INSERT INTO Driver
VALUES('S0006','100118','Driving a SUV to deliver food');

INSERT INTO InStoreStaff
VALUES('S0003','24','Responsible to make orders');
INSERT INTO InStoreStaff
VALUES('S0004','23','Responsible to service customers');
INSERT INTO InStoreStaff
VALUES('S0005','22','Responsible to manage money');


INSERT INTO Shift
VALUES('001','2020-9-10','8:0:0','2020-9-10','16:30:0','White shift','S0002');
INSERT INTO Shift
VALUES('002','2020-9-10','16:30:0','2020-9-10','22:0:0','Night shift','S0003');
INSERT INTO Shift
VALUES('003','2020-9-11','8:0:0','2020-9-11','16:0:0','White shift','S0004');
INSERT INTO Shift
VALUES('004','2020-9-12','8:0:0','2020-9-12','16:0:0','White shift','S0005');
INSERT INTO Shift
VALUES('005','2020-9-13','16:0:0','2020-9-13','22:0:0','Night shift','S0006');
INSERT INTO Shift
VALUES('006','2020-9-14','8:0:0','2020-9-14','16:30:0','White shift','S0006');

INSERT INTO InStoreShift
VALUES('003','21','7');
INSERT INTO InStoreShift
VALUES('004','22','7');
INSERT INTO InStoreShift
VALUES('005','23','6');

INSERT INTO driverShift
VALUES('001','3','19');
INSERT INTO driverShift
VALUES('002','5','19');
INSERT INTO driverShift
VALUES('006','4','21');


INSERT INTO Supplier
VALUES('SP01','Green','Green street','0548889876','star@gmail.com','Tony');
INSERT INTO Supplier
VALUES('SP02','Tree','Tree street','0432479522','moon@gmail.com','Jack');
INSERT INTO Supplier
VALUES('SP03','Jo','Sunshine street','0556126778','Lee@gmail.com','JoJo');


INSERT INTO Ingredient
VALUES('I001','chill','Veg','spicy spicy','40%','80%','70%','40%','2020-9-11','5');
INSERT INTO Ingredient
VALUES('I002','mushroom','Veg','good','20%','70%','90%','60%','2020-9-11','10');
INSERT INTO Ingredient
VALUES('I003','tomato','Veg','fresh and red','30%','60%','60%','40%','2020-9-11','10');

INSERT INTO IngredientOrder
VALUES('IN001','2020-9-15','2020-9-16','12kg','waiting','10% discount','SP01');
INSERT INTO IngredientOrder
VALUES('IN002','2020-9-15','2020-9-17','30kg','waiting','15% discount','SP03');
INSERT INTO IngredientOrder
VALUES('IN003','2020-9-15','2020-9-17','14kg','waiting','Nothing','SP03');

INSERT INTO QIngredientOrderIngredient
VALUES('IN001','I001','4','80.0');
INSERT INTO QIngredientOrderIngredient
VALUES('IN002','I002','1','20');
INSERT INTO QIngredientOrderIngredient
VALUES('IN003','I003','10','800');



--Query.1
-- For an in-office staff with id number S003, print his/her 1stname, lname, and hourly payment rate. 
SELECT staffNo,firstName,lastName,paymentRate
FROM Employee
WHERE staffNo ='S0003';

--Query.2
--List all the shift details of a delivery staff with first name Molly and last name Zhou
--between date 2020-9-10 and 2020-9-15
SELECT d.*
FROM Employee e,Shift d
WHERE   d.staffNo =  e.staffNo AND e.firstName = 'Molly' AND e.lastName = 'Zhou'
		AND	d.startDate BETWEEN '2020-9-10 ' AND '2020-9-15'
		AND d.endDate BETWEEN '2020-9-10 ' AND '2020-9-15' ;

--Query.3
--List all the order details of the orders that are made by a walk-in customer with first name Black
--and last name Zhen between date 2020-9-14 and 2020-9-16

SELECT o.*
FROM Orders o,Customer c,WalkInOrder w
WHERE o.orderNo =w.orderNo AND
	  o.customerID = c.customerID AND
	  c.firstName = 'Black' AND
	  c.lastName = 'Zhen' AND
	  o.orderDateTime BETWEEN '2020-9-14' AND '2020-9-16';
	  
--Q4
--Print the salary paid to a delivery staff with first name Dan and last name Wen in
--current month. Note the current month is the current month that is decided by the system.


SELECT e.firstName,e.lastName, COUNT(d.staffNo) * 10 AS mySalary
FROM Driver d, Delivery d1, PhoneOrder p,Employee e
WHERE e.staffNo = d.staffNo AND e.firstName='Dan' AND e.lastName='Wen' AND d.staffNo = d1.staffNo AND d1.orderNO = p.orderNO 
GROUP BY e.firstName,e.lastName


--Q5
--List the name of the menu item that is mostly ordered in current year.



--Q6
--List the name(s) of the ingredient(s) that was/were supplied by the supplier with
--supplier ID SP03 on date 2020-9-15
SELECT  i.name,s.supplierNo,s.name,o.dateOfTheOrder
FROM Ingredient i,Supplier s,  QIngredientOrderIngredient q ,IngredientOrder o
WHERE S.supplierNo ='SP03' AND o.dateOfTheOrder ='2020-9-15' AND i.code = q.code AND q.orderID = o.orderID AND s.supplierNo = o.supplierNo 