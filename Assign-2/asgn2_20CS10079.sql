----------------------------CREATING TABLES----------------------------------------------------------------------------------------------------------------------------

-- Table 1: Physician
CREATE TABLE Physician (
    EmployeeID INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Position TEXT NOT NULL,
    SSN INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID)
);
-- Table 2: Patient
CREATE TABLE Patient (
    SSN INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Address TEXT NOT NULL,
    Phone TEXT NOT NULL,
    InsuranceID INTEGER NOT NULL,
    PCP INTEGER NOT NULL,
    PRIMARY KEY (SSN),
    FOREIGN KEY (PCP) REFERENCES Physician(EmployeeID)
);
-- Table 3: Department
CREATE TABLE Department (
    DepartmentID INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Head INTEGER NOT NULL,
    PRIMARY KEY (DepartmentID),
    FOREIGN KEY (Head) REFERENCES Physician(EmployeeID)
);
-- Table 4: Medication
CREATE TABLE Medication (
    Code INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Brand TEXT NOT NULL,
    Description TEXT NOT NULL,
    PRIMARY KEY (Code)
);
-- Table 5: Block
CREATE TABLE Block (
    Floor INTEGER NOT NULL,
    Code INTEGER NOT NULL,
    PRIMARY KEY (Floor, Code)
);
-- Table 6: Nurse
CREATE TABLE Nurse (
    EmployeeID INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Position TEXT NOT NULL,
    Registered BOOLEAN NOT NULL,
    SSN INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID)
);
-- Table 7: Procedure
CREATE TABLE Procedure (
    Code INTEGER NOT NULL,
    Name TEXT NOT NULL,
    Cost INTEGER NOT NULL,
    PRIMARY KEY (Code)
);
-- Table 8: Room
CREATE TABLE Room (
    Number INTEGER NOT NULL,
    Type TEXT NOT NULL,
    BlockFloor INTEGER NOT NULL,
    BlockCode INTEGER NOT NULL,
    Unavailable BOOLEAN NOT NULL,
    PRIMARY KEY (Number),
    FOREIGN KEY (BlockFloor, BlockCode) REFERENCES Block(Floor, Code)
);
-- Table 9: Affiliated_with
CREATE TABLE Affiliated_with (
    Physician INTEGER NOT NULL,
    Department INTEGER NOT NULL,
    PrimaryAffiliation BOOLEAN NOT NULL,
    PRIMARY KEY (Physician, Department),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY (Department) REFERENCES Department(DepartmentID)
);
-- Table 10: Trained_in
CREATE TABLE Trained_in (
    Physician INTEGER NOT NULL,
    Treatment INTEGER NOT NULL,
    CertificationDate TIMESTAMP NOT NULL,
    CertificationExpires TIMESTAMP NOT NULL,
    PRIMARY KEY (Physician, Treatment),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY (Treatment) REFERENCES Procedure(Code)
);
-- Table 11: Appointment
CREATE TABLE Appointment (
    AppointmentID INTEGER NOT NULL,
    Patient INTEGER NOT NULL,
    PrepNurse INTEGER NULL,
    Physician INTEGER NOT NULL,
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL,
    ExaminationRoom TEXT NOT NULL,
    PRIMARY KEY (AppointmentID),
    FOREIGN KEY (Patient) REFERENCES Patient(SSN),
    FOREIGN KEY (PrepNurse) REFERENCES Nurse(EmployeeID),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID)
);
-- Table 12: On_Call
CREATE TABLE On_Call (
    Nurse INTEGER NOT NULL,
    BlockFloor INTEGER NOT NULL,
    BlockCode INTEGER NOT NULL,
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL,
    PRIMARY KEY (Nurse, BlockFloor, BlockCode),
    FOREIGN KEY (Nurse) REFERENCES Nurse(EmployeeID),
    FOREIGN KEY (BlockFloor, BlockCode) REFERENCES Block(Floor, Code)
);
-- Table 13: Stay
CREATE TABLE Stay (
    StayID INTEGER NOT NULL,
    Patient INTEGER NOT NULL,
    Room INTEGER NOT NULL,
    Start TIMESTAMP NOT NULL,
    "End" TIMESTAMP NOT NULL,
    PRIMARY KEY (StayID),
    FOREIGN KEY (Patient) REFERENCES Patient(SSN),
    FOREIGN KEY (Room) REFERENCES Room(Number)
);
-- Table 14: Prescribes
CREATE TABLE Prescribes (
    Physician INTEGER NOT NULL,
    Patient INTEGER NOT NULL,
    Medication INTEGER NOT NULL,
    Date TIMESTAMP NOT NULL,
    Appointment INTEGER NULL,
    Dose TEXT NOT NULL,
    PRIMARY KEY (Physician, Patient, Medication, Date),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY (Patient) REFERENCES Patient(SSN),
    FOREIGN KEY (Medication) REFERENCES Medication(Code)
);
-- Table 15: Undergoes
CREATE TABLE Undergoes (
    Patient INTEGER NOT NULL,
    Procedure INTEGER NOT NULL,
    Stay INTEGER NOT NULL,
    Date TIMESTAMP NOT NULL,
    Physician INTEGER NOT NULL,
    AssistingNurse INTEGER NULL,
    PRIMARY KEY (Patient, Procedure, Stay, Date),
    FOREIGN KEY (Patient) REFERENCES Patient(SSN),
    FOREIGN KEY (Procedure) REFERENCES Procedure(Code),
    FOREIGN KEY (Stay) REFERENCES Stay(StayID),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY (AssistingNurse) REFERENCES Nurse(EmployeeID)
);
---------------------------POPULATING TABLES---------------------------------------------------------------------------------------------------------------------------
INSERT INTO Physician VALUES(1,'Alan Donald','Intern',111111111);
INSERT INTO Physician VALUES(2,'Bruce Reid','Attending Physician',222222222);
INSERT INTO Physician VALUES(3,'Courtney Walsh','Surgeon Physician',333333333);
INSERT INTO Physician VALUES(4,'Malcom Marshall','Senior Physician',444444444);
INSERT INTO Physician VALUES(5,'Dennis Lillee','Head Chief of Medicine',555555555);
INSERT INTO Physician VALUES(6,'Jeff Thomson','Surgeon Physician',666666666);
INSERT INTO Physician VALUES(7,'Richard Hadlee','Surgeon Physician',777777777);
INSERT INTO Physician VALUES(8,'Kapil  Dev','Resident',888888888);
INSERT INTO Physician VALUES(9,'Ishant Sharma','Psychiatrist',999999999);

INSERT INTO Patient VALUES(100000001,'Dilip Vengsarkar','42 Foobar Lane','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000002,'Richie Richardson','37 Infinite Loop','555-0512',36546321,2);
INSERT INTO Patient VALUES(100000003,'Mark Waugh','101 Parkway Street','555-1204',65465421,2);
INSERT INTO Patient VALUES(100000004,'Ramiz Raza','1100 Sparks Avenue','555-2048',68421879,3);

INSERT INTO Department VALUES(1,'medicine',4);
INSERT INTO Department VALUES(2,'surgery',7);
INSERT INTO Department VALUES(3,'psychiatry',9);
INSERT INTO Department VALUES(4,'cardiology',8);

INSERT INTO Medication VALUES(1,'Paracetamol','Z','N/A');
INSERT INTO Medication VALUES(2,'Actemra','Foolki Labs','N/A');
INSERT INTO Medication VALUES(3,'Molnupiravir','Bale Laboratories','N/A');
INSERT INTO Medication VALUES(4,'Paxlovid','Bar Industries','N/A');
INSERT INTO Medication VALUES(5,'Remdesivir','Donald Pharmaceuticals','N/A');

INSERT INTO Block VALUES(1,1);
INSERT INTO Block VALUES(1,2);
INSERT INTO Block VALUES(1,3);
INSERT INTO Block VALUES(2,1);
INSERT INTO Block VALUES(2,2);
INSERT INTO Block VALUES(2,3);
INSERT INTO Block VALUES(3,1);
INSERT INTO Block VALUES(3,2);
INSERT INTO Block VALUES(3,3);
INSERT INTO Block VALUES(4,1);
INSERT INTO Block VALUES(4,2);
INSERT INTO Block VALUES(4,3);

INSERT INTO Nurse VALUES(101,'Eknath Solkar','Head Nurse',true,111111110);
INSERT INTO Nurse VALUES(102,'David Boon','Nurse',true,222222220);
INSERT INTO Nurse VALUES(103,'Andy Flowers','Nurse',false,333333330);

INSERT INTO Procedure VALUES(1,'bypass surgery',1500.0);
INSERT INTO Procedure VALUES(2,'angioplasty',3750.0);
INSERT INTO Procedure VALUES(3,'arthoscopy',4500.0);
INSERT INTO Procedure VALUES(4,'carotid endarterectomy',10000.0);
INSERT INTO Procedure VALUES(5,'cholecystectomy',4899.0);
INSERT INTO Procedure VALUES(6,'tonsillectomy',5600.0);
INSERT INTO Procedure VALUES(7,'cataract surgery',25.0);

INSERT INTO Room VALUES(101,'Single',1,1,false);
INSERT INTO Room VALUES(102,'Single',1,1,false);
INSERT INTO Room VALUES(103,'Single',1,1,false);
INSERT INTO Room VALUES(111,'Single',1,2,false);
INSERT INTO Room VALUES(112,'Single',1,2,true);
INSERT INTO Room VALUES(113,'Single',1,2,false);
INSERT INTO Room VALUES(121,'Single',1,3,false);
INSERT INTO Room VALUES(122,'Single',1,3,false);
INSERT INTO Room VALUES(123,'Single',1,3,false);
INSERT INTO Room VALUES(201,'Single',2,1,true);
INSERT INTO Room VALUES(202,'Single',2,1,false);
INSERT INTO Room VALUES(203,'Single',2,1,false);
INSERT INTO Room VALUES(211,'Single',2,2,false);
INSERT INTO Room VALUES(212,'Single',2,2,false);
INSERT INTO Room VALUES(213,'Single',2,2,true);
INSERT INTO Room VALUES(221,'Single',2,3,false);
INSERT INTO Room VALUES(222,'Single',2,3,false);
INSERT INTO Room VALUES(223,'Single',2,3,false);
INSERT INTO Room VALUES(301,'Single',3,1,false);
INSERT INTO Room VALUES(302,'Single',3,1,true);
INSERT INTO Room VALUES(303,'Single',3,1,false);
INSERT INTO Room VALUES(311,'Single',3,2,false);
INSERT INTO Room VALUES(312,'Single',3,2,false);
INSERT INTO Room VALUES(313,'Single',3,2,false);
INSERT INTO Room VALUES(321,'Single',3,3,true);
INSERT INTO Room VALUES(322,'Single',3,3,false);
INSERT INTO Room VALUES(323,'Single',3,3,false);
INSERT INTO Room VALUES(401,'Single',4,1,false);
INSERT INTO Room VALUES(402,'Single',4,1,true);
INSERT INTO Room VALUES(403,'Single',4,1,false);
INSERT INTO Room VALUES(411,'Single',4,2,false);
INSERT INTO Room VALUES(412,'Single',4,2,false);
INSERT INTO Room VALUES(413,'Single',4,2,false);
INSERT INTO Room VALUES(421,'Single',4,3,true);
INSERT INTO Room VALUES(422,'Single',4,3,false);
INSERT INTO Room VALUES(423,'Single',4,3,false);

INSERT INTO Affiliated_With VALUES(1,1,true);
INSERT INTO Affiliated_With VALUES(2,1,true);
INSERT INTO Affiliated_With VALUES(3,1,false);
INSERT INTO Affiliated_With VALUES(3,2,true);
INSERT INTO Affiliated_With VALUES(4,1,true);
INSERT INTO Affiliated_With VALUES(5,1,true);
INSERT INTO Affiliated_With VALUES(6,2,true);
INSERT INTO Affiliated_With VALUES(7,1,false);
INSERT INTO Affiliated_With VALUES(7,2,true);
INSERT INTO Affiliated_With VALUES(8,1,true);
INSERT INTO Affiliated_With VALUES(9,3,true);

INSERT INTO Trained_In VALUES(3,1,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(3,2,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(3,5,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(3,6,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(3,7,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(6,2,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(6,5,'2017-01-01','2017-12-31');
INSERT INTO Trained_In VALUES(6,6,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,1,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,2,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,3,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,4,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,5,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,6,'2018-01-01','2018-12-31');
INSERT INTO Trained_In VALUES(7,7,'2018-01-01','2018-12-31');

INSERT INTO Appointment VALUES(13216584,100000001,101,1,'2018-04-24 10:00','2018-04-24 11:00','A');
INSERT INTO Appointment VALUES(26548913,100000002,101,2,'2018-04-24 10:00','2018-04-24 11:00','B');
INSERT INTO Appointment VALUES(36549879,100000001,102,1,'2018-04-25 10:00','2018-04-25 11:00','A');
INSERT INTO Appointment VALUES(46846589,100000004,103,4,'2018-04-25 10:00','2018-04-25 11:00','B');
INSERT INTO Appointment VALUES(59871321,100000004,NULL,4,'2018-04-26 10:00','2018-04-26 11:00','C');
INSERT INTO Appointment VALUES(69879231,100000003,103,2,'2018-04-26 11:00','2018-04-26 12:00','C');
INSERT INTO Appointment VALUES(76983231,100000001,NULL,3,'2018-04-26 12:00','2018-04-26 13:00','C');
INSERT INTO Appointment VALUES(86213939,100000004,102,9,'2018-04-27 10:00','2018-04-21 11:00','A');
INSERT INTO Appointment VALUES(93216548,100000002,101,2,'2018-04-27 10:00','2018-04-27 11:00','B');

INSERT INTO On_Call VALUES(101,1,1,'2018-11-04 11:00','2018-11-04 19:00');
INSERT INTO On_Call VALUES(101,1,2,'2018-11-04 11:00','2018-11-04 19:00');
INSERT INTO On_Call VALUES(102,1,3,'2018-11-04 11:00','2018-11-04 19:00');
INSERT INTO On_Call VALUES(103,1,1,'2018-11-04 19:00','2018-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,2,'2018-11-04 19:00','2018-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,3,'2018-11-04 19:00','2018-11-05 03:00');

INSERT INTO Stay VALUES(3215,100000001,111,'2018-05-01','2018-05-04');
INSERT INTO Stay VALUES(3216,100000003,123,'2018-05-03','2018-05-14');
INSERT INTO Stay VALUES(3217,100000004,112,'2018-05-02','2018-05-03');

INSERT INTO Prescribes VALUES(1,100000001,1,'2018-04-24 10:47',13216584,'5');
INSERT INTO Prescribes VALUES(9,100000004,2,'2018-04-27 10:53',86213939,'10');
INSERT INTO Prescribes VALUES(9,100000004,2,'2018-04-30 16:53',NULL,'5');

INSERT INTO Undergoes VALUES(100000001,6,3215,'2018-05-02',3,101);
INSERT INTO Undergoes VALUES(100000001,2,3215,'2018-05-03',7,101);
INSERT INTO Undergoes VALUES(100000004,1,3217,'2018-05-07',3,102);
INSERT INTO Undergoes VALUES(100000004,5,3217,'2018-05-09',6,NULL);
INSERT INTO Undergoes VALUES(100000001,7,3217,'2018-05-10',7,101);
INSERT INTO Undergoes VALUES(100000004,4,3217,'2018-05-13',3,103);

----------------------------QUERYING TABLES----------------------------------------------------------------------------------------------------------------------------
--Query 1 => Names of all physicians who are trained in procedure name “bypass surgery” 
SELECT P.Name AS "Physician Name"
FROM Physician P, Trained_in T, Procedure Pr
WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';
-- ----- Query-1 OUTPUT -----
--       name
-- ----------------
--  Courtney Walsh
--  Richard Hadlee
-- (2 rows)
-- ---------------------------

--Query 2 => Names of all physicians affiliated with department name “Cardiology” and trained in "bypass surgery"
SELECT P.Name AS "Physician Name"
FROM Physician P, Affiliated_with A, Department D, Trained_in T, Procedure Pr
WHERE P.EmployeeID = A.Physician AND A.Department = D.DepartmentID AND D.Name='Cardiology' AND P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';
-- ----- Query-2 OUTPUT -----
--       name
-- ----------------
-- (0 rows)
-- ---------------------------

--Query 3 => Names of all the nurses who have ever been on call for room no 123
SELECT N.Name AS "Nurse Name"
FROM Nurse N, On_Call O, Room R
WHERE N.EmployeeID = O.Nurse AND O.BlockFloor = R.BlockFloor AND O.BlockCode = R.BlockCode AND R.Number = 123;
------- Query-3 OUTPUT -----
--     name
----------------
-- David Boon
-- Andy Flowers
--(2 rows)
-----------------------------

--Query 4 => Names and addresses of all the patients who were prescribed the medication named "remdesivir"
SELECT P.Name AS "Patient Name", P.Address AS "Patient Address"
FROM Patient P, Prescribes Pr, Medication M
WHERE P.SSN = Pr.Patient AND Pr.Medication = M.Code AND M.Name='remdesivir';
------- Query-4 OUTPUT -----
-- name | address
--------+---------
--(0 rows)
-----------------------------

--Query 5 => Name and insurance id of all the patients who sgtayed in the "icu" room type for more than 15 days
SELECT P.Name AS "Patient Name", P.InsuranceID AS "Patient InsuranceID"
FROM Patient P, Stay S, Room R
WHERE P.SSN = S.Patient AND S.Room = R.Number AND R.Type='icu' AND EXTRACT(EPOCH FROM (S."End" - S.Start)) > 1296000;
------- Query-5 OUTPUT -----
-- name | insuranceid
--------+--------------
--(0 rows)
-----------------------------

--Query 6 => Names of all nurses who assisted in the procedure named "bypass surgery"
SELECT N.Name AS "Nurse Name"
FROM Nurse N, Undergoes U, Procedure Pr
WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery';   
------- Query-6 OUTPUT -----
--    name
--------------
-- David Boon
--(1 rows)
-----------------------------

--Query 7 => Name and Position of all nurses who assisted in the procedure named "bypass surgery" along with the names of accompanying physicians
SELECT N.Name AS "Nurse Name", N.Position AS "Nurse Position", P.Name AS "Accompanying Physician"
FROM Nurse N, Undergoes U, Procedure Pr, Physician P
WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery' AND U.Physician = P.EmployeeID;
------- Query-7 OUTPUT -----
-- Nurse Name | Nurse Position | Accompanying Physician
--------------+----------------+------------------------
-- David Boon | Nurse          | Courtney Walsh
--(1 rows)
-----------------------------

--Query 8 => Obtain the name of all Physicians who have performed a medical procedure they have never been trained to perform
SELECT P.Name
FROM Physician P, Undergoes U, Procedure Pr
WHERE P.EmployeeID = U.Physician AND U.Procedure = Pr.Code AND NOT EXISTS (SELECT * FROM Trained_in T WHERE T.Physician = P.EmployeeID AND T.Treatment = Pr.Code);
------- Query-8 OUTPUT -----
--      name
------------------
-- Courtney Walsh
--(1 rows)
-----------------------------

--Query 9 => Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)
SELECT P.Name AS "Physician Name"
FROM Physician P, Undergoes U, Trained_in T
WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires;
------- Query-9 OUTPUT -----
--     name
----------------
-- Jeff Thomson
--(1 rows)
-----------------------------

--Query 10 => Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on
SELECT P.Name AS "Physician Name", Pr.Name AS "Procedure Name", U.Date AS "Date", Pat.Name AS "Patient Name"
FROM Physician P, Undergoes U, Trained_in T, Patient Pat, Procedure Pr
WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires AND Pat.SSN = U.Patient AND Pr.Code = U.Procedure;
------- Query-10 OUTPUT -----
-- Physician Name | Procedure Name  |        Date         | Patient Name
------------------+-----------------+---------------------+--------------
-- Jeff Thomson   | cholecystectomy | 2018-05-09 00:00:00 | Ramiz Raza
--(1 rows)
-----------------------------

--Query 11 => Names of all patients (also include, for each patient, the name of the patients physician), such that 
--• The patient has been prescribed some medication  by his/her physician 
--• The patient has undergone a procedure with a cost larger than 5000 
--• The patient has had at least two appointment where the physician was affiliated with the cardiology department
--• The patient's physician is not the head of any department
SELECT Pat.Name AS "Patient Name", Phy.Name AS "Physician Name"
FROM Patient Pat, Physician Phy, Undergoes U, Procedure Pro
WHERE Pat.PCP = Phy.EmployeeID AND 
(EXISTS (SELECT * FROM Prescribes Pres WHERE Pres.Patient = Pat.SSN)) AND 
(Pat.SSN = U.Patient AND U.Procedure = Pro.Code AND Pro.Cost > 5000) AND 
((  SELECT COUNT(Prescribes.Patient) 
    FROM Prescribes, Appointment, Physician, Affiliated_with, Department 
    WHERE Prescribes.Appointment IS NOT NULL AND Prescribes.Physician = Appointment.Physician AND Appointment.Physician = Physician.EmployeeID AND Physician.EmployeeID = Affiliated_with.Physician AND Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology') >= 2) AND 
(NOT EXISTS (SELECT * FROM Department D WHERE D.Head = Phy.EmployeeID));
------- Query-11 OUTPUT -----
-- Patient Name | Physician Name
----------------+----------------
--(0 rows)
-----------------------------

--Query 12 => Name and Bradn of the medication which has been prescribed the highest no of times
SELECT M.Name AS "Medication Name", M.Brand AS "Medication Brand"
FROM Medication M
WHERE M.Code = (SELECT foo.coln
                FROM(SELECT P.Medication AS coln, COUNT(*) AS cnt
                    FROM Prescribes P
                    GROUP BY P.Medication
                    ORDER BY cnt DESC) AS foo
                LIMIT 1);
------- Query-12 OUTPUT -----
-- Medication Name | Medication Brand
-------------------+------------------
-- Actemra         | Foolki Labs
--(1 rows)
-----------------------------