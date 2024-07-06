DROP TABLE Charter;
CREATE TABLE Charter 
(
    AircraftNumber VARCHAR(50) NOT NULL,
    CustomerID	INT NOT NULL,
    EmployeeNumber INT NOT NULL,
    CharterTrip	INT NULL,
    CharterDate	DATE NULL,
    Destinations	VARCHAR(50) NULL,
    Distance	DECIMAL (6,2) NULL,
    HoursFlown	DECIMAL (3,1) NULL,
    WaitingHours	DECIMAL (3,1) NULL,
    FuelGallons	DECIMAL (4,1) NULL
);
--TO_DATE ('21/FEB/14', 'DD/MON/RR')   FUNCTION
DROP TABLE MODELS;
CREATE TABLE MODELS 
(
    AircraftNumber	VARCHAR(50) NOT NULL PRIMARY KEY,
    AircraftModelCode	VARCHAR(50) NOT NULL,
    ModelName	VARCHAR(50) NOT NULL,
    NumberOfSeats	INT NOT NULL,
    RentalChargePerMilage	DECIMAL (3,2) NOT NULL
);
DROP TABLE EMPLOYEE;
CREATE TABLE EMPLOYEE 
(
    EmployeeNumber  INTEGER NOT NULL,
    EmployeeFirstName	VARCHAR(50) NOT NULL,
    EmployeeLastName    VARCHAR(50) NOT NULL,
    PilotLicense	VARCHAR(50),
    MedicalType	VARCHAR(50),
    MedicalDate	DATE,
    PilotLicenses VARCHAR (50), 
    Medtype INTEGER
);
DROP TABLE Customer;
CREATE TABLE Customer 
(
    CustomerID	INT NOT NULL,
    CustomerFirstName	VARCHAR(50) NOT NULL,
    CustomerLastName    VARCHAR(50) NOT NULL,
    CustomerPhone	VARCHAR(50) NOT NULL,
    Balance	DECIMAL (5,2)
);

DROP TABLE Destinations;
CREATE TABLE Destinations 
(
    EmployeeNumber  INTEGER NOT NULL,
    Chartertrip     INTEGER NULL,
    Destinations	VARCHAR(50),
    Crew_job	VARCHAR(50) NULL,
    DestinationsID VARCHAR(50) NULL,
    CharterDate  DATE NULL
);
 
DROP TABLE Rating;
CREATE TABLE Rating 
(
    EmployeeNumber  INTEGER NOT NULL,
    RTGCODE	VARCHAR(50) NOT NULL,
    RatingName	VARCHAR(50) NOT NULL,
    EarnedRatingDate	DATE NOT NULL
);

DROP TABLE Aircraft;
CREATE TABLE Aircraft 
(
    AircraftNumber	VARCHAR(50) NOT NULL PRIMARY KEY,
    Totaltimeontheairframe	DECIMAL(6,2) NOT NULL,
    Totaltimeontheleftengine	DECIMAL(6,2) NOT NULL,
    Totaltimeontherightengine 	DECIMAL(6,2) NOT NULL
);
DROP TABLE Manufacturer;
CREATE TABLE Manufacturer 
(
    Manufacturer	VARCHAR(50) NOT NULL,
    Modelname 	VARCHAR(50) NOT NULL
);

DROP TABLE Charter;
DROP TABLE MODELS;
DROP TABLE EMPLOYEE;
DROP TABLE Customer;
DROP TABLE Destinations;
DROP TABLE Rating;
DROP TABLE Aircraft;
DROP TABLE Manufacturer;


--SQL Statements to retrieve data for each User View in tabular format.  Add Where clause for each SQL Statement based on the User Views.
SELECT J.CustomerID, J.CustomerFirstName || ', ' || J.CustomerLastName AS FULLNAME, J.CustomerPhone, J.Balance, ch.CharterTrip, ch.CharterDate, ch.Destinations, ch.Distance, ch.HoursFlown, ch.WaitingHours, ch.FuelGallons
FROM Customer J
INNER JOIN Charter ch ON J.CustomerID = ch.CustomerID;

SELECT E.EmployeeNumber, E.EmployeeFirstName || ', ' || E.EmployeeLastName AS FULLNAME, D.Chartertrip, D.Destinations, D.Crew_job
FROM EMPLOYEE E
INNER JOIN DESTINATIONS D ON E.EMPLOYEENUMBER = D.EMPLOYEENUMBER;

SELECT A.EmployeeNumber, A.EmployeeFirstName || ', ' || A.EmployeeLastName AS FULLNAME, A.PilotLicense, A.MedicalType, A.MedicalDate, R.RTGCODE,R.RatingName,R.EarnedRatingDate
FROM EMPLOYEE A 
INNER JOIN Rating R ON A.EMPLOYEENUMBER = R.EMPLOYEENUMBER;


SELECT S.AircraftNumber, S.Totaltimeontheairframe, S.Totaltimeontheleftengine, S.Totaltimeontherightengine, M.AircraftModelCode,M.ModelName,M.NumberOfSeats, M.RentalChargePerMilage 
FROM Aircraft S
INNER JOIN MODELS M ON S.AircraftNumber = M.AircraftNumber;


SELECT A.AircraftNumber, A.Totaltimeontheairframe, A.Totaltimeontheleftengine, A.Totaltimeontherightengine, C.CharterTrip, C.CharterDate, C.Destinations
FROM Aircraft A
INNER JOIN Charter C ON A.AircraftNumber = C.AircraftNumber;



--SQL Statements to retrieve Data exactly in the same format as Appendix A.

SELECT J.CustomerID, J.CustomerFirstName || ', ' || J.CustomerLastName AS FULLNAME, J.CustomerPhone, J.Balance, ch.CharterTrip, ch.CharterDate, ch.Destinations, ch.Distance, ch.HoursFlown, ch.WaitingHours, ch.FuelGallons
FROM Customer J
INNER JOIN Charter ch ON J.CustomerID = ch.CustomerID;

SELECT E.EmployeeNumber, E.EmployeeFirstName || ', ' || E.EmployeeLastName AS FULLNAME, D.Chartertrip, D.CharterDate, DestinationsID ,  D.Destinations, D.Crew_job
FROM EMPLOYEE E
INNER JOIN DESTINATIONS D ON E.EMPLOYEENUMBER = D.EMPLOYEENUMBER;

SELECT A.EmployeeNumber, A.EmployeeFirstName || ', ' || A.EmployeeLastName AS FULLNAME, A.PilotLicense, A.PilotLicenses, A.Medtype, A.MedicalType, A.MedicalDate, R.RTGCODE,R.RatingName,R.EarnedRatingDate
FROM EMPLOYEE A 
INNER JOIN Rating R ON A.EMPLOYEENUMBER = R.EMPLOYEENUMBER;

SELECT S.AircraftNumber, S.Totaltimeontheairframe, S.Totaltimeontheleftengine, S.Totaltimeontherightengine, M.AircraftModelCode,M.ModelName,M.NumberOfSeats, M.RentalChargePerMilage 
FROM Aircraft S
INNER JOIN MODELS M ON S.AircraftNumber = M.AircraftNumber;


SELECT A.AircraftNumber, A.Totaltimeontheairframe, A.Totaltimeontheleftengine, A.Totaltimeontherightengine, C.CharterTrip, C.CharterDate, C.Destinations
FROM Aircraft A
INNER JOIN Charter C ON A.AircraftNumber = C.AircraftNumber;


-- Index for Charter table
CREATE INDEX idx_Charter_CustomerID ON Charter (CustomerID);

-- Index for Destinations table
CREATE INDEX idx_Destinations_EmpNumber ON Destinations (EmployeeNumber);

-- Index for Employee table
CREATE INDEX idx_Employee_EmployeeNumber ON Employee (EmployeeNumber);

-- Index for Charter table
CREATE INDEX idx_Charter_EmployeeNumber ON Charter (EmployeeNumber);

-- Index for Customer table
CREATE INDEX idx_Customer_CustomerID ON Customer (CustomerID);

--A Select Statement to retrieve all Customers that do not have any Charter trip.
SELECT CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance
FROM Customer
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Charter WHERE CharterTrip IS NOT NULL);


--A Select Statement to retrieve all Employees that are not Charter Crew members.
SELECT EmployeeNumber, EmployeeFirstName, EmployeeLastName
FROM Employee
WHERE EmployeeNumber NOT IN (
SELECT DISTINCT EmployeeNumber 
    FROM Destinations 
    WHERE Crew_job IS NOT NULL
) AND EmployeeNumber NOT IN (
    SELECT DISTINCT EmployeeNumber 
    FROM Charter 
    WHERE CharterTrip IS NOT NULL
);

--INSERTION DATA 
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10010, 'Alfred', 'Ramas', '615-844-2573', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10011, 'Leona', 'Dunne', '713-894-1238', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10012, 'Kathy', 'Smith', '615-894-2285', 896.54);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10013, 'Paul', 'Olowski', '615-894-2180', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10014, 'Myron', 'Orlando', '615-222-1672', 673.21);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10015, 'Amy', 'O''Bria', '713-442-3381', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10016, 'James', 'Brown', '615-297-1228', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10017, 'George', 'Williams', '615-290-2556', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10018, 'Anne', 'Farriss', '713-382-7185', 0.00);
INSERT INTO Customer (CustomerID, CustomerFirstName, CustomerLastName, CustomerPhone, Balance)
VALUES
(10019, 'Olette', 'Smith', '615-297-3809', 453.98);



--Charter insertion 
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('1484P', 10010, 101, 10004, TO_DATE('06-Feb-04', 'DD-MON-YY'), 'St. Louis', 472.00, 2.9, 4.9, 97.2);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('1484P', 10012, 101, 10008, TO_DATE('07-Feb-04', 'DD-MON-YY'), 'Knoxville', 644.00, 4.1, 0, 140.6);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('1484P', 10013, 101, 10011, TO_DATE('07-Feb-04', 'DD-MON-YY'), 'Nashville', 320.00, 1.6, 0, 72.6);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('1484P', 10017, 101, 10017, TO_DATE('10-Feb-04', 'DD-MON-YY'), 'St. Louis', 508.00, 3.1, 0, 105.5);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2289L', 10001, 101, 10002, TO_DATE('05-Feb-04', 'DD-MON-YY'), 'Nashville', 320.00, 1.6, 0, 72.6);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2289L', 10005, 101, 10005, TO_DATE('06-Feb-04', 'DD-MON-YY'), 'Atlanta', 936.00, 5.1, 2.2, 354.1);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2289L', 10009, 101, 10009, TO_DATE('07-Feb-04', 'DD-MON-YY'), 'Gainesville', 1574.00, 7.9, 0, 348.4);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2289L', 10015, 101, 10015, TO_DATE('09-Feb-04', 'DD-MON-YY'), 'Gainesville', 1645.00, 6.7, 0, 459.5);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2778V', 10002, 101, 10012, TO_DATE('08-Feb-04', 'DD-MON-YY'), 'Mobile', 1574.00, 7.9, 0, 348.4);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2778V', 10007, 101, 10016, TO_DATE('09-Feb-04', 'DD-MON-YY'), 'Mostaganem', 998.00, 6.2, 3.2, 279.7);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2778V', 10012, 101, 10015, TO_DATE('09-Feb-04', 'DD-MON-YY'), 'Gainesville', 1023.00, 5.7, 3.5, 397.7);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('2778V', 10016, 101, 10016, TO_DATE('09-Feb-04', 'DD-MON-YY'), 'Mostaganem', 1645.00, 6.7, 0, 459.5);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10003, 101, 10003, TO_DATE('05-Feb-04', 'DD-MON-YY'), 'Gainesville', 472.00, 2.6, 5.2, 117.1);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10006, 101, 10006, TO_DATE('06-Feb-04', 'DD-MON-YY'), 'St. Louis', 472.00, 2.9, 4.9, 97.2);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10010, 101, 10010, TO_DATE('07-Feb-04', 'DD-MON-YY'), 'Atlanta', 998.00, 6.2, 3.2, 279.7);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10013, 101, 10013, TO_DATE('08-Feb-04', 'DD-MON-YY'), 'Knoxville', 644.00, 3.9, 4.5, 174.3);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10014, 101, 10014, TO_DATE('09-Feb-04', 'DD-MON-YY'), 'Atlanta', 936.00, 6.1, 2.1, 302.6);
INSERT INTO Charter (AircraftNumber, CustomerID, EmployeeNumber, CharterTrip, CharterDate, Destinations, Distance, HoursFlown, WaitingHours, FuelGallons)
VALUES
('4278Y', 10018, 101, 10018, TO_DATE('10-Feb-04', 'DD-MON-YY'), 'Knoxville', 644.00, 3.8, 4.5, 167.4);

--employee insertion
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(100, 'Mr. George', 'Kolmycz', NULL, NULL, NULL, NULL, NULL);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(101, 'Ms. Rhonda', 'Lewis', 'ATP', '1', TO_DATE('20-Jan-04', 'DD-MON-YY'), 'Airline Transport Pilot', 1);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(102, 'Mr. Rhett', 'VanDam', NULL, NULL, NULL, NULL, NULL);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(103, 'Ms. Anne', 'Jones', NULL, NULL, NULL, NULL, NULL);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(104, 'Mr. John', 'Lange', 'ATP', '1', TO_DATE('18-Dec-03', 'DD-MON-YY'), 'Airline Transport Pilot', 1);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(105, 'Mr. Robert', 'Williams', 'COM', '2', TO_DATE('05-Jan-04', 'DD-MON-YY'), 'Commercial Pilot License', 2);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(106, 'Mrs. Jeanine', 'Duzak', 'COM', '2', TO_DATE('10-Dec-03', 'DD-MON-YY'), 'Commercial Pilot License', 2);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(107, 'Mr. Jorge', 'Diante', NULL, NULL, NULL, NULL, NULL);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(108, 'Mr. Paul', 'Wiesenbach', NULL, NULL, NULL, NULL, NULL);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(109, 'Ms. Elizabeth', 'Travis', 'COM', '1', TO_DATE('22-Jan-04', 'DD-MON-YY'), 'Commercial Pilot License', 1);
INSERT INTO Employee (EmployeeNumber, EmployeeFirstName, EmployeeLastName, PilotLicense, MedicalType, MedicalDate, PilotLicenses, Medtype)
VALUES
(110, 'Mrs. Leighla', 'Genkazi', NULL, NULL, NULL, NULL, NULL);


--destination insertion
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10002, 'Nashville', 'Pilot', 'BNA', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10005, 'Atlanta', 'Pilot', 'ATL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10011, 'Nashville', 'Pilot', 'BNA', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10012, 'Mobile', 'Pilot', 'MOB', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10015, 'Gainesville', 'Copilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(101, 10017, 'St. Louis', 'Pilot', 'STL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(102, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(103, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(104, 10001, 'Atlanta', 'Pilot', 'ATL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(104, 10007, 'Gainesville', 'Pilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(104, 10011, 'Nashville', 'Copilot', 'BNA', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(104, 10015, 'Gainesville', 'Pilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(104, 10018, 'Knoxville', 'Copilot', 'TYS', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10003, 'Gainesville', 'Pilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10007, 'Gainesville', 'Copilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10009, 'Gainesville', 'Pilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10013, 'Knoxville', 'Pilot', 'TYS', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10016, 'Mostaganem', 'Copilot', 'MQV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(105, 10018, 'Knoxville', 'Pilot', 'TYS', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(106, 10004, 'St. Louis', 'Pilot', 'STL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(106, 10008, 'Knoxville', 'Pilot', 'TYS', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(106, 10014, 'Atlanta', 'Pilot', 'ATL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(107, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(108, 10010, 'Atlanta', 'Pilot', 'ATL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(109, 10003, 'Gainesville', 'Copilot', 'GNV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(109, 10006, 'St. Louis', 'Pilot', 'STL', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(109, 10016, 'Mostaganem', 'Pilot', 'MQV', NULL);
INSERT INTO Destinations (EmployeeNumber, Chartertrip, Destinations, Crew_job, DestinationsID, CharterDate)
VALUES
(110, NULL, NULL, NULL, NULL, NULL);

--insertion of rating
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(101, 'CFI', 'Certified Flight Instructor', TO_DATE('18-Feb-96', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(101, 'CFII', 'Certified Flight Instructor, Instrument', TO_DATE('15-Dec-98', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(101, 'INSTR', 'Instrument', TO_DATE('08-Nov-93', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(101, 'MEL', 'Multiengine Land', TO_DATE('23-Jun-94', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(101, 'SEL', 'Single Engine, Land', TO_DATE('21-Apr-93', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(104, 'INSTR', 'Instrument', TO_DATE('15-Jul-96', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(104, 'MEL', 'Multiengine Land', TO_DATE('29-Jan-97', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(104, 'SEL', 'Single Engine, Land', TO_DATE('12-Mar-95', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(105, 'CFI', 'Certified Flight Instructor', TO_DATE('18-Nov-97', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(105, 'INSTR', 'Instrument', TO_DATE('17-Apr-95', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(105, 'MEL', 'Multiengine Land', TO_DATE('12-Aug-95', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(105, 'SEL', 'Single Engine, Land', TO_DATE('23-Sep-94', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(106, 'INSTR', 'Instrument', TO_DATE('20-Dec-95', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(106, 'MEL', 'Multiengine Land', TO_DATE('02-Apr-96', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(106, 'SEL', 'Single Engine, Land', TO_DATE('10-Mar-94', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'CFI', 'Certified Flight Instructor', TO_DATE('05-Nov-98', 'DD-MON-YY')); 
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'CFII', 'Certified Flight Instructor, Instrument', TO_DATE('21-Jun-03', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'INSTR', 'Instrument', TO_DATE('23-Jul-96', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'MEL', 'Multiengine Land', TO_DATE('15-Mar-97', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'SEL', 'Single Engine, Land', TO_DATE('05-Feb-96', 'DD-MON-YY'));
INSERT INTO Rating (EmployeeNumber, RTGCODE, RatingName, EarnedRatingDate)
VALUES
(109, 'SES', 'Single Engine, Sea', TO_DATE('12-May-96', 'DD-MON-YY'));


--insertion of aircraft
INSERT INTO Aircraft (AircraftNumber, Totaltimeontheairframe, Totaltimeontheleftengine, Totaltimeontherightengine)
VALUES
('2289L', 4243.80, 768.90, 1123.40);
INSERT INTO Aircraft (AircraftNumber, Totaltimeontheairframe, Totaltimeontheleftengine, Totaltimeontherightengine)
VALUES
('1484P', 1833.10, 1833.10, 101.80);
INSERT INTO Aircraft (AircraftNumber, Totaltimeontheairframe, Totaltimeontheleftengine, Totaltimeontherightengine)
VALUES
('2778V', 7992.90, 1513.10, 789.50);
INSERT INTO Aircraft (AircraftNumber, Totaltimeontheairframe, Totaltimeontheleftengine, Totaltimeontherightengine)
VALUES
('4278Y', 2147.30, 622.10, 243.20);


--insertion of models
INSERT INTO Models (AircraftNumber, AircraftModelCode, ModelName, NumberOfSeats, RentalChargePerMilage)
VALUES
('2289L', 'C-90A', 'Beechcraft KingAir', 8, 2.67);
INSERT INTO Models (AircraftNumber, AircraftModelCode, ModelName, NumberOfSeats, RentalChargePerMilage)
VALUES
('1484P', 'PA23-250', 'Piper Aztec', 6, 1.93);
INSERT INTO Models (AircraftNumber, AircraftModelCode, ModelName, NumberOfSeats, RentalChargePerMilage)
VALUES
('2778V', 'PA31-350', 'Piper Navajo Chieftain', 10, 2.35);
INSERT INTO Models (AircraftNumber, AircraftModelCode, ModelName, NumberOfSeats, RentalChargePerMilage)
VALUES
('4278Y', 'PA31-350', 'Piper Navajo Chieftain', 10, 2.35);


--insert value manufacturer
INSERT INTO Manufacturer (Manufacturer, Modelname)
VALUES
('Beechcraft', 'KingAir');
INSERT INTO Manufacturer (Manufacturer, Modelname)
VALUES
('Piper', 'Aztec');
INSERT INTO Manufacturer (Manufacturer, Modelname)
VALUES
('Piper', 'Navajo Chieftain');
