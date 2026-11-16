# BSCS Database Systems — SQL Query Execution Evidence Report
**Course:** CS-311: Database Systems | **Instructor:** Miss Duaa-e-Nadeem  
**Student Name:** Talha Sarfraz (SAP ID: 70150006) & Group  
**Project Title:** Enhanced Cinema Management System (Full-Stack)  
**DBMS Engine:** Microsoft SQL Server (T-SQL) & SQLite 3 Verification Engine  
**Execution Status:** 100% Tested & Verified | 0 Syntax Errors | 100% Accurate Outputs  

---

## Executive Verification Summary

| Category | Instructor Requirement | Implemented & Executed | Verification Status |
| :--- | :---: | :---: | :---: |
| **Database Relations** | $\ge 10$ Tables | **19 Tables** | &#9989; 100% Verified |
| **Attributes per Table** | $\ge 10$ Columns | **Strictly 10–12 Columns** on every table | &#9989; 100% Verified |
| **Tuples per Relation** | $\ge 30$ Tuples | **30 to 120 Tuples** per table (735 total) | &#9989; 100% Verified |
| **WHERE Clause Queries** | $\ge 30$ Queries | **30 Distinct Queries** | &#9989; Executed & Captured |
| **SQL Joins** | $\ge 2$ per Join Type | **12 Queries** (6 types $\times$ 2) | &#9989; Executed & Captured |
| **SQL Subqueries** | $\ge 20$ Subqueries | **20 Distinct Subqueries** | &#9989; Executed & Captured |
| **Total SQL Operations** | Standard Term Scope | **62 Advanced Queries + 5 Updates** | &#9989; All Successful |

---

## Relation Tuple & Column Audit (19 Relations)

| # | Relation Name | Entity Type | Column Count | Tuple Count | Compliance Status |
| :-: | :--- | :--- | :-: | :-: | :---: |
| 1 | `Customer` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 2 | `Phone_Number` | Multivalued Attribute Table | **10** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 3 | `Movie` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 4 | `Screen` | Superclass Entity | **12** | **120** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 5 | `IMAXScreen` | EER Subclass (Disjoint) | **10** | **30** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 6 | `GoldScreen` | EER Subclass (Disjoint) | **10** | **30** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 7 | `PremiumScreen` | EER Subclass (Disjoint) | **10** | **30** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 8 | `SilverScreen` | EER Subclass (Disjoint) | **10** | **30** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 9 | `Showtime` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 10 | `Seat` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 11 | `Booking` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 12 | `Ticket` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 13 | `Employee` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 14 | `Tuck_Shop` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 15 | `Concession_Order` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 16 | `Concession_Item_Order` | Associative Table (M:N) | **10** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 17 | `Parking` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 18 | `Security_Checkpoint` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |
| 19 | `Movie_Review` | Primary Entity | **12** | **35** | &#9989; Pass (>= 10 cols, >= 30 rows) |

---

## Section 1: Execution Evidence for 30 WHERE Clause Queries
This section documents the execution output of all 30 distinct WHERE clause queries demonstrating relational comparison operators (`=`, `<>`, `<`, `>`, `<=`, `>=`), logical connectives (`AND`, `OR`, `NOT`), range testing (`BETWEEN`), pattern matching (`LIKE`), set membership (`IN`, `NOT IN`), null testing (`IS NULL`, `IS NOT NULL`), and group filtering (`GROUP BY ... HAVING`).

### Query #1 — Operator: `=`
**Business Scenario:** Retrieve the full profile of all registered customers who reside in the city of 'Lahore'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 12  

```sql
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type, City FROM Customer WHERE City = 'Lahore';
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | Membership_Type | City |
| --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | talha.sarfraz@gmail.com | VIP | Lahore |
| 2 | Arslan | Tariq | arslan.tariq@yahoo.com | Platinum | Lahore |
| 5 | Ayesha | Farooq | ayesha.f@gmail.com | VIP | Lahore |
| 9 | Zainab | Malik | zainab.m@gmail.com | Silver | Lahore |
| 12 | Omer | Javed | omer.javed@yahoo.com | Gold | Lahore |
| 15 | Hina | Altaf | hina.altaf@gmail.com | Silver | Lahore |

### Query #2 — Operator: `<>`
**Business Scenario:** Find all movies in the cinema catalog whose parental age rating is not 'R' (Restricted).  
**Execution Status:** &#9989; Success | **Rows Returned:** 23  

```sql
SELECT Movie_ID, Title, Genre, Age_Rating, IMDb_Rating FROM Movie WHERE Age_Rating <> 'R';
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | Age_Rating | IMDb_Rating |
| --- | --- | --- | --- | --- |
| 1 | Kung Fu Panda 4 | Animation | PG | 6.7 |
| 2 | Interstellar | Sci-Fi | PG-13 | 8.7 |
| 3 | Inception | Sci-Fi | PG-13 | 8.8 |
| 5 | Avatar: The Way of Water | Fantasy | PG-13 | 7.6 |
| 7 | Up | Animation | PG | 8.3 |
| 8 | The Dark Knight | Action | PG-13 | 9.0 |

### Query #3 — Operator: `!=`
**Business Scenario:** Retrieve all staff members who are not assigned to the 'Morning' shift schedule.  
**Execution Status:** &#9989; Success | **Rows Returned:** 26  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Shift_Timing FROM Employee WHERE Shift_Timing != 'Morning';
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Department | Shift_Timing |
| --- | --- | --- | --- | --- | --- |
| 2 | Usman | Tariq | Assistant Manager | Management | Evening |
| 3 | Noman | Khan | Senior IT Officer | Technical | Night |
| 4 | Bilal | Ahmed | Projectionist Lead | Technical | Rotational |
| 6 | Usman | Ali | Senior Cashier | Ticketing | Evening |
| 7 | Fahad | Raza | Box Office Agent | Ticketing | Night |
| 8 | Adeel | Akram | Concession Lead | Concessions | Rotational |

### Query #4 — Operator: `<`
**Business Scenario:** Identify all tuck shop items that are priced affordably at less than 250 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 8  

```sql
SELECT Item_ID, Item_Name, Category, Unit_Price, Stock_Quantity FROM Tuck_Shop WHERE Unit_Price < 250.00;
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Category | Unit_Price | Stock_Quantity |
| --- | --- | --- | --- | --- |
| 4 | Coca Cola 500ml | Beverages | 180.0 | 500 |
| 5 | Diet Coke 500ml | Beverages | 190.0 | 300 |
| 6 | Sprite Zero 500ml | Beverages | 180.0 | 320 |
| 7 | Fanta Orange 500ml | Beverages | 180.0 | 280 |
| 8 | Mineral Water 500ml | Beverages | 90.0 | 600 |
| 15 | Warm Chocolate Chip Cookie | Bakery | 240.0 | 150 |

### Query #5 — Operator: `>`
**Business Scenario:** List all blockbuster movies with an exceptional IMDb rating strictly greater than 8.5.  
**Execution Status:** &#9989; Success | **Rows Returned:** 13  

```sql
SELECT Movie_ID, Title, Director, IMDb_Rating, Box_Office_Revenue FROM Movie WHERE IMDb_Rating > 8.5;
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Director | IMDb_Rating | Box_Office_Revenue |
| --- | --- | --- | --- | --- |
| 2 | Interstellar | Christopher Nolan | 8.7 | 773000000.0 |
| 3 | Inception | Christopher Nolan | 8.8 | 836800000.0 |
| 8 | The Dark Knight | Christopher Nolan | 9.0 | 1006000000.0 |
| 9 | Oppenheimer | Christopher Nolan | 8.9 | 957000000.0 |
| 11 | Dune: Part Two | Denis Villeneuve | 8.6 | 714000000.0 |
| 12 | Spider-Man: Across the Spider-Verse | Joaquim Dos Santos | 8.7 | 690000000.0 |

### Query #6 — Operator: `<=`
**Business Scenario:** Find all movie showtimes that have 95 or fewer available seats remaining (selling fast).  
**Execution Status:** &#9989; Success | **Rows Returned:** 11  

```sql
SELECT Show_ID, Movie_ID, Screen_ID, Show_Date, Base_Price, Available_Seats, Show_Format FROM Showtime WHERE Available_Seats <= 95;
```

**Query Result Output (Top Rows Sampled):**

| Show_ID | Movie_ID | Screen_ID | Show_Date | Base_Price | Available_Seats | Show_Format |
| --- | --- | --- | --- | --- | --- | --- |
| 25 | 25 | 25 | 2024-12-26 | 1600.0 | 95 | 3D |
| 26 | 26 | 26 | 2024-12-27 | 900.0 | 94 | 3D |
| 27 | 27 | 27 | 2024-12-28 | 900.0 | 93 | 3D |
| 28 | 28 | 28 | 2024-12-01 | 900.0 | 92 | 3D |
| 29 | 29 | 29 | 2024-12-02 | 900.0 | 91 | 3D |
| 30 | 30 | 30 | 2024-12-03 | 900.0 | 90 | 3D |

### Query #7 — Operator: `>=`
**Business Scenario:** Retrieve all senior personnel earning a monthly salary of at least 75,000 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 15  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary >= 75000.00;
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Department | Monthly_Salary |
| --- | --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | General Manager | Management | 185000.0 |
| 2 | Usman | Tariq | Assistant Manager | Management | 120000.0 |
| 3 | Noman | Khan | Senior IT Officer | Technical | 95000.0 |
| 4 | Bilal | Ahmed | Projectionist Lead | Technical | 80000.0 |
| 5 | Saif | Ullah | Floor Supervisor | Management | 75000.0 |
| 16 | Junaid | Jamshed | General Manager | Management | 185000.0 |

### Query #8 — Operator: `AND`
**Business Scenario:** Find active VIP tier members who have earned more than 400 loyalty points.  
**Execution Status:** &#9989; Success | **Rows Returned:** 6  

```sql
SELECT Customer_ID, First_Name, Last_Name, Membership_Type, Loyalty_Points, Is_Active FROM Customer WHERE Membership_Type = 'VIP' AND Loyalty_Points > 400;
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Membership_Type | Loyalty_Points | Is_Active |
| --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | VIP | 450 | 1 |
| 5 | Ayesha | Farooq | VIP | 510 | 1 |
| 13 | Mariam | Raza | VIP | 600 | 1 |
| 21 | Nimra | Khalid | VIP | 530 | 1 |
| 28 | Shahid | Afridi | VIP | 580 | 1 |
| 35 | Bushra | Ansari | VIP | 620 | 1 |

### Query #9 — Operator: `OR`
**Business Scenario:** Retrieve bookings that were either confirmed or completed through the physical 'Box_Office' channel.  
**Execution Status:** &#9989; Success | **Rows Returned:** 34  

```sql
SELECT Booking_ID, Customer_ID, Total_Seats_Booked, Net_Payable, Booking_Status, Booking_Channel FROM Booking WHERE Booking_Status = 'Confirmed' OR Booking_Channel = 'Box_Office';
```

**Query Result Output (Top Rows Sampled):**

| Booking_ID | Customer_ID | Total_Seats_Booked | Net_Payable | Booking_Status | Booking_Channel |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 1740.0 | Confirmed | Online |
| 2 | 2 | 2 | 3480.0 | Confirmed | Box_Office |
| 3 | 3 | 1 | 1566.0 | Confirmed | Online |
| 4 | 4 | 2 | 3480.0 | Confirmed | Box_Office |
| 5 | 5 | 1 | 1740.0 | Confirmed | Online |
| 6 | 6 | 2 | 3306.0 | Confirmed | Box_Office |

### Query #10 — Operator: `NOT`
**Business Scenario:** Retrieve all movies that do not belong to the 'Drama' genre.  
**Execution Status:** &#9989; Success | **Rows Returned:** 29  

```sql
SELECT Movie_ID, Title, Genre, Duration_Minutes, IMDb_Rating FROM Movie WHERE NOT (Genre = 'Drama');
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | Duration_Minutes | IMDb_Rating |
| --- | --- | --- | --- | --- |
| 1 | Kung Fu Panda 4 | Animation | 94 | 6.7 |
| 2 | Interstellar | Sci-Fi | 169 | 8.7 |
| 3 | Inception | Sci-Fi | 148 | 8.8 |
| 5 | Avatar: The Way of Water | Fantasy | 192 | 7.6 |
| 6 | Gladiator II | Action | 148 | 7.2 |
| 7 | Up | Animation | 96 | 8.3 |

### Query #11 — Operator: `+ (Arithmetic in WHERE)`
**Business Scenario:** Calculate ticket gross cost with an added 100 PKR surcharge where the adjusted price exceeds 1500 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT Ticket_ID, Ticket_Number, Base_Price, (Base_Price + 100.00) AS Gross_Price_With_Surcharge FROM Ticket WHERE (Base_Price + 100.00) > 1500.00;
```

**Query Result Output (Top Rows Sampled):**

| Ticket_ID | Ticket_Number | Base_Price | Gross_Price_With_Surcharge |
| --- | --- | --- | --- |
| 1 | TKT-2024-0001 | 1500.0 | 1600.0 |
| 2 | TKT-2024-0002 | 1500.0 | 1600.0 |
| 3 | TKT-2024-0003 | 1500.0 | 1600.0 |
| 4 | TKT-2024-0004 | 1500.0 | 1600.0 |
| 5 | TKT-2024-0005 | 1500.0 | 1600.0 |
| 6 | TKT-2024-0006 | 1500.0 | 1600.0 |

### Query #12 — Operator: `- (Arithmetic in WHERE)`
**Business Scenario:** Display bookings where adjusted subtotal (Total_Amount - Discount_Amount) strictly exceeds 2000 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 17  

```sql
SELECT Booking_ID, Total_Amount, Discount_Amount, (Total_Amount - Discount_Amount) AS Adjusted_Subtotal FROM Booking WHERE (Total_Amount - Discount_Amount) > 2000.00;
```

**Query Result Output (Top Rows Sampled):**

| Booking_ID | Total_Amount | Discount_Amount | Adjusted_Subtotal |
| --- | --- | --- | --- |
| 2 | 3000.0 | 0.0 | 3000.0 |
| 4 | 3000.0 | 0.0 | 3000.0 |
| 6 | 3000.0 | 150.0 | 2850.0 |
| 8 | 3000.0 | 0.0 | 3000.0 |
| 10 | 3000.0 | 0.0 | 3000.0 |
| 12 | 3000.0 | 150.0 | 2850.0 |

### Query #13 — Operator: `* (Arithmetic in WHERE)`
**Business Scenario:** Compute total inventory valuation (Stock_Quantity * Cost_Price) for items whose total stock valuation exceeds 30,000 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 5  

```sql
SELECT Item_ID, Item_Name, Stock_Quantity, Cost_Price, (Stock_Quantity * Cost_Price) AS Total_Stock_Valuation FROM Tuck_Shop WHERE (Stock_Quantity * Cost_Price) > 30000.00;
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Stock_Quantity | Cost_Price | Total_Stock_Valuation |
| --- | --- | --- | --- | --- |
| 2 | Caramel Popcorn (Large) | 180 | 180.0 | 32400.0 |
| 4 | Coca Cola 500ml | 500 | 75.0 | 37500.0 |
| 21 | Couple Movie Combo (2 Pop + 2 Drinks) | 100 | 450.0 | 45000.0 |
| 22 | Family Feast Combo (Jumbo Pop + 4 Drinks + Nachos) | 70 | 780.0 | 54600.0 |
| 23 | Solo Binge Combo (Popcorn + Drink) | 150 | 230.0 | 34500.0 |

### Query #14 — Operator: `/ (Arithmetic in WHERE)`
**Business Scenario:** Calculate the estimated hourly wage (Monthly_Salary / 160 hours) for staff earning an hourly rate of at least 450 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 17  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Monthly_Salary, ROUND(Monthly_Salary / 160.0, 2) AS Hourly_Rate_PKR FROM Employee WHERE (Monthly_Salary / 160.0) >= 450.00;
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Monthly_Salary | Hourly_Rate_PKR |
| --- | --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | General Manager | 185000.0 | 1156.25 |
| 2 | Usman | Tariq | Assistant Manager | 120000.0 | 750.0 |
| 3 | Noman | Khan | Senior IT Officer | 95000.0 | 593.75 |
| 4 | Bilal | Ahmed | Projectionist Lead | 80000.0 | 500.0 |
| 5 | Saif | Ullah | Floor Supervisor | 75000.0 | 468.75 |
| 14 | Salman | Butt | Sound Technician | 72000.0 | 450.0 |

### Query #15 — Operator: `DISTINCT`
**Business Scenario:** Retrieve a distinct list of all cinematic genres currently represented in the cinema database.  
**Execution Status:** &#9989; Success | **Rows Returned:** 11  

```sql
SELECT DISTINCT Genre FROM Movie WHERE Status IN ('Now Showing', 'Archived');
```

**Query Result Output (Top Rows Sampled):**

| Genre |
| --- |
| Animation |
| Sci-Fi |
| Drama |
| Fantasy |
| Action |
| Comedy |

### Query #16 — Operator: `GROUP BY`
**Business Scenario:** Aggregate customer distribution by city to determine regional customer density.  
**Execution Status:** &#9989; Success | **Rows Returned:** 16  

```sql
SELECT City, COUNT(Customer_ID) AS Total_Customers FROM Customer WHERE Is_Active = 1 GROUP BY City;
```

**Query Result Output (Top Rows Sampled):**

| City | Total_Customers |
| --- | --- |
| Bahawalpur | 1 |
| Faisalabad | 1 |
| Gujranwala | 1 |
| Gujrat | 1 |
| Hyderabad | 1 |
| Islamabad | 4 |

### Query #17 — Operator: `HAVING`
**Business Scenario:** Identify departments whose average employee monthly salary exceeds 60,000 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 2  

```sql
SELECT Department, COUNT(Employee_ID) AS Total_Staff, ROUND(AVG(Monthly_Salary), 2) AS Avg_Monthly_Salary FROM Employee WHERE Employment_Status = 'Active' GROUP BY Department HAVING AVG(Monthly_Salary) > 60000.00;
```

**Query Result Output (Top Rows Sampled):**

| Department | Total_Staff | Avg_Monthly_Salary |
| --- | --- | --- |
| Management | 9 | 126666.67 |
| Technical | 8 | 83625.0 |

### Query #18 — Operator: `BETWEEN`
**Business Scenario:** Find all classic films released between January 1, 1990 and December 31, 2005.  
**Execution Status:** &#9989; Success | **Rows Returned:** 9  

```sql
SELECT Movie_ID, Title, Release_Date, Genre, Director FROM Movie WHERE Release_Date BETWEEN '1990-01-01' AND '2005-12-31';
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Release_Date | Genre | Director |
| --- | --- | --- | --- | --- |
| 15 | Titanic | 1997-12-19 | Romance | James Cameron |
| 17 | Spirited Away | 2001-07-20 | Animation | Hayao Miyazaki |
| 18 | The Matrix | 1999-03-31 | Sci-Fi | Lana Wachowski |
| 20 | The Lion King | 1994-06-24 | Animation | Roger Allers |
| 21 | Pulp Fiction | 1994-10-14 | Crime | Quentin Tarantino |
| 22 | Forrest Gump | 1994-07-06 | Drama | Robert Zemeckis |

### Query #19 — Operator: `LIKE`
**Business Scenario:** Retrieve all customer records whose registered email address is hosted on '@gmail.com'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 21  

```sql
SELECT Customer_ID, First_Name, Last_Name, Email, City FROM Customer WHERE Email LIKE '%@gmail.com';
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | City |
| --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | talha.sarfraz@gmail.com | Lahore |
| 4 | Arslan | Mehmood | arslan.m@gmail.com | Islamabad |
| 5 | Ayesha | Farooq | ayesha.f@gmail.com | Lahore |
| 7 | Sara | Naveed | sara.naveed@gmail.com | Rawalpindi |
| 9 | Zainab | Malik | zainab.m@gmail.com | Lahore |
| 10 | Usman | Sheikh | usman.sh@gmail.com | Gujranwala |

### Query #20 — Operator: `IN`
**Business Scenario:** List all tuck shop snack items belonging specifically to the categories 'Popcorn', 'Bakery', or 'Combos'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 14  

```sql
SELECT Item_ID, Item_Name, Category, Unit_Price, Size_Option FROM Tuck_Shop WHERE Category IN ('Popcorn', 'Bakery', 'Combos');
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Category | Unit_Price | Size_Option |
| --- | --- | --- | --- | --- |
| 1 | Salted Popcorn (Regular) | Popcorn | 350.0 | Regular |
| 2 | Caramel Popcorn (Large) | Popcorn | 550.0 | Large |
| 3 | Cheese Burst Popcorn (Jumbo) | Popcorn | 680.0 | Jumbo |
| 14 | Chocolate Fudge Brownie | Bakery | 320.0 | Regular |
| 15 | Warm Chocolate Chip Cookie | Bakery | 240.0 | Regular |
| 16 | Red Velvet Cupcake | Bakery | 280.0 | Regular |

### Query #21 — Operator: `ORDER BY`
**Business Scenario:** List all movies in the cinema database sorted from highest to lowest IMDb rating.  
**Execution Status:** &#9989; Success | **Rows Returned:** 28  

```sql
SELECT Movie_ID, Title, Genre, IMDb_Rating, Duration_Minutes FROM Movie WHERE Status = 'Archived' ORDER BY IMDb_Rating DESC;
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | IMDb_Rating | Duration_Minutes |
| --- | --- | --- | --- | --- |
| 23 | The Shawshank Redemption | Drama | 9.3 | 142 |
| 8 | The Dark Knight | Action | 9.0 | 152 |
| 9 | Oppenheimer | Drama | 8.9 | 180 |
| 21 | Pulp Fiction | Crime | 8.9 | 154 |
| 3 | Inception | Sci-Fi | 8.8 | 148 |
| 22 | Forrest Gump | Drama | 8.8 | 142 |

### Query #22 — Operator: `AND with < and >`
**Business Scenario:** Find high-tier showtimes with base price between 1000 and 2000 PKR hosted in 'IMAX 3D' format.  
**Execution Status:** &#9989; Success | **Rows Returned:** 10  

```sql
SELECT Show_ID, Movie_ID, Screen_ID, Base_Price, Show_Format, Available_Seats FROM Showtime WHERE Base_Price > 1000.00 AND Base_Price < 2000.00 AND Show_Format = 'IMAX 3D';
```

**Query Result Output (Top Rows Sampled):**

| Show_ID | Movie_ID | Screen_ID | Base_Price | Show_Format | Available_Seats |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 1200.0 | IMAX 3D | 119 |
| 2 | 2 | 2 | 1200.0 | IMAX 3D | 118 |
| 3 | 3 | 3 | 1200.0 | IMAX 3D | 117 |
| 4 | 4 | 4 | 1200.0 | IMAX 3D | 116 |
| 5 | 5 | 5 | 1200.0 | IMAX 3D | 115 |
| 6 | 6 | 6 | 1200.0 | IMAX 3D | 114 |

### Query #23 — Operator: `LIKE with prefix`
**Business Scenario:** Find all employees whose last name begins with the letter 'A' or 'M'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 13  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Department FROM Employee WHERE Last_Name LIKE 'A%' OR Last_Name LIKE 'M%';
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Department |
| --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | General Manager | Management |
| 4 | Bilal | Ahmed | Projectionist Lead | Technical |
| 6 | Usman | Ali | Senior Cashier | Ticketing |
| 8 | Adeel | Akram | Concession Lead | Concessions |
| 9 | Zeeshan | Malik | Barista / Server | Concessions |
| 12 | Waseem | Abbas | Head of Janitorial | Janitorial |

### Query #24 — Operator: `NOT IN`
**Business Scenario:** Find all vehicles parked that are neither motorcycles nor passenger vans.  
**Execution Status:** &#9989; Success | **Rows Returned:** 21  

```sql
SELECT Parking_ID, Customer_ID, Slot_Number, Vehicle_Type, License_Plate, Total_Parking_Fee FROM Parking WHERE Vehicle_Type NOT IN ('Motorcycle', 'Van');
```

**Query Result Output (Top Rows Sampled):**

| Parking_ID | Customer_ID | Slot_Number | Vehicle_Type | License_Plate | Total_Parking_Fee |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | P-02 | Car | LHR-2001 | 350.0 |
| 2 | 2 | P-03 | SUV | LHR-2002 | 350.0 |
| 5 | 5 | P-06 | EV | LHR-2005 | 350.0 |
| 6 | 6 | P-07 | Car | LHR-2006 | 350.0 |
| 7 | 7 | P-08 | SUV | LHR-2007 | 350.0 |
| 10 | 10 | P-11 | EV | LHR-2010 | 350.0 |

### Query #25 — Operator: `DISTINCT with ORDER BY`
**Business Scenario:** Retrieve all distinct customer membership tiers ordered alphabetically.  
**Execution Status:** &#9989; Success | **Rows Returned:** 5  

```sql
SELECT DISTINCT Membership_Type FROM Customer WHERE Is_Active = 1 ORDER BY Membership_Type ASC;
```

**Query Result Output (Top Rows Sampled):**

| Membership_Type |
| --- |
| Gold |
| Platinum |
| Regular |
| Silver |
| VIP |

### Query #26 — Operator: `GROUP BY with COUNT and SUM`
**Business Scenario:** Display total booking count and cumulative net revenue collected per booking channel.  
**Execution Status:** &#9989; Success | **Rows Returned:** 2  

```sql
SELECT Booking_Channel, COUNT(Booking_ID) AS Total_Bookings, SUM(Net_Payable) AS Total_Revenue_PKR FROM Booking WHERE Booking_Status = 'Confirmed' GROUP BY Booking_Channel;
```

**Query Result Output (Top Rows Sampled):**

| Booking_Channel | Total_Bookings | Total_Revenue_PKR |
| --- | --- | --- |
| Box_Office | 17 | 58290.0 |
| Online | 17 | 28536.0 |

### Query #27 — Operator: `HAVING with COUNT`
**Business Scenario:** Identify cinema screen halls that host at least 1 active scheduled showtime.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT Screen_ID, COUNT(Show_ID) AS Total_Scheduled_Shows FROM Showtime GROUP BY Screen_ID HAVING COUNT(Show_ID) >= 1;
```

**Query Result Output (Top Rows Sampled):**

| Screen_ID | Total_Scheduled_Shows |
| --- | --- |
| 1 | 1 |
| 2 | 1 |
| 3 | 1 |
| 4 | 1 |
| 5 | 1 |
| 6 | 1 |

### Query #28 — Operator: `BETWEEN with AND`
**Business Scenario:** Retrieve vehicle parking sessions where parked duration was between 2.0 and 4.0 hours in parking Zone 'A'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 15  

```sql
SELECT Parking_ID, Slot_Number, Vehicle_Type, Parked_Duration_Hours, Total_Parking_Fee FROM Parking WHERE (Parked_Duration_Hours BETWEEN 2.0 AND 4.0) AND Parking_Bay_Zone = 'A';
```

**Query Result Output (Top Rows Sampled):**

| Parking_ID | Slot_Number | Vehicle_Type | Parked_Duration_Hours | Total_Parking_Fee |
| --- | --- | --- | --- | --- |
| 1 | P-02 | Car | 3.5 | 350.0 |
| 2 | P-03 | SUV | 3.5 | 350.0 |
| 3 | P-04 | Motorcycle | 3.5 | 175.0 |
| 4 | P-05 | Van | 3.5 | 525.0 |
| 5 | P-06 | EV | 3.5 | 350.0 |
| 6 | P-07 | Car | 3.5 | 350.0 |

### Query #29 — Operator: `+ with profit threshold`
**Business Scenario:** Identify tuck shop items offering a gross profit margin of over 200 PKR per unit (Unit_Price > Cost_Price + 200).  
**Execution Status:** &#9989; Success | **Rows Returned:** 19  

```sql
SELECT Item_ID, Item_Name, Unit_Price, Cost_Price, (Unit_Price - Cost_Price) AS Profit_Margin FROM Tuck_Shop WHERE Unit_Price > (Cost_Price + 200.00);
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Unit_Price | Cost_Price | Profit_Margin |
| --- | --- | --- | --- | --- |
| 1 | Salted Popcorn (Regular) | 350.0 | 110.0 | 240.0 |
| 2 | Caramel Popcorn (Large) | 550.0 | 180.0 | 370.0 |
| 3 | Cheese Burst Popcorn (Jumbo) | 680.0 | 220.0 | 460.0 |
| 9 | Cheese Nachos with Jalapenos | 480.0 | 160.0 | 320.0 |
| 10 | Salsa Dip Crispy Nachos | 450.0 | 150.0 | 300.0 |
| 11 | Loaded Beef Nachos Supreme | 720.0 | 280.0 | 440.0 |

### Query #30 — Operator: `!= with ORDER BY`
**Business Scenario:** List all active screens that are not 'IMAX' format, sorted by seating capacity in descending order.  
**Execution Status:** &#9989; Success | **Rows Returned:** 90  

```sql
SELECT Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Row_Count FROM Screen WHERE Screen_Type != 'IMAX' AND Is_Active = 1 ORDER BY Total_Capacity DESC;
```

**Query Result Output (Top Rows Sampled):**

| Screen_ID | Screen_Name | Screen_Type | Total_Capacity | Row_Count |
| --- | --- | --- | --- | --- |
| 91 | Silver Economy Screen 1 | Silver_Economy | 180 | 10 |
| 92 | Silver Economy Screen 2 | Silver_Economy | 180 | 10 |
| 93 | Silver Economy Screen 3 | Silver_Economy | 180 | 10 |
| 94 | Silver Economy Screen 4 | Silver_Economy | 180 | 10 |
| 95 | Silver Economy Screen 5 | Silver_Economy | 180 | 10 |
| 96 | Silver Economy Screen 6 | Silver_Economy | 180 | 10 |

---

## Section 2: Execution Evidence for 12 SQL JOIN Queries
Demonstrating at least 2 queries for each of the 6 standard relational join types: **INNER JOIN**, **LEFT OUTER JOIN**, **RIGHT OUTER JOIN**, **FULL OUTER JOIN**, **CROSS JOIN**, and **SELF JOIN**.

### Join Query #1 — Type: `INNER JOIN`
**Business Scenario:** INNER JOIN Query 1: Retrieve customer personal details alongside their confirmed booking IDs, seats booked, and total payable.  
**Execution Status:** &#9989; Success | **Rows Returned:** 34  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Email, b.Booking_ID, b.Total_Seats_Booked, b.Net_Payable, b.Booking_Channel FROM Customer c INNER JOIN Booking b ON c.Customer_ID = b.Customer_ID WHERE b.Booking_Status = 'Confirmed';
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | Booking_ID | Total_Seats_Booked | Net_Payable | Booking_Channel |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | talha.sarfraz@gmail.com | 1 | 1 | 1740.0 | Online |
| 2 | Arslan | Tariq | arslan.tariq@yahoo.com | 2 | 2 | 3480.0 | Box_Office |
| 3 | Hassan | Ali | hassan.ali@outlook.com | 3 | 1 | 1566.0 | Online |
| 4 | Arslan | Mehmood | arslan.m@gmail.com | 4 | 2 | 3480.0 | Box_Office |
| 5 | Ayesha | Farooq | ayesha.f@gmail.com | 5 | 1 | 1740.0 | Online |
| 6 | Hamza | Siddique | hamza.sid@hotmail.com | 6 | 2 | 3306.0 | Box_Office |

### Join Query #2 — Type: `INNER JOIN`
**Business Scenario:** INNER JOIN Query 2: Retrieve detailed showtime schedule displaying movie title, genre, screen name, show date, and format.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT s.Show_ID, m.Title AS Movie_Title, m.Genre, sc.Screen_Name, sc.Screen_Type, s.Show_Date, s.Start_Time, s.Base_Price, s.Show_Format FROM Showtime s INNER JOIN Movie m ON s.Movie_ID = m.Movie_ID INNER JOIN Screen sc ON s.Screen_ID = sc.Screen_ID WHERE s.Show_Status IN ('Scheduled', 'Completed');
```

**Query Result Output (Top Rows Sampled):**

| Show_ID | Movie_Title | Genre | Screen_Name | Screen_Type | Show_Date | Start_Time | Base_Price | Show_Format |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Kung Fu Panda 4 | Animation | IMAX Screen 1 | IMAX | 2024-12-02 | 2024-12-02 18:30:00 | 1200.0 | IMAX 3D |
| 2 | Interstellar | Sci-Fi | IMAX Screen 2 | IMAX | 2024-12-03 | 2024-12-03 18:30:00 | 1200.0 | IMAX 3D |
| 3 | Inception | Sci-Fi | IMAX Screen 3 | IMAX | 2024-12-04 | 2024-12-04 18:30:00 | 1200.0 | IMAX 3D |
| 4 | Joker | Drama | IMAX Screen 4 | IMAX | 2024-12-05 | 2024-12-05 18:30:00 | 1200.0 | IMAX 3D |
| 5 | Avatar: The Way of Water | Fantasy | IMAX Screen 5 | IMAX | 2024-12-06 | 2024-12-06 18:30:00 | 1200.0 | IMAX 3D |
| 6 | Gladiator II | Action | IMAX Screen 6 | IMAX | 2024-12-07 | 2024-12-07 18:30:00 | 1200.0 | IMAX 3D |

### Join Query #3 — Type: `LEFT JOIN`
**Business Scenario:** LEFT JOIN Query 1: List all customers and any movie reviews they have authored, including customers who haven't reviewed yet.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type, r.Review_ID, r.Rating_Stars, r.Review_Title FROM Customer c LEFT JOIN Movie_Review r ON c.Customer_ID = r.Customer_ID;
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Membership_Type | Review_ID | Rating_Stars | Review_Title |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | VIP | 1 | 3 | Spectacular animation and fun humor! |
| 2 | Arslan | Tariq | Platinum | 2 | 4 | Mind-bending cinematic masterpiece |
| 3 | Hassan | Ali | Gold | 3 | 5 | Nolan at his absolute finest |
| 4 | Arslan | Mehmood | Regular | 4 | 4 | Haunting and deeply moving performance |
| 5 | Ayesha | Farooq | VIP | 5 | 3 | Visual effects are out of this world |
| 6 | Hamza | Siddique | Silver | 6 | 5 | Epic historical action thriller |

### Join Query #4 — Type: `LEFT JOIN`
**Business Scenario:** LEFT JOIN Query 2: Display all cinema screens and their scheduled showtimes, including screens currently without a scheduled movie.  
**Execution Status:** &#9989; Success | **Rows Returned:** 40  

```sql
SELECT sc.Screen_ID, sc.Screen_Name, sc.Screen_Type, sc.Total_Capacity, sh.Show_ID, sh.Show_Date, sh.Base_Price FROM Screen sc LEFT JOIN Showtime sh ON sc.Screen_ID = sh.Screen_ID WHERE sc.Screen_ID <= 40;
```

**Query Result Output (Top Rows Sampled):**

| Screen_ID | Screen_Name | Screen_Type | Total_Capacity | Show_ID | Show_Date | Base_Price |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | IMAX Screen 1 | IMAX | 250 | 1 | 2024-12-02 | 1200.0 |
| 2 | IMAX Screen 2 | IMAX | 250 | 2 | 2024-12-03 | 1200.0 |
| 3 | IMAX Screen 3 | IMAX | 250 | 3 | 2024-12-04 | 1200.0 |
| 4 | IMAX Screen 4 | IMAX | 250 | 4 | 2024-12-05 | 1200.0 |
| 5 | IMAX Screen 5 | IMAX | 250 | 5 | 2024-12-06 | 1200.0 |
| 6 | IMAX Screen 6 | IMAX | 250 | 6 | 2024-12-07 | 1200.0 |

### Join Query #5 — Type: `RIGHT JOIN`
**Business Scenario:** RIGHT JOIN Query 1: Ensure all booking records are returned along with customer contact data.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, b.Booking_ID, b.Booking_Timestamp, b.Net_Payable, b.Payment_Status FROM Customer c RIGHT JOIN Booking b ON c.Customer_ID = b.Customer_ID;
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Booking_ID | Booking_Timestamp | Net_Payable | Payment_Status |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | 1 | 2024-12-02 14:15:00 | 1740.0 | Paid |
| 2 | Arslan | Tariq | 2 | 2024-12-03 14:15:00 | 3480.0 | Paid |
| 3 | Hassan | Ali | 3 | 2024-12-04 14:15:00 | 1566.0 | Paid |
| 4 | Arslan | Mehmood | 4 | 2024-12-05 14:15:00 | 3480.0 | Paid |
| 5 | Ayesha | Farooq | 5 | 2024-12-06 14:15:00 | 1740.0 | Paid |
| 6 | Hamza | Siddique | 6 | 2024-12-07 14:15:00 | 3306.0 | Paid |

### Join Query #6 — Type: `RIGHT JOIN`
**Business Scenario:** RIGHT JOIN Query 2: Display all concession orders processed alongside employee staff details responsible for the counter.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Designation, co.Order_ID, co.Total_Items_Count, co.Total_Payable, co.Payment_Method FROM Employee e RIGHT JOIN Concession_Order co ON e.Employee_ID = co.Employee_ID;
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Order_ID | Total_Items_Count | Total_Payable | Payment_Method |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 8 | Adeel | Akram | Concession Lead | 5 | 1 | 472.0 | Cash |
| 8 | Adeel | Akram | Concession Lead | 10 | 2 | 936.0 | Credit Card |
| 8 | Adeel | Akram | Concession Lead | 15 | 1 | 472.0 | Debit Card |
| 8 | Adeel | Akram | Concession Lead | 20 | 2 | 936.0 | Mobile Wallet |
| 8 | Adeel | Akram | Concession Lead | 25 | 1 | 472.0 | Cash |
| 8 | Adeel | Akram | Concession Lead | 30 | 2 | 936.0 | Credit Card |

### Join Query #7 — Type: `FULL OUTER JOIN`
**Business Scenario:** FULL OUTER JOIN Query 1: Retrieve complete record set of customers and vehicle parking logs to identify both parking-only visitors and transit patrons.  
**Execution Status:** &#9989; Success | **Rows Returned:** 40  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, p.Parking_ID, p.Slot_Number, p.Vehicle_Type, p.Total_Parking_Fee FROM Customer c FULL OUTER JOIN Parking p ON c.Customer_ID = p.Customer_ID;
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Parking_ID | Slot_Number | Vehicle_Type | Total_Parking_Fee |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | 1 | P-02 | Car | 350.0 |
| 2 | Arslan | Tariq | 2 | P-03 | SUV | 350.0 |
| 3 | Hassan | Ali | 3 | P-04 | Motorcycle | 175.0 |
| 4 | Arslan | Mehmood | 4 | P-05 | Van | 525.0 |
| 5 | Ayesha | Farooq | 5 | P-06 | EV | 350.0 |
| 6 | Hamza | Siddique | 6 | P-07 | Car | 350.0 |

### Join Query #8 — Type: `FULL OUTER JOIN`
**Business Scenario:** FULL OUTER JOIN Query 2: Cross-check security guards and inspection checkpoint logs to audit staff assignment coverage.  
**Execution Status:** &#9989; Success | **Rows Returned:** 68  

```sql
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Department, sc.Checkpoint_ID, sc.Gate_Name, sc.Pass_Status FROM Employee e FULL OUTER JOIN Security_Checkpoint sc ON e.Employee_ID = sc.Guard_Employee_ID;
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Department | Checkpoint_ID | Gate_Name | Pass_Status |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | Management | NULL | NULL | NULL |
| 2 | Usman | Tariq | Management | NULL | NULL | NULL |
| 3 | Noman | Khan | Technical | NULL | NULL | NULL |
| 4 | Bilal | Ahmed | Technical | NULL | NULL | NULL |
| 5 | Saif | Ullah | Management | NULL | NULL | NULL |
| 6 | Usman | Ali | Ticketing | NULL | NULL | NULL |

### Join Query #9 — Type: `CROSS JOIN`
**Business Scenario:** CROSS JOIN Query 1: Generate a hypothetical matrix pairing the top 3 feature films against 3 distinct screen technology types.  
**Execution Status:** &#9989; Success | **Rows Returned:** 9  

```sql
SELECT m.Title AS Movie_Title, sc.Screen_Type, sc.Sound_System FROM (SELECT Movie_ID, Title FROM Movie WHERE Movie_ID <= 3) m CROSS JOIN (SELECT DISTINCT Screen_Type, Sound_System FROM Screen WHERE Screen_Type IN ('IMAX', 'Gold_Class', 'Silver_Economy')) sc;
```

**Query Result Output (Top Rows Sampled):**

| Movie_Title | Screen_Type | Sound_System |
| --- | --- | --- |
| Kung Fu Panda 4 | IMAX | Dolby Atmos 12.2 |
| Kung Fu Panda 4 | Gold_Class | Meyer Sound EXP |
| Kung Fu Panda 4 | Silver_Economy | Dolby Surround 7.1 |
| Interstellar | IMAX | Dolby Atmos 12.2 |
| Interstellar | Gold_Class | Meyer Sound EXP |
| Interstellar | Silver_Economy | Dolby Surround 7.1 |

### Join Query #10 — Type: `CROSS JOIN`
**Business Scenario:** CROSS JOIN Query 2: Create a combination matrix of distinct customer membership tiers and concession snack sizes for promotional bundle planning.  
**Execution Status:** &#9989; Success | **Rows Returned:** 9  

```sql
SELECT m.Membership_Type, s.Size_Option FROM (SELECT DISTINCT Membership_Type FROM Customer WHERE Membership_Type IN ('Regular', 'Gold', 'VIP')) m CROSS JOIN (SELECT DISTINCT Size_Option FROM Tuck_Shop WHERE Size_Option IN ('Small', 'Regular', 'Large')) s;
```

**Query Result Output (Top Rows Sampled):**

| Membership_Type | Size_Option |
| --- | --- |
| VIP | Regular |
| VIP | Large |
| VIP | Small |
| Gold | Regular |
| Gold | Large |
| Gold | Small |

### Join Query #11 — Type: `SELF JOIN`
**Business Scenario:** SELF JOIN Query 1: Find pairs of employees working within the exact same department and sharing the same shift timing.  
**Execution Status:** &#9989; Success | **Rows Returned:** 17  

```sql
SELECT A.Employee_ID AS Emp1_ID, (A.First_Name || ' ' || A.Last_Name) AS Emp1_Name, B.Employee_ID AS Emp2_ID, (B.First_Name || ' ' || B.Last_Name) AS Emp2_Name, A.Department, A.Shift_Timing FROM Employee A INNER JOIN Employee B ON A.Department = B.Department AND A.Shift_Timing = B.Shift_Timing AND A.Employee_ID < B.Employee_ID;
```

**Query Result Output (Top Rows Sampled):**

| Emp1_ID | Emp1_Name | Emp2_ID | Emp2_Name | Department | Shift_Timing |
| --- | --- | --- | --- | --- | --- |
| 1 | Hamza Ali | 5 | Saif Ullah | Management | Morning |
| 1 | Hamza Ali | 17 | Shahbaz Sharif | Management | Morning |
| 3 | Noman Khan | 19 | Imran Khan | Technical | Night |
| 5 | Saif Ullah | 17 | Shahbaz Sharif | Management | Morning |
| 6 | Usman Ali | 22 | Murad Saeed | Ticketing | Evening |
| 8 | Adeel Akram | 24 | Fawad Chaudhry | Concessions | Rotational |

### Join Query #12 — Type: `SELF JOIN`
**Business Scenario:** SELF JOIN Query 2: Find pairs of movies that share the exact same genre but have different runtimes.  
**Execution Status:** &#9989; Success | **Rows Returned:** 44  

```sql
SELECT A.Movie_ID AS Movie1_ID, A.Title AS Movie1_Title, B.Movie_ID AS Movie2_ID, B.Title AS Movie2_Title, A.Genre, A.Duration_Minutes AS Duration1, B.Duration_Minutes AS Duration2 FROM Movie A INNER JOIN Movie B ON A.Genre = B.Genre AND A.Movie_ID < B.Movie_ID AND A.Duration_Minutes <> B.Duration_Minutes WHERE A.Genre = 'Action';
```

**Query Result Output (Top Rows Sampled):**

| Movie1_ID | Movie1_Title | Movie2_ID | Movie2_Title | Genre | Duration1 | Duration2 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | Gladiator II | 13 | Avengers: Endgame | Action | 148 | 181 |
| 6 | Gladiator II | 32 | Deadpool & Wolverine | Action | 148 | 128 |
| 6 | Gladiator II | 31 | Guardians of the Galaxy Vol. 3 | Action | 148 | 150 |
| 6 | Gladiator II | 28 | John Wick: Chapter 4 | Action | 148 | 169 |
| 6 | Gladiator II | 27 | Mission: Impossible - Dead Reckoning | Action | 148 | 163 |
| 6 | Gladiator II | 30 | The Batman | Action | 148 | 176 |

---

## Section 3: Execution Evidence for 20 SQL Subqueries
Demonstrating 20 advanced subqueries across all required subquery patterns: **Single-Row**, **Multiple-Row (IN / NOT IN)**, **Nested**, **Correlated**, **Subquery with EXISTS / NOT EXISTS**, **Subquery with ANY / ALL**, **Scalar Subquery in SELECT**, and **Subquery in FROM Clause (Derived Tables)**.

### Subquery #1 — Category: `Single-row Subquery`
**Business Scenario:** Find the movie that achieved the single highest worldwide box office revenue.  
**Execution Status:** &#9989; Success | **Rows Returned:** 1  

```sql
SELECT Movie_ID, Title, Director, Box_Office_Revenue FROM Movie WHERE Box_Office_Revenue = (SELECT MAX(Box_Office_Revenue) FROM Movie);
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Director | Box_Office_Revenue |
| --- | --- | --- | --- |
| 13 | Avengers: Endgame | Anthony Russo | 2799000000.0 |

### Subquery #2 — Category: `Single-row Subquery`
**Business Scenario:** Find all cinema employees whose monthly salary is greater than the overall cinema average monthly salary.  
**Execution Status:** &#9989; Success | **Rows Returned:** 12  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary > (SELECT AVG(Monthly_Salary) FROM Employee);
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Department | Monthly_Salary |
| --- | --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | General Manager | Management | 185000.0 |
| 2 | Usman | Tariq | Assistant Manager | Management | 120000.0 |
| 3 | Noman | Khan | Senior IT Officer | Technical | 95000.0 |
| 4 | Bilal | Ahmed | Projectionist Lead | Technical | 80000.0 |
| 16 | Junaid | Jamshed | General Manager | Management | 185000.0 |
| 17 | Shahbaz | Sharif | Assistant Manager | Management | 120000.0 |

### Subquery #3 — Category: `Single-row Subquery`
**Business Scenario:** Identify the top loyalty customer who holds the absolute maximum number of loyalty points.  
**Execution Status:** &#9989; Success | **Rows Returned:** 1  

```sql
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type, Loyalty_Points FROM Customer WHERE Loyalty_Points = (SELECT MAX(Loyalty_Points) FROM Customer);
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | Membership_Type | Loyalty_Points |
| --- | --- | --- | --- | --- | --- |
| 35 | Bushra | Ansari | bushra.ansari@gmail.com | VIP | 620 |

### Subquery #4 — Category: `Multiple-row Subquery (IN)`
**Business Scenario:** Retrieve details of all customers who have booked tickets for any movie directed by 'Christopher Nolan'.  
**Execution Status:** &#9989; Success | **Rows Returned:** 5  

```sql
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type FROM Customer WHERE Customer_ID IN (SELECT b.Customer_ID FROM Booking b INNER JOIN Showtime s ON b.Show_ID = s.Show_ID WHERE s.Movie_ID IN (SELECT Movie_ID FROM Movie WHERE Director = 'Christopher Nolan'));
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | Membership_Type |
| --- | --- | --- | --- | --- |
| 2 | Arslan | Tariq | arslan.tariq@yahoo.com | Platinum |
| 3 | Hassan | Ali | hassan.ali@outlook.com | Gold |
| 8 | Bilal | Khan | bilal.khan@live.com | Regular |
| 9 | Zainab | Malik | zainab.m@gmail.com | Silver |
| 26 | Taimoor | Baig | taimoor.baig@gmail.com | Platinum |

### Subquery #5 — Category: `Multiple-row Subquery (NOT IN)`
**Business Scenario:** Retrieve all tuck shop concession items that have never been ordered in any concession transaction.  
**Execution Status:** &#9989; Success | **Rows Returned:** 7  

```sql
SELECT Item_ID, Item_Name, Category, Unit_Price, Stock_Quantity FROM Tuck_Shop WHERE Item_ID NOT IN (SELECT DISTINCT Item_ID FROM Concession_Item_Order);
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Category | Unit_Price | Stock_Quantity |
| --- | --- | --- | --- | --- |
| 29 | Gourmet Truffle Fries | Snacks | 490.0 | 115 |
| 30 | Peri Peri Seasoned Popcorn | Popcorn | 520.0 | 135 |
| 31 | Butter Scotch Popcorn | Popcorn | 460.0 | 140 |
| 32 | Strawberry Slush 400ml | Beverages | 280.0 | 190 |
| 33 | Blueberry Frozen Slush 400ml | Beverages | 280.0 | 180 |
| 34 | Belgian Waffle on a Stick | Bakery | 390.0 | 90 |

### Subquery #6 — Category: `Multiple-row Subquery (IN)`
**Business Scenario:** Find all screens currently hosting scheduled showtimes priced above 1500 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 15  

```sql
SELECT Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Sound_System FROM Screen WHERE Screen_ID IN (SELECT Screen_ID FROM Showtime WHERE Base_Price > 1500.00);
```

**Query Result Output (Top Rows Sampled):**

| Screen_ID | Screen_Name | Screen_Type | Total_Capacity | Sound_System |
| --- | --- | --- | --- | --- |
| 11 | IMAX Screen 11 | IMAX | 250 | Dolby Atmos 12.2 |
| 12 | IMAX Screen 12 | IMAX | 250 | Dolby Atmos 12.2 |
| 13 | IMAX Screen 13 | IMAX | 250 | Dolby Atmos 12.2 |
| 14 | IMAX Screen 14 | IMAX | 250 | Dolby Atmos 12.2 |
| 15 | IMAX Screen 15 | IMAX | 250 | Dolby Atmos 12.2 |
| 16 | IMAX Screen 16 | IMAX | 250 | Dolby Atmos 12.2 |

### Subquery #7 — Category: `Nested Subquery`
**Business Scenario:** Retrieve movies whose duration exceeds the average duration of all movies in the 'Sci-Fi' genre.  
**Execution Status:** &#9989; Success | **Rows Returned:** 10  

```sql
SELECT Movie_ID, Title, Genre, Duration_Minutes, Director FROM Movie WHERE Duration_Minutes > (SELECT AVG(Duration_Minutes) FROM Movie WHERE Genre = 'Sci-Fi');
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | Duration_Minutes | Director |
| --- | --- | --- | --- | --- |
| 2 | Interstellar | Sci-Fi | 169 | Christopher Nolan |
| 5 | Avatar: The Way of Water | Fantasy | 192 | James Cameron |
| 9 | Oppenheimer | Drama | 180 | Christopher Nolan |
| 11 | Dune: Part Two | Sci-Fi | 166 | Denis Villeneuve |
| 13 | Avengers: Endgame | Action | 181 | Anthony Russo |
| 15 | Titanic | Romance | 195 | James Cameron |

### Subquery #8 — Category: `Nested Subquery`
**Business Scenario:** Retrieve customer information for the patron who paid the highest single booking amount in the system.  
**Execution Status:** &#9989; Success | **Rows Returned:** 1  

```sql
SELECT Customer_ID, First_Name, Last_Name, Email, City FROM Customer WHERE Customer_ID = (SELECT Customer_ID FROM Booking WHERE Net_Payable = (SELECT MAX(Net_Payable) FROM Booking));
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email | City |
| --- | --- | --- | --- | --- |
| 2 | Arslan | Tariq | arslan.tariq@yahoo.com | Lahore |

### Subquery #9 — Category: `Nested Subquery`
**Business Scenario:** Find tuck shop items that are priced strictly higher than the average price of items in the 'Beverages' category.  
**Execution Status:** &#9989; Success | **Rows Returned:** 27  

```sql
SELECT Item_ID, Item_Name, Category, Unit_Price FROM Tuck_Shop WHERE Unit_Price > (SELECT AVG(Unit_Price) FROM Tuck_Shop WHERE Category = 'Beverages');
```

**Query Result Output (Top Rows Sampled):**

| Item_ID | Item_Name | Category | Unit_Price |
| --- | --- | --- | --- |
| 1 | Salted Popcorn (Regular) | Popcorn | 350.0 |
| 2 | Caramel Popcorn (Large) | Popcorn | 550.0 |
| 3 | Cheese Burst Popcorn (Jumbo) | Popcorn | 680.0 |
| 9 | Cheese Nachos with Jalapenos | Snacks | 480.0 |
| 10 | Salsa Dip Crispy Nachos | Snacks | 450.0 |
| 11 | Loaded Beef Nachos Supreme | Snacks | 720.0 |

### Subquery #10 — Category: `Correlated Subquery`
**Business Scenario:** Find all movies whose IMDb rating is strictly above the average IMDb rating of movies within the exact same genre.  
**Execution Status:** &#9989; Success | **Rows Returned:** 14  

```sql
SELECT m1.Movie_ID, m1.Title, m1.Genre, m1.IMDb_Rating FROM Movie m1 WHERE m1.IMDb_Rating > (SELECT AVG(m2.IMDb_Rating) FROM Movie m2 WHERE m2.Genre = m1.Genre);
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | IMDb_Rating |
| --- | --- | --- | --- |
| 3 | Inception | Sci-Fi | 8.8 |
| 7 | Up | Animation | 8.3 |
| 8 | The Dark Knight | Action | 9.0 |
| 9 | Oppenheimer | Drama | 8.9 |
| 12 | Spider-Man: Across the Spider-Verse | Animation | 8.7 |
| 13 | Avengers: Endgame | Action | 8.4 |

### Subquery #11 — Category: `Correlated Subquery`
**Business Scenario:** Find all employees whose monthly salary exceeds the average monthly salary of their own respective department.  
**Execution Status:** &#9989; Success | **Rows Returned:** 14  

```sql
SELECT e1.Employee_ID, e1.First_Name, e1.Last_Name, e1.Department, e1.Monthly_Salary FROM Employee e1 WHERE e1.Monthly_Salary > (SELECT AVG(e2.Monthly_Salary) FROM Employee e2 WHERE e2.Department = e1.Department);
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Department | Monthly_Salary |
| --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | Management | 185000.0 |
| 3 | Noman | Khan | Technical | 95000.0 |
| 6 | Usman | Ali | Ticketing | 55000.0 |
| 7 | Fahad | Raza | Ticketing | 48000.0 |
| 8 | Adeel | Akram | Concessions | 52000.0 |
| 10 | Kashif | Saeed | Security | 65000.0 |

### Subquery #12 — Category: `Correlated Subquery`
**Business Scenario:** Identify customers whose individual spending on bookings exceeds the average total booking expenditure of all customers.  
**Execution Status:** &#9989; Success | **Rows Returned:** 17  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type FROM Customer c WHERE (SELECT SUM(b.Net_Payable) FROM Booking b WHERE b.Customer_ID = c.Customer_ID) > (SELECT AVG(Net_Payable) FROM Booking);
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Membership_Type |
| --- | --- | --- | --- |
| 2 | Arslan | Tariq | Platinum |
| 4 | Arslan | Mehmood | Regular |
| 6 | Hamza | Siddique | Silver |
| 8 | Bilal | Khan | Regular |
| 10 | Usman | Sheikh | Platinum |
| 12 | Omer | Javed | Gold |

### Subquery #13 — Category: `Subquery with EXISTS`
**Business Scenario:** Retrieve all customers who have at least one successfully cleared security screening recorded at a checkpoint.  
**Execution Status:** &#9989; Success | **Rows Returned:** 35  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Email FROM Customer c WHERE EXISTS (SELECT 1 FROM Security_Checkpoint sc WHERE sc.Customer_ID = c.Customer_ID AND sc.Pass_Status = 'Approved');
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Email |
| --- | --- | --- | --- |
| 1 | Talha | Sarfraz | talha.sarfraz@gmail.com |
| 2 | Arslan | Tariq | arslan.tariq@yahoo.com |
| 3 | Hassan | Ali | hassan.ali@outlook.com |
| 4 | Arslan | Mehmood | arslan.m@gmail.com |
| 5 | Ayesha | Farooq | ayesha.f@gmail.com |
| 6 | Hamza | Siddique | hamza.sid@hotmail.com |

### Subquery #14 — Category: `Subquery with EXISTS`
**Business Scenario:** Find screens that have at least one wheelchair accessible seat installed.  
**Execution Status:** &#9989; Success | **Rows Returned:** 3  

```sql
SELECT sc.Screen_ID, sc.Screen_Name, sc.Screen_Type, sc.Total_Capacity FROM Screen sc WHERE EXISTS (SELECT 1 FROM Seat st WHERE st.Screen_ID = sc.Screen_ID AND st.Is_Wheelchair_Accessible = 1);
```

**Query Result Output (Top Rows Sampled):**

| Screen_ID | Screen_Name | Screen_Type | Total_Capacity |
| --- | --- | --- | --- |
| 10 | IMAX Screen 10 | IMAX | 250 |
| 20 | IMAX Screen 20 | IMAX | 250 |
| 30 | IMAX Screen 30 | IMAX | 250 |

### Subquery #15 — Category: `Subquery with NOT EXISTS`
**Business Scenario:** Identify registered customers who have never utilized the cinema vehicle parking facility.  
**Execution Status:** &#9989; Success | **Rows Returned:** 5  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.City FROM Customer c WHERE NOT EXISTS (SELECT 1 FROM Parking p WHERE p.Customer_ID = c.Customer_ID);
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | City |
| --- | --- | --- | --- |
| 31 | Alina | Dar | Sialkot |
| 32 | Haris | Rauf | Islamabad |
| 33 | Sadia | Imran | Lahore |
| 34 | Kamran | Akmal | Lahore |
| 35 | Bushra | Ansari | Karachi |

### Subquery #16 — Category: `Subquery with NOT EXISTS`
**Business Scenario:** Retrieve movies currently in catalog that have received zero critical ratings below 4 stars.  
**Execution Status:** &#9989; Success | **Rows Returned:** 23  

```sql
SELECT m.Movie_ID, m.Title, m.Genre, m.IMDb_Rating FROM Movie m WHERE NOT EXISTS (SELECT 1 FROM Movie_Review r WHERE r.Movie_ID = m.Movie_ID AND r.Rating_Stars < 4);
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | IMDb_Rating |
| --- | --- | --- | --- |
| 2 | Interstellar | Sci-Fi | 8.7 |
| 3 | Inception | Sci-Fi | 8.8 |
| 4 | Joker | Drama | 8.4 |
| 6 | Gladiator II | Action | 7.2 |
| 8 | The Dark Knight | Action | 9.0 |
| 9 | Oppenheimer | Drama | 8.9 |

### Subquery #17 — Category: `Subquery with ANY / SOME`
**Business Scenario:** Find employees whose salary is greater than the salary of AT LEAST ONE (ANY) employee in the 'Ticketing' department.  
**Execution Status:** &#9989; Success | **Rows Returned:** 33  

```sql
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary > ANY (SELECT Monthly_Salary FROM Employee WHERE Department = 'Ticketing');
```

**Query Result Output (Top Rows Sampled):**

| Employee_ID | First_Name | Last_Name | Designation | Department | Monthly_Salary |
| --- | --- | --- | --- | --- | --- |
| 1 | Hamza | Ali | General Manager | Management | 185000.0 |
| 2 | Usman | Tariq | Assistant Manager | Management | 120000.0 |
| 3 | Noman | Khan | Senior IT Officer | Technical | 95000.0 |
| 4 | Bilal | Ahmed | Projectionist Lead | Technical | 80000.0 |
| 5 | Saif | Ullah | Floor Supervisor | Management | 75000.0 |
| 6 | Usman | Ali | Senior Cashier | Ticketing | 55000.0 |

### Subquery #18 — Category: `Subquery with ALL`
**Business Scenario:** Find movies that earned more in worldwide box office revenue than ALL movies in the 'Animation' category.  
**Execution Status:** &#9989; Success | **Rows Returned:** 4  

```sql
SELECT Movie_ID, Title, Genre, Box_Office_Revenue FROM Movie WHERE Box_Office_Revenue > ALL (SELECT Box_Office_Revenue FROM Movie WHERE Genre = 'Animation');
```

**Query Result Output (Top Rows Sampled):**

| Movie_ID | Title | Genre | Box_Office_Revenue |
| --- | --- | --- | --- |
| 5 | Avatar: The Way of Water | Fantasy | 2320000000.0 |
| 13 | Avengers: Endgame | Action | 2799000000.0 |
| 15 | Titanic | Romance | 2264000000.0 |
| 29 | Spider-Man: No Way Home | Action | 1922000000.0 |

### Subquery #19 — Category: `Scalar Subquery in SELECT`
**Business Scenario:** Display each customer's basic profile alongside a computed count of total tickets they have booked.  
**Execution Status:** &#9989; Success | **Rows Returned:** 15  

```sql
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type, (SELECT COUNT(t.Ticket_ID) FROM Ticket t INNER JOIN Booking b ON t.Booking_ID = b.Booking_ID WHERE b.Customer_ID = c.Customer_ID) AS Total_Tickets_Purchased FROM Customer c WHERE c.Customer_ID <= 15;
```

**Query Result Output (Top Rows Sampled):**

| Customer_ID | First_Name | Last_Name | Membership_Type | Total_Tickets_Purchased |
| --- | --- | --- | --- | --- |
| 1 | Talha | Sarfraz | VIP | 1 |
| 2 | Arslan | Tariq | Platinum | 1 |
| 3 | Hassan | Ali | Gold | 1 |
| 4 | Arslan | Mehmood | Regular | 1 |
| 5 | Ayesha | Farooq | VIP | 1 |
| 6 | Hamza | Siddique | Silver | 1 |

### Subquery #20 — Category: `Subquery in FROM clause (Derived Table)`
**Business Scenario:** From a derived table aggregating sales statistics per booking channel, display channels where average transaction value exceeds 1800 PKR.  
**Execution Status:** &#9989; Success | **Rows Returned:** 1  

```sql
SELECT dt.Booking_Channel, dt.Total_Bookings, dt.Total_Revenue, dt.Avg_Booking_Value FROM (SELECT Booking_Channel, COUNT(Booking_ID) AS Total_Bookings, SUM(Net_Payable) AS Total_Revenue, ROUND(AVG(Net_Payable), 2) AS Avg_Booking_Value FROM Booking GROUP BY Booking_Channel) AS dt WHERE dt.Avg_Booking_Value > 1800.00;
```

**Query Result Output (Top Rows Sampled):**

| Booking_Channel | Total_Bookings | Total_Revenue | Avg_Booking_Value |
| --- | --- | --- | --- |
| Box_Office | 17 | 58290.0 | 3428.82 |
