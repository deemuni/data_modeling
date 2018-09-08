/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 9: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Dipti Muni
                DATE:      3-14-2018

*******************************************************************************************
*/
USE FiredUp    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 9, Question 1  [3pts possible]:
Show the serial numbers of all the "FiredAlways" stoves which have been invoiced.  Use whichever method you prefer 
(a join or a subquery).  List in order of serial number and eliminate duplicates.' + CHAR(10)
--
SELECT      DISTINCT SerialNumber AS "Serial Number"
FROM        STOVE
JOIN        INV_LINE_ITEM ON STOVE.SerialNumber = INV_LINE_ITEM.FK_StoveNbr
WHERE       Type = 'FiredAlways'
ORDER BY    SerialNumber;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 2  [3pts possible]:
Show the name and email address of all customers who have ever brought a stove in for repair (include duplicates and 
ignore customers without email addresses). ' + CHAR(10)
--

SELECT      Name,
            EMailAddress
FROM        CUSTOMER 
JOIN        STOVE_REPAIR ON STOVE_REPAIR.FK_CustomerID = CustomerID
JOIN        EMAIL ON EMAIL.FK_CustomerID = STOVE_REPAIR.FK_CustomerID;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 3  [3pts possible]:
What stoves have been sold to customers with the last name of "Smith"?  Display the customer name, stove number, stove 
type, and stove version and show the results in customer name order.' + CHAR(10)
--
SELECT      Name,
            FK_StoveNbr AS "Stove Number",
            Type,
            Version
FROM        CUSTOMER AS C1
JOIN        INVOICE AS I1 ON C1.CustomerID = I1.FK_CustomerID
JOIN        INV_LINE_ITEM AS ILI1 ON ILI1.FK_InvoiceNbr = I1.InvoiceNbr
JOIN        STOVE AS S1 ON S1.SerialNumber = ILI1.FK_StoveNbr
WHERE       Name LIKE '%Smith'
ORDER BY    C1.Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 4  [3pts possible]:
What employee has sold the most stoves in the most popular state?  ("most popular state" means the state or states for 
customers who purchased the most stoves, regardless of the stove type and version; do not hardcode a specific state 
into your query)  Display the employee number, employee name, the name of the most popular state, and the number of 
stoves sold by the employee in that state.  If there is more than one employee then display them all.' + CHAR(10)
--

SELECT TOP 1    EMP.Name,
                EMP.EmpID,
                StateProvince,
                COUNT(*) AS "ALLCount"
FROM            EMPLOYEE AS EMP
JOIN            INVOICE AS I2 ON I2.FK_EmpID = EmpID
JOIN            CUSTOMER AS C2 ON C2.CustomerID = I2.FK_CustomerID
WHERE EXISTS (
    SELECT TOP 1    StateProvince,
                    Count(*)
    FROM            CUSTOMER AS C1
    JOIN            INVOICE AS I1 ON C1.CustomerID = I1.FK_CustomerID
    Group By        StateProvince 
    Order by        Count(*) DESC

)
GROUP BY        EMP.Name, EMP.EmpID, StateProvince
ORDER BY        "ALLCount" DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 5  [3pts possible]:
Identify all the sales associates who have ever sold the FiredAlways version 1 stove; show a breakdown of the total 
number sold by color.  i.e. for each line, show the employee name, the stove color, and the total number sold.  Sort 
the results by name, then color.' + CHAR(10)
--
SELECT      EMP.Name,
            S1.Color,
            COUNT(*) AS "Total Number Sold"
FROM        STOVE AS S1
JOIN        INV_LINE_ITEM AS ILI ON ILI.FK_StoveNbr = S1.SerialNumber
JOIN        INVOICE AS I1 ON I1.InvoiceNbr = ILI.FK_InvoiceNbr
JOIN        EMPLOYEE AS EMP ON I1.FK_EmpID = EMP.EmpID
Where       [Version] = 1
AND         Type = 'FiredAlways'
GROUP BY    EMP.Name, S1.Color
ORDER BY    EMP.Name, S1.Color;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 6  [3pts possible]:
Show the name and phone number for all customers who have a Hotmail address (i.e. an entry in the EMAIL table which 
ends in hotmail.com).  Include duplicate names where multiple phone numbers exist; sort results by customer name.' + CHAR(10)
--
SELECT      Name,
            P1.PhoneNbr AS "Phone Number"
FROM        CUSTOMER
JOIN        EMAIL AS E1 ON E1.FK_CustomerID = CustomerID
JOIN        PHONE AS P1 ON P1.FK_CustomerID = E1.FK_CustomerID
WHERE       EMailAddress LIKE '%hotmail.com'
ORDER BY    Name;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 7  [3pts possible]:
Show the purchase order number, average SalesPrice, and average ExtendedPrice for parts priced between $1 and $2 which 
were ordered from suppliers in Virginia.  List in descending order of average ExtendedPrice.  Format all output. ' + CHAR(10)
--
SELECT      PartNbr AS "Part Number",
            AVG(SalesPrice) AS "Sales Price",
            AVG(ExtendedPrice) AS "Extended Price"
FROM        SUPPLIER
JOIN        PURCHASE_ORDER ON SupplierNbr = FK_SupplierNbr
JOIN        PO_LINE_ITEM ON PONbr = FK_PONbr
JOIN        PART ON PartNbr = Fk_PartNbr
WHERE       State = 'VA'
AND         Cost BETWEEN 1.00 and 2.00
GROUP BY    PartNbr
ORDER BY    "Extended Price" DESC;

--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 8  [3pts possible]:
Which invoice has the second-lowest total price among invoices that do not include a sale of a FiredAlways stove? 
Display the invoice number, invoice date, and invoice total price.  If there is more than one invoice then display all 
of them. (Note: finding invoices that do not include a FiredAlways stove is NOT the same as finding invoices where a 
line item contains something other than a FiredAlways stove -- invoices have more than one line.  Avoid a JOIN with the 
STOVE since the lowest price may not involve any stove sales.)' + CHAR(10)
--

SELECT TOP 1 WITH TIES InvoiceNbr AS "Invoice Number", 
                       CONVERT(CHAR(20), InvoiceDt, 101) AS "Inoice Date", 
                       '$' + LTRIM(STR(TotalPrice, 18, 2)) AS "Total Price"
FROM                   INVOICE
WHERE                   InvoiceNbr NOT IN (
                            SELECT TOP 1 WITH TIES InvoiceNbr
                            FROM                   INVOICE
                            WHERE                  InvoiceNbr IN (
                                SELECT      FK_InvoiceNbr
                                FROM        INV_LINE_ITEM
                                WHERE       FK_StoveNbr NOT IN (
                                    SELECT      SerialNumber
                                    FROM        STOVE
                                    WHERE       Type = 'FiredAlways'
        )
    )
    ORDER BY     TotalPrice
)
ORDER BY        TotalPrice;


--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 9  [3pts possible]:
What employee(s) have sold the most stoves in the least popular color ("least popular color" means the color that has 
been purchased the least number of times, regardless of the stove type and version. Do not hardcode a specific color 
into your query)?  If there is more than one employee tied for the most then display them all.  If there is a tie for 
"least popular color" then you may pick ANY of them.  Display the employee name, number of stoves sold, and the least 
popular color.' + CHAR(10)
--

SELECT TOP 1 WITH TIES Name,
                      COUNT(*) AS "Stoves Sold",
                      Color
FROM                  STOVE 
JOIN                  INV_LINE_ITEM ON SerialNumber = FK_StoveNbr
JOIN                  INVOICE I1 ON InvoiceNbr = FK_InvoiceNbr
JOIN                  EMPLOYEE ON I1.FK_EmpID = EmpID
WHERE EXISTS (
    SELECT TOP 1 Color,
                 COUNT(*) AS "Counts"
    FROM         STOVE
    JOIN         INV_LINE_ITEM ON SerialNumber = FK_StoveNbr
    GROUP BY     Color
    ORDER BY     "Counts" ASC
) 
GROUP BY    Name, Color
ORDER BY    "Stoves Sold" DESC;
--
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 10  [3pts possible]:
Show a breakdown of all part entries in invoices.  For each invoice, show the customer name, invoice number, the number 
of invoice lines for parts (exclude stoves!), the total number of parts for the invoice (add up Quantity), and the total 
ExtendedPrice values for these parts.  Format all output; sort by customer name, then invoice number. ' + CHAR(10)
--
SELECT      Name,
            InvoiceNbr AS "Invoice Number",
            COUNT(*) AS "Count",
            SUM(Quantity) AS "Quantity Total",
            '$' + LTRIM(STR(SUM(ExtendedPrice), 18, 2)) AS "Extended Price Total"
FROM        PART 
JOIN        INV_LINE_ITEM ON PartNbr = FK_PartNbr
JOIN        INVOICE ON FK_InvoiceNbr = InvoiceNbr
JOIN        CUSTOMER ON FK_CustomerID = CustomerID
GROUP BY    PartNbr, Name, InvoiceNbr
ORDER BY    Name, InvoiceNbr;
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 9' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


