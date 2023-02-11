#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Type the below command in terminal to install library "libpq-fe.h"
// sudo apt-get -y install libreadline-dev
#include <libpq-fe.h>

/*
run the following command to run the program
$ gcc 20CS10079_DBMS_Assgn3_C.c -I/usr/include/postgresql/ -lpq
$ ./a.out
----------------------OR----------------------
$ make c
*/

// Function to format the output
void format(PGresult *res)
{
    int i, j;
    int rows = PQntuples(res);              // No of rows
    int cols = PQnfields(res);              // No of columns
    if (rows == 0)
    {       
        printf("No data retrieved!!!\n");
        PQclear(res);                       // Freeing the memory
        return;
    }
    for (i = 0; i < rows; i++)              // Nested loop to print the data
    {
        for (j = 0; j < cols; j++)
        {
            printf("%s\t|", PQgetvalue(res, i, j));         // Printing the data
        }
        printf("\n");
    }
    PQclear(res);                           // Freeing the memory
}

int main()
{
    PGconn *conn = PQconnectdb("user='postgres' password='jarhasy' dbname='asgn2' hostaddr = '127.0.0.1' port = '5432' ");

    if (PQstatus(conn) == CONNECTION_BAD)                   // Checking if connection is successful
    {
        printf("Unable to connect to database!!!");
        PQfinish(conn);
        exit(0);
    }

    PGresult *res;                        // Result set

    int ch, i; // Loop var and choice var
    while (1)
    {
        // ch++;
        // Printing all the choices, ie , console
        printf("1] Names of all physicians who are trained in procedure named \"bypass surgery\".\n");
        printf("2] Names of all physicians affiliated with the department \"cardiology\" and trained in \"bypass surgery\".\n");
        printf("3] Names of all nurses who have ever been on call for room 123.\n");
        printf("4] Names and addresses of all patients who were prescribed the medication name \"remdesivir\".\n");
        printf("5] Name and InsuranceID of all patients who have stayed in the \"icu\" for more than 15 days.\n");
        printf("6] Names of all nurses who assisted in the procedure named \"bypass surgery\".\n");
        printf("7] Name and position of all nurses who assisted in the procedure named \"bypass surgery\" along with the names of and the accompanying physicians.\n");
        printf("8] Obtain the names of all physicians who ahve performed a medical procedure they have never been trained to perform.\n");
        printf("9] Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).\n");
        printf("10] Names of all physicians along with procedure name, date when procedure was carried out, name of the patient on whom the procedure was carried out who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).\n");
        printf("11] Names of all patients (also include, for each patient, the name of the patients physician), such that the patient has been prescribed some medication  by his/her physician, the patient has undergone a procedure with a cost larger than 5000, the patient has had at least two appointment where the physician was affiliated with the cardiology department and the patient's physician is not the head of any department.\n");
        printf("12] Name and Brand of the medication which has been prescribed the highest no of times.\n");
        printf("13] Names of all physicians who are trained in a particular procedure.\n");
        printf("--->Enter -1 to exit.\n");
        scanf("%d", &ch);

        switch (ch)
        {
        case 1:
            res = PQexec(conn, "SELECT P.Name AS \"Physician Name\" FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)                 // Checking if data is retrieved
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 2:
            res = PQexec(conn, "SELECT P.Name AS \"Physician Name\" FROM Physician P, Affiliated_with A, Department D, Trained_in T, Procedure Pr WHERE P.EmployeeID = A.Physician AND A.Department = D.DepartmentID AND D.Name='Cardiology' AND P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='bypass surgery';");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 3:
            res = PQexec(conn, "SELECT N.Name AS \"Nurse Name\" FROM Nurse N, On_Call O, Room R WHERE N.EmployeeID = O.Nurse AND O.BlockFloor = R.BlockFloor AND O.BlockCode = R.BlockCode AND R.Number = 123;");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 4:
            res = PQexec(conn, "SELECT P.Name AS \"Patient Name\", P.Address AS \"Patient Address\" FROM Patient P, Prescribes Pr, Medication M WHERE P.SSN = Pr.Patient AND Pr.Medication = M.Code AND M.Name='remdesivir';");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t\t|Address\t|\n");
                    printf("-----------------------------------\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 5:
            res = PQexec(conn, "SELECT P.Name AS \"Patient Name\", P.InsuaranceID AS \"Patient InsuranceID\" FROM Patient P, Stay S, Room R WHERE P.SSN = S.Patient AND S.Room = R.Number AND R.Type='icu' AND EXTRACT(EPOCH FROM (S.\"End\" - S.Start)) > 1296000;");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t\t|InsuranceID\t|\n");
                    printf("-----------------------------------\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 6:
            res = PQexec(conn, "SELECT N.Name AS \"Nurse Name\" FROM Nurse N, Undergoes U, Procedure Pr WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery';");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 7:
            res = PQexec(conn, "SELECT N.Name AS \"Nurse Name\", N.Position AS \"Nurse Position\", P.Name AS \"Accompanying Physician\" FROM Nurse N, Undergoes U, Procedure Pr, Physician P WHERE N.EmployeeID = U.AssistingNurse AND U.Procedure = Pr.Code AND Pr.Name='bypass surgery' AND U.Physician = P.EmployeeID;");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Nurse Name\t|Pos.\t|Accompanying Physician\n");
                    printf("---------------------------------------------------\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 8:
            res = PQexec(conn, "SELECT P.Name FROM Physician P, Undergoes U, Procedure Pr WHERE P.EmployeeID = U.Physician AND U.Procedure = Pr.Code AND NOT EXISTS (SELECT * FROM Trained_in T WHERE T.Physician = P.EmployeeID AND T.Treatment = Pr.Code);");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 9:
            res = PQexec(conn, "SELECT P.Name AS \"Physician Name\" FROM Physician P, Undergoes U, Trained_in T WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires;");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case 10:
            res = PQexec(conn, "SELECT P.Name AS \"Physician Name\", Pr.Name AS \"Procedure Name\", U.Date AS \"Date\", Pat.Name AS \"Patient Name\" FROM Physician P, Undergoes U, Trained_in T, Patient Pat, Procedure Pr WHERE P.EmployeeID = U.Physician AND P.EmployeeID = T.Physician AND U.Procedure = T.Treatment AND U.Date > T.CertificationExpires AND Pat.SSN = U.Patient AND Pr.Code = U.Procedure;");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Physician Name\t|Procedure Name\t|Date\t\t|Patient Name\t|\n");
                    printf("----------------------------------------------------------------\n");
                }
                format(res);                                            // Calling format function to print the data
            }   
            break;
        case 11:
            res = PQexec(conn, "SELECT Pat.Name AS \"Patient Name\", Phy.Name AS \"Physician Name\" FROM Patient Pat, Physician Phy, Undergoes U, Procedure Pro WHERE Pat.PCP = Phy.EmployeeID AND (EXISTS (SELECT * FROM Prescribes Pres WHERE Pres.Patient = Pat.SSN)) AND (Pat.SSN = U.Patient AND U.Procedure = Pro.Code AND Pro.Cost > 5000) AND ((  SELECT COUNT(Prescribes.Patient) FROM Prescribes, Appointment, Physician, Affiliated_with, Department WHERE Prescribes.Appointment IS NOT NULL AND Prescribes.Physician = Appointment.Physician AND Appointment.Physician = Physician.EmployeeID AND Physician.EmployeeID = Affiliated_with.Physician AND Affiliated_with.Department = Department.DepartmentID AND Department.Name = 'cardiology') >= 2) AND (NOT EXISTS (SELECT * FROM Department D WHERE D.Head = Phy.EmployeeID));");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Patient Name\t|Physician Name\t|\n");
                }
                format(res);                                            // Calling format function to print the data
            }

            break;
        case 12:
            res = PQexec(conn, "SELECT M.Name AS \"Medication Name\", M.Brand AS \"Medication Brand\" FROM Medication M WHERE M.Code = (SELECT foo.coln FROM(SELECT P.Medication AS coln, COUNT(*) AS cnt FROM Prescribes P GROUP BY P.Medication ORDER BY cnt DESC) AS foo LIMIT 1);");
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t|Brand\t\t|\n");
                    printf("------------------------\n");
                }
                format(res);                                            // Calling format function to print the data
            }

            break;
        case 13:
            // getting the surgery name
            char proc[100];
            for (i = 0; i < 100; i++)
                proc[i] = '\0';
            printf("Enter the procedure name: ");
            // gets(proc);
            // getchar();
            // scanf("%[^\n]%*c", proc);
            // scanf("%[^\n]s",proc);
            getchar();
            fgets(proc, 100, stdin);
            // printf("%s\n",proc);
            for (i = 0; i < 100; i++) // loop to remove \n from end of proc
                if (proc[i] == '\n')
                {
                    proc[i] = '\0';
                    break;
                }

            // Making the query
            char query[300];
            for (i = 0; i < 300; i++)
                query[i] = '\0';
            strcat(query, "SELECT P.Name FROM Physician P, Trained_in T, Procedure Pr WHERE P.EmployeeID = T.Physician AND T.Treatment = Pr.Code AND Pr.Name='");
            strcat(query, proc);
            strcat(query, "';");
            // printf("%s\n",query);

            res = PQexec(conn, query);
            if (PQresultStatus(res) != PGRES_TUPLES_OK)
            {
                printf("No data retrieved!!!\n");
                PQclear(res);
            }
            else
            {
                if (PQntuples(res) != 0)                                // Checking if data is retrieved and printing column names if data is retrieved
                {
                    printf("Name\t\t|\n");
                    printf("----------------|\n");
                }
                format(res);                                            // Calling format function to print the data
            }
            break;
        case -1:
            PQfinish(conn);                                             // Closing the connection
            exit(0);                                                    // Exiting the program
        default:
            printf("Invalid choice!!!\n");                              // If the choice is not valid
            break;
        }
    }
    return 0;
}