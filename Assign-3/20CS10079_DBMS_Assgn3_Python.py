import psycopg2                                 # pip install psycopg2
from tabulate import tabulate                   # pip install tabulate

# run the command to run the python file
# $ python3 20CS10079_DBMS_Assgn3_Python.py
#-----------------OR-----------------
# $ make python

# Function to print the result in a tabular format
def format(cursor):
    col_names = [desc[0] for desc in cursor.description]                # Get the column names in a list
    result = cursor.fetchall()                                          # Fetch all the rows
    print(tabulate(result, headers=col_names, tablefmt="psql"))         # Print the result in a tabular format

DATABASE = "asgn2"                                                      # Database name
USER = "postgres"                                                       # User name
PASSWORD = "jarhasy"                                                    # Password
HOST = "127.0.0.1"                                                      # Host name
PORT = "5432"                                                           # Port number

conn = psycopg2.connect(database=DATABASE, user=USER, password=PASSWORD, host=HOST, port=PORT)                  # Connect to the database
cursor = conn.cursor()                                                                                          # Create a cursor object
cursor.execute("select version()")                                                                              # Execute a command: this creates a new table

data = cursor.fetchone()                                                                                        # Fetch result
# print("Connection established to: ",data)                                                                     

while(1):
    # Printing the console
    print("1] Names of all physicians who are trained in procedure named \"bypass surgery\".")
    print("2] Names of all physicians affiliated with the department \"cardiology\" and trained in \"bypass surgery\".")
    print("3] Names of all nurses who have ever been on call for room 123.")
    print("4] Names and addresses of all patients who were prescribed the medication name \"remdesivir\".")
    print("5] Name and InsuranceID of all patients who have stayed in the \"icu\" for more than 15 days.")
    print("6] Names of all nurses who assisted in the procedure named \"bypass surgery\".")
    print("7] Name and position of all nurses who assisted in the procedure named \"bypass surgery\" along with the names of and the accompanying physicians.")
    print("8] Obtain the names of all physicians who ahve performed a medical procedure they have never been trained to perform.")
    print("9] Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).")
    print("10] Names of all physicians along with procedure name, date when procedure was carried out, name of the patient on whom the procedure was carried out who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).")
    print("11] Names of all patients (also include, for each patient, the name of the patients physician), such that the patient has been prescribed some medication  by his/her physician, the patient has undergone a procedure with a cost larger than 5000, the patient has had at least two appointment where the physician was affiliated with the cardiology department and the patient's physician is not the head of any department.")
    print("12] Name and Brand of the medication which has been prescribed the highest no of times.")
    print("13] Names of all physicians who are trained in a particular procedure.")
    print("--->Enter -1 to exit.")

    ch = int(input("Enter the choice number you want to know : "))      # Asking the user to enter the choice

    if ch==-1:                                                          # If the user enters -1, then exit
        conn.close()
        break
    elif ch==1:
        cursor.execute("""SELECT P.Name AS "Physician Name" FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';""")
        format(cursor)
        print("\n")
    elif ch==2:
        cursor.execute("""SELECT P.Name AS "Physician Name" FROM Physician P, Affiliated_with A, Department D, Trained_in T, Procedure Pr WHERE P.EmployeeID = A.Physician AND A.Department = D.DepartmentID AND D.Name='Cardiology' AND P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';""")
        format(cursor)
        print("\n")
    elif ch==3:
        cursor.execute("""SELECT N.Name AS "Nurse Name" FROM Nurse N, On_Call O, Room R WHERE N.EmployeeID = O.Nurse AND O.BlockFloor = R.BlockFloor AND O.BlockCode = R.BlockCode AND R.Number = 123;""")
        format(cursor)
        print("\n")
    elif ch==4:
        cursor.execute("""SELECT P.Name AS "Patient Name", P.Address AS "Patient Address" FROM Patient P, Prescribes Pr, Medication M WHERE P.SSN = Pr.Patient AND Pr.Medication = M.Code AND M.Name='remdesivir';""")
        format(cursor)
        print("\n")
    elif ch==5:
        cursor.execute("""SELECT P.Name AS "Patient Name", P.InsuaranceID AS "Patient InsuranceID" FROM Patient P, Stay S, Room R WHERE P.SSN = S.Patient AND S.Room = R.Number AND R.Type='icu' AND EXTRACT(EPOCH FROM (S."End" - S.Start)) > 1296000;""")
        format(cursor)
        print("\n")
    elif ch==6:
        cursor.execute("""SELECT N.Name AS "Nurse Name" FROM Nurse N, Undergoes U, Procedure Pr WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery';""")
        format(cursor)
        print("\n")
    elif ch==7:
        cursor.execute("""SELECT N.Name AS "Nurse Name", N.Position AS "Nurse Position", P.Name AS "Accompanying Physician" FROM Nurse N, Undergoes U, Procedure Pr, Physician P WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery' AND U.Physician = P.EmployeeID;""")
        format(cursor)
        print("\n")
    elif ch==8:
        cursor.execute("""SELECT P.Name FROM Physician P, Undergoes U, Procedure Pr WHERE P.EmployeeID = U.Physician AND U.Procedure = Pr.Code AND NOT EXISTS (SELECT * FROM Trained_in T WHERE T.Physician = P.EmployeeID AND T.Treatment = Pr.Code);""")
        format(cursor)
        print("\n")
    elif ch==9:
        cursor.execute("""SELECT P.Name AS "Physician Name" FROM Physician P, Undergoes U, Trained_in T WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires;""")
        format(cursor)
        print("\n")
    elif ch==10:
        cursor.execute("""SELECT P.Name AS "Physician Name", Pr.Name AS "Procedure Name", U.Date AS "Date", Pat.Name AS "Patient Name" FROM Physician P, Undergoes U, Trained_in T, Patient Pat, Procedure Pr WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires AND Pat.SSN = U.Patient AND Pr.Code = U.Procedure;""")
        format(cursor)
        print("\n")
    elif ch==11:
        cursor.execute("""SELECT Pat.Name AS "Patient Name", Phy.Name AS "Physician Name" FROM Patient Pat, Physician Phy, Undergoes U, Procedure Pro WHERE Pat.PCP = Phy.EmployeeID AND (EXISTS (SELECT * FROM Prescribes Pres WHERE Pres.Patient = Pat.SSN)) AND (Pat.SSN = U.Patient AND U.Procedure = Pro.Code AND Pro.Cost > 5000) AND ((  SELECT COUNT(Prescribes.Patient) FROM Prescribes, Appointment, Physician, Affiliated_with, Department WHERE Prescribes.Appointment IS NOT NULL AND Prescribes.Physician = Appointment.Physician AND Appointment.Physician = Physician.EmployeeID AND Physician.EmployeeID = Affiliated_with.Physician AND Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology') >= 2) AND (NOT EXISTS (SELECT * FROM Department D WHERE D.Head = Phy.EmployeeID));""")
        format(cursor)
        print("\n")
    elif ch==12:
        cursor.execute("""SELECT M.Name AS "Medication Name", M.Brand AS "Medication Brand" FROM Medication M WHERE M.Code = (SELECT foo.coln FROM(SELECT P.Medication AS coln, COUNT(*) AS cnt FROM Prescribes P GROUP BY P.Medication ORDER BY cnt DESC) AS foo LIMIT 1);""")
        format(cursor)
        print("\n")
    elif ch==13:
        proc = input("Enter the procedure name : ")
        query = """SELECT P.Name AS "Physician Name" FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='""" + proc + """';"""
        cursor.execute(query)
        format(cursor)
    else:
        print("Invalid choice!!!\n")                                    # If the user enters an invalid choice, notifying the user