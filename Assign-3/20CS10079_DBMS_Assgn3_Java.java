import java.util.*;
import java.io.*;
import java.sql.*;
// keep the .jar file in the same directory as this file
// Name of .jar file: postgresql-42.2.18.jar

/* run the program using the command: 

$ javac 20CS10079_DBMS_Assgn3_Java.java
$ java -cp postgresql-42.2.18.jar Yashraj_20CS10079_DBMS_Assgn3_Java
---------------OR----------------
$ make java

*/

class Yashraj_20CS10079_DBMS_Assgn3_Java
{
    // Function to format the output
    public static void format(ResultSet res)
    {
        try
        {
            ResultSetMetaData rsmd = res.getMetaData();             // To get the column names
            int columnsNumber = rsmd.getColumnCount();              // To get the number of columns
            int x=0;                                                // To check if there is any data in the result set  
            while (res.next()) {
                if(x==0)                                            // To print the column names only once
                {
                    for (int i = 1; i <= columnsNumber; i++) {
                        if (i > 1) System.out.print(" | ");
                        System.out.print(rsmd.getColumnName(i));
                    }
                    System.out.println("");
                    System.out.println("--------------------------------------------");
                }
                for (int i = 1; i <= columnsNumber; i++)           // To print the data
                {
                    if (i > 1) System.out.print(" | ");
                    String columnValue = res.getString(i);
                    String colType = rsmd.getColumnTypeName(i);
                    if(colType.equals("timestamp"))
                        columnValue = columnValue.substring(0,10);
                    System.out.print(columnValue);
                }
                System.out.println("");                             // To print a new line
                x++;                                                // Incrementing x
            }   
            if(x==0)                                                // If there is no data in the result set
            {
                System.out.println("No data retrieved!!!");
            }
        }
        catch(Exception e)
        {
            System.out.println(e);
        }
    }

    public static void main(String args[])
    {
        Scanner sc = new Scanner(System.in);                // To take input from the user
        
        try
        {
        Class.forName("org.postgresql.Driver");             // To load the driver

        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/asgn2", "postgres", "jarhasy");         // To connect to the database
        Statement stmnt;                        // To execute the query
        ResultSet res;                          // To store the result of the query

        conn.setAutoCommit(false);              // To disable auto commit
        while(true)
        {
            //Printing the console
            System.out.println("1] Names of all physicians who are trained in procedure named \"bypass surgery\".");
            System.out.println("2] Names of all physicians affiliated with the department \"cardiology\" and trained in \"bypass surgery\".");
            System.out.println("3] Names of all nurses who have ever been on call for room 123.");
            System.out.println("4] Names and addresses of all patients who were prescribed the medication name \"remdesivir\".");
            System.out.println("5] Name and InsuranceID of all patients who have stayed in the \"icu\" for more than 15 days.");
            System.out.println("6] Names of all nurses who assisted in the procedure named \"bypass surgery\".");
            System.out.println("7] Name and position of all nurses who assisted in the procedure named \"bypass surgery\" along with the names of and the accompanying physicians.");
            System.out.println("8] Obtain the names of all physicians who ahve performed a medical procedure they have never been trained to perform.");
            System.out.println("9] Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).");
            System.out.println("10] Names of all physicians along with procedure name, date when procedure was carried out, name of the patient on whom the procedure was carried out who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).");
            System.out.println("11] Names of all patients (also include, for each patient, the name of the patients physician), such that the patient has been prescribed some medication  by his/her physician, the patient has undergone a procedure with a cost larger than 5000, the patient has had at least two appointment where the physician was affiliated with the cardiology department and the patient's physician is not the head of any department.");
            System.out.println("12] Name and Brand of the medication which has been prescribed the highest no of times.");
            System.out.println("--->Enter -1 to exit.");
            System.out.println("13] Names of all physicians who are trained in a particular procedure.");
            System.out.print("Enter the choice: ");
        
            int ch = sc.nextInt();
            // System.out.println(ch);

            switch(ch)
            {
                case 1:
                    stmnt = conn.createStatement();             // To create a statement             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Physician Name\" FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';");
                    format(res);                                // To format the output
                    break;
                case 2:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Physician Name\" FROM Physician P, Affiliated_with A, Department D, Trained_in T, Procedure Pr WHERE P.EmployeeID = A.Physician AND A.Department = D.DepartmentID AND D.Name='Cardiology' AND P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';");
                    format(res);
                    break;
                case 3:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT N.Name AS \"Nurse Name\" FROM Nurse N, On_Call O, Room R WHERE N.EmployeeID = O.Nurse AND O.BlockFloor = R.BlockFloor AND O.BlockCode = R.BlockCode AND R.Number = 123;");
                    format(res);
                    break;
                case 4:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Patient Name\", P.Address AS \"Patient Address\" FROM Patient P, Prescribes Pr, Medication M WHERE P.SSN = Pr.Patient AND Pr.Medication = M.Code AND M.Name='remdesivir';");
                    format(res);
                    break;
                case 5:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Patient Name\", P.InsuaranceID AS \"Patient InsuranceID\" FROM Patient P, Stay S, Room R WHERE P.SSN = S.Patient AND S.Room = R.Number AND R.Type='icu' AND EXTRACT(EPOCH FROM (S.\"End\" - S.Start)) > 1296000;");
                    format(res);
                    break;
                case 6:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT N.Name AS \"Nurse Name\" FROM Nurse N, Undergoes U, Procedure Pr WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery';");
                    format(res);
                    break;
                case 7:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT N.Name AS \"Nurse Name\", N.Position AS \"Nurse Position\", P.Name AS \"Accompanying Physician\" FROM Nurse N, Undergoes U, Procedure Pr, Physician P WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery' AND U.Physician = P.EmployeeID;");
                    format(res);
                    break;
                case 8:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS Name FROM Physician P, Undergoes U, Procedure Pr WHERE P.EmployeeID = U.Physician AND U.Procedure = Pr.Code AND NOT EXISTS (SELECT * FROM Trained_in T WHERE T.Physician = P.EmployeeID AND T.Treatment = Pr.Code);");
                    format(res);
                    break;
                case 9:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Physician Name\" FROM Physician P, Undergoes U, Trained_in T WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires;");
                    format(res);
                    break;
                case 10:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT P.Name AS \"Physician Name\", Pr.Name AS \"Procedure Name\", U.Date AS \"Date\", Pat.Name AS \"Patient Name\" FROM Physician P, Undergoes U, Trained_in T, Patient Pat, Procedure Pr WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires AND Pat.SSN = U.Patient AND Pr.Code = U.Procedure;");
                    format(res);
                    break;
                case 11:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT Pat.Name AS \"Patient Name\", Phy.Name AS \"Physician Name\" FROM Patient Pat, Physician Phy, Undergoes U, Procedure Pro WHERE Pat.PCP = Phy.EmployeeID AND (EXISTS (SELECT * FROM Prescribes Pres WHERE Pres.Patient = Pat.SSN)) AND (Pat.SSN = U.Patient AND U.Procedure = Pro.Code AND Pro.Cost > 5000) AND ((  SELECT COUNT(Prescribes.Patient) FROM Prescribes, Appointment, Physician, Affiliated_with, Department WHERE Prescribes.Appointment IS NOT NULL AND Prescribes.Physician = Appointment.Physician AND Appointment.Physician = Physician.EmployeeID AND Physician.EmployeeID = Affiliated_with.Physician AND Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology') >= 2) AND (NOT EXISTS (SELECT * FROM Department D WHERE D.Head = Phy.EmployeeID));");
                    format(res);
                    break;
                case 12:
                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery("SELECT M.Name AS \"Medication Name\", M.Brand AS \"Medication Brand\" FROM Medication M WHERE M.Code = (SELECT foo.coln FROM(SELECT P.Medication AS coln, COUNT(*) AS cnt FROM Prescribes P GROUP BY P.Medication ORDER BY cnt DESC) AS foo LIMIT 1);");
                    format(res);
                    break;
                case 13:
                    // getting the surgery name
                    System.out.print("Enter the surgery name: ");
                    String temp = sc.nextLine();
                    String proc = sc.nextLine();
                    for (int i = 0; i < proc.length(); i++) // loop to remove \n from end of proc
                    {
                        if (proc.charAt(i) == '\n')
                        {
                            proc = proc.substring(0, i);
                            break;
                        }
                    }

                    // Making the query
                    String query = "SELECT P.Name AS Name FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='";
                    query += proc;              // adding the surgery name
                    query += "';";              // adding the closing semicolon

                    stmnt = conn.createStatement();             
                    res = stmnt.executeQuery(query);
                    format(res);
                    break;
                case -1:
                    conn.close();               // closing the connection
                    sc.close();                 // closing the scanner
                    return ;
                default:
                    System.out.println("Invalid input");            // Notifying user of invalid input
                    break;
            }
        }

        }
        catch(Exception e)
        {
            System.out.println(e);
        }

        sc.close();                             // closing the scanner
    }
}