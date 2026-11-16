-- ==========================================================================
-- BSCS - DATABASE SYSTEMS TERM PROJECT
-- Project Title: Enhanced Cinema Management System (Full-Stack)
-- DBMS: Microsoft SQL Server (T-SQL)
-- Database Name: CinemaDB_Project
-- ==========================================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CinemaDB_Project')
BEGIN
    CREATE DATABASE [CinemaDB_Project];
END
GO

USE [CinemaDB_Project];
GO

-- ==========================================================================
-- 8.1 DATA DEFINITION LANGUAGE (DDL) - TABLE CREATION WITH CONSTRAINTS
-- Each entity strictly contains >= 10 attributes of diverse data types
-- (INT, VARCHAR, CHAR, DATE, DECIMAL, FLOAT, BIT, DATETIME)
-- Constraints: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT
-- ==========================================================================

-- -------------------------------------------------------------------------
-- Entity #1: Customer (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F', 'O')),
    Date_Of_Birth DATE NOT NULL,
    Membership_Type VARCHAR(30) NOT NULL DEFAULT 'Regular' CHECK (Membership_Type IN ('Regular', 'Silver', 'Gold', 'Platinum', 'VIP')),
    Registration_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Loyalty_Points INT NOT NULL DEFAULT 0 CHECK (Loyalty_Points >= 0),
    City VARCHAR(50) NOT NULL,
    Postal_Code VARCHAR(15) NOT NULL,
    Is_Active BIT NOT NULL DEFAULT 1
);
GO

-- -------------------------------------------------------------------------
-- Entity #1.1: Phone_Number (Multivalued attribute representation for Customer)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Phone_Number', 'U') IS NOT NULL DROP TABLE dbo.Phone_Number;
CREATE TABLE Phone_Number (
    Phone_Num VARCHAR(20) NOT NULL,
    Customer_ID INT NOT NULL,
    Phone_Type VARCHAR(20) NOT NULL DEFAULT 'Mobile' CHECK (Phone_Type IN ('Mobile', 'Home', 'Work')),
    Is_Primary BIT NOT NULL DEFAULT 1,
    Added_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    PRIMARY KEY (Phone_Num, Customer_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------------------
-- Entity #2: Movie (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Movie', 'U') IS NOT NULL DROP TABLE dbo.Movie;
CREATE TABLE Movie (
    Movie_ID INT PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    Duration_Minutes INT NOT NULL CHECK (Duration_Minutes > 0),
    Release_Date DATE NOT NULL,
    Language VARCHAR(50) NOT NULL,
    Director VARCHAR(100) NOT NULL,
    Age_Rating VARCHAR(10) NOT NULL CHECK (Age_Rating IN ('G', 'PG', 'PG-13', 'R', 'NC-17')),
    IMDb_Rating DECIMAL(3,1) NOT NULL CHECK (IMDb_Rating BETWEEN 0.0 AND 10.0),
    Production_Budget DECIMAL(14,2) NOT NULL CHECK (Production_Budget >= 0),
    Box_Office_Revenue DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    Status VARCHAR(20) NOT NULL DEFAULT 'Now Showing' CHECK (Status IN ('Coming Soon', 'Now Showing', 'Archived'))
);
GO

-- -------------------------------------------------------------------------
-- Entity #3: Screen (Superclass - 12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Screen', 'U') IS NOT NULL DROP TABLE dbo.Screen;
CREATE TABLE Screen (
    Screen_ID INT PRIMARY KEY,
    Screen_Name VARCHAR(50) NOT NULL UNIQUE,
    Screen_Type VARCHAR(30) NOT NULL CHECK (Screen_Type IN ('IMAX', 'Gold_Class', 'Premium_VIP', 'Silver_Economy')),
    Total_Capacity INT NOT NULL CHECK (Total_Capacity > 0),
    Row_Count INT NOT NULL CHECK (Row_Count > 0),
    Seats_Per_Row INT NOT NULL CHECK (Seats_Per_Row > 0),
    Sound_System VARCHAR(50) NOT NULL DEFAULT 'Dolby Atmos 7.1',
    Projector_Model VARCHAR(80) NOT NULL,
    Screen_Width_Feet FLOAT NOT NULL CHECK (Screen_Width_Feet > 0),
    Screen_Height_Feet FLOAT NOT NULL CHECK (Screen_Height_Feet > 0),
    Cleaning_Status VARCHAR(30) NOT NULL DEFAULT 'Clean' CHECK (Cleaning_Status IN ('Clean', 'Cleaning In Progress', 'Needs Inspection')),
    Is_Active BIT NOT NULL DEFAULT 1
);
GO

-- -------------------------------------------------------------------------
-- EER Subclass #1: IMAXScreen (Inherits Screen)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.IMAXScreen', 'U') IS NOT NULL DROP TABLE dbo.IMAXScreen;
CREATE TABLE IMAXScreen (
    Screen_ID INT PRIMARY KEY,
    Laser_Projection_Type VARCHAR(50) NOT NULL,
    Aspect_Ratio VARCHAR(20) NOT NULL DEFAULT '1.43:1',
    Dual_Laser_3D BIT NOT NULL DEFAULT 1,
    Curved_Angle_Degrees FLOAT NOT NULL CHECK (Curved_Angle_Degrees > 0),
    Commercial_License_Code VARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID) ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------------------
-- EER Subclass #2: GoldScreen (Inherits Screen)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.GoldScreen', 'U') IS NOT NULL DROP TABLE dbo.GoldScreen;
CREATE TABLE GoldScreen (
    Screen_ID INT PRIMARY KEY,
    Lounge_Service_Type VARCHAR(50) NOT NULL,
    Recliner_Model VARCHAR(50) NOT NULL,
    Butler_Service_Enabled BIT NOT NULL DEFAULT 1,
    Complimentary_Snack_Tier VARCHAR(30) NOT NULL DEFAULT 'Premium Combo',
    Call_Button_Active BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID) ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------------------
-- EER Subclass #3: PremiumScreen (Inherits Screen)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.PremiumScreen', 'U') IS NOT NULL DROP TABLE dbo.PremiumScreen;
CREATE TABLE PremiumScreen (
    Screen_ID INT PRIMARY KEY,
    Luxury_Level VARCHAR(50) NOT NULL,
    Private_Balcony_Seats INT NOT NULL DEFAULT 20,
    Wine_Bar_Access BIT NOT NULL DEFAULT 0,
    VIP_Restroom_Access BIT NOT NULL DEFAULT 1,
    Heated_Seats BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID) ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------------------
-- EER Subclass #4: SilverScreen (Inherits Screen)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.SilverScreen', 'U') IS NOT NULL DROP TABLE dbo.SilverScreen;
CREATE TABLE SilverScreen (
    Screen_ID INT PRIMARY KEY,
    Discount_Tier_Percent INT NOT NULL DEFAULT 15 CHECK (Discount_Tier_Percent >= 0),
    Economy_Bundle_Eligible BIT NOT NULL DEFAULT 1,
    Student_Pass_Accepted BIT NOT NULL DEFAULT 1,
    Group_Discount_Active BIT NOT NULL DEFAULT 1,
    Free_Refill_Eligible BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID) ON DELETE CASCADE
);
GO

-- -------------------------------------------------------------------------
-- Entity #4: Showtime (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Showtime', 'U') IS NOT NULL DROP TABLE dbo.Showtime;
CREATE TABLE Showtime (
    Show_ID INT PRIMARY KEY,
    Movie_ID INT NOT NULL,
    Screen_ID INT NOT NULL,
    Show_Date DATE NOT NULL,
    Start_Time DATETIME NOT NULL,
    End_Time DATETIME NOT NULL,
    Base_Price DECIMAL(8,2) NOT NULL CHECK (Base_Price > 0),
    Show_Format VARCHAR(20) NOT NULL CHECK (Show_Format IN ('2D', '3D', 'IMAX 2D', 'IMAX 3D', '4DX')),
    Available_Seats INT NOT NULL CHECK (Available_Seats >= 0),
    Audio_Language VARCHAR(30) NOT NULL,
    Subtitle_Language VARCHAR(30) NOT NULL DEFAULT 'English',
    Show_Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' CHECK (Show_Status IN ('Scheduled', 'Selling Fast', 'Housefull', 'Completed', 'Cancelled')),
    FOREIGN KEY (Movie_ID) REFERENCES Movie(Movie_ID),
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #5: Seat (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Seat', 'U') IS NOT NULL DROP TABLE dbo.Seat;
CREATE TABLE Seat (
    Seat_ID INT PRIMARY KEY,
    Screen_ID INT NOT NULL,
    Row_Letter CHAR(1) NOT NULL,
    Seat_Number INT NOT NULL CHECK (Seat_Number > 0),
    Seat_Code VARCHAR(10) NOT NULL,
    Seat_Class VARCHAR(30) NOT NULL DEFAULT 'Standard' CHECK (Seat_Class IN ('Standard', 'VIP', 'Recliner', 'Couple', 'Wheelchair')),
    Price_Multiplier DECIMAL(3,2) NOT NULL DEFAULT 1.00 CHECK (Price_Multiplier >= 1.00),
    Is_Wheelchair_Accessible BIT NOT NULL DEFAULT 0,
    Is_Reserved BIT NOT NULL DEFAULT 0,
    Maintenance_Status VARCHAR(30) NOT NULL DEFAULT 'Operational' CHECK (Maintenance_Status IN ('Operational', 'Under Maintenance', 'Damaged')),
    Vibration_Supported BIT NOT NULL DEFAULT 0,
    Seat_Color VARCHAR(30) NOT NULL DEFAULT 'Burgundy',
    FOREIGN KEY (Screen_ID) REFERENCES Screen(Screen_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #6: Booking (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Booking', 'U') IS NOT NULL DROP TABLE dbo.Booking;
CREATE TABLE Booking (
    Booking_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Show_ID INT NOT NULL,
    Booking_Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    Total_Seats_Booked INT NOT NULL CHECK (Total_Seats_Booked > 0),
    Total_Amount DECIMAL(10,2) NOT NULL CHECK (Total_Amount >= 0),
    Discount_Amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (Discount_Amount >= 0),
    Tax_Amount DECIMAL(10,2) NOT NULL CHECK (Tax_Amount >= 0),
    Net_Payable DECIMAL(10,2) NOT NULL CHECK (Net_Payable >= 0),
    Booking_Status VARCHAR(30) NOT NULL DEFAULT 'Confirmed' CHECK (Booking_Status IN ('Confirmed', 'Cancelled', 'Pending', 'Completed')),
    Payment_Status VARCHAR(30) NOT NULL DEFAULT 'Paid' CHECK (Payment_Status IN ('Paid', 'Pending', 'Refunded', 'Failed')),
    Booking_Channel VARCHAR(30) NOT NULL DEFAULT 'Online' CHECK (Booking_Channel IN ('Online', 'Box_Office', 'Mobile_App', 'Kiosk')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Show_ID) REFERENCES Showtime(Show_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #7: Ticket (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Ticket', 'U') IS NOT NULL DROP TABLE dbo.Ticket;
CREATE TABLE Ticket (
    Ticket_ID INT PRIMARY KEY,
    Booking_ID INT NOT NULL,
    Seat_ID INT NOT NULL,
    Ticket_Number VARCHAR(50) NOT NULL UNIQUE,
    Barcode_Number VARCHAR(60) NOT NULL UNIQUE,
    Ticket_Type VARCHAR(30) NOT NULL DEFAULT 'Adult' CHECK (Ticket_Type IN ('Adult', 'Child', 'Senior', 'Student', 'VIP')),
    Base_Price DECIMAL(8,2) NOT NULL CHECK (Base_Price > 0),
    Final_Price DECIMAL(8,2) NOT NULL CHECK (Final_Price > 0),
    Is_Validated BIT NOT NULL DEFAULT 0,
    Validation_Time DATETIME NULL,
    Checkin_Gate VARCHAR(30) NOT NULL DEFAULT 'Gate 1',
    Print_Count INT NOT NULL DEFAULT 1 CHECK (Print_Count >= 0),
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID),
    FOREIGN KEY (Seat_ID) REFERENCES Seat(Seat_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #8: Employee (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    CNIC VARCHAR(20) NOT NULL UNIQUE,
    Designation VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL CHECK (Department IN ('Management', 'Ticketing', 'Concessions', 'Technical', 'Security', 'Janitorial')),
    Monthly_Salary DECIMAL(10,2) NOT NULL CHECK (Monthly_Salary > 0),
    Shift_Timing VARCHAR(30) NOT NULL CHECK (Shift_Timing IN ('Morning', 'Evening', 'Night', 'Rotational')),
    Hire_Date DATE NOT NULL,
    Emergency_Contact VARCHAR(20) NOT NULL,
    Performance_Rating FLOAT NOT NULL DEFAULT 3.0 CHECK (Performance_Rating BETWEEN 1.0 AND 5.0),
    Employment_Status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (Employment_Status IN ('Active', 'On Leave', 'Resigned', 'Terminated'))
);
GO

-- -------------------------------------------------------------------------
-- Entity #9: Tuck_Shop (Concession Items - 12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Tuck_Shop', 'U') IS NOT NULL DROP TABLE dbo.Tuck_Shop;
CREATE TABLE Tuck_Shop (
    Item_ID INT PRIMARY KEY,
    Item_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL CHECK (Category IN ('Popcorn', 'Beverages', 'Snacks', 'Bakery', 'Combos', 'Candy')),
    Size_Option VARCHAR(20) NOT NULL DEFAULT 'Regular' CHECK (Size_Option IN ('Small', 'Regular', 'Large', 'Jumbo', 'Standard')),
    Unit_Price DECIMAL(8,2) NOT NULL CHECK (Unit_Price > 0),
    Cost_Price DECIMAL(8,2) NOT NULL CHECK (Cost_Price > 0),
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Reorder_Level INT NOT NULL DEFAULT 20 CHECK (Reorder_Level >= 0),
    Supplier_Name VARCHAR(100) NOT NULL,
    Calories_Kcal INT NOT NULL DEFAULT 250 CHECK (Calories_Kcal >= 0),
    Is_Available BIT NOT NULL DEFAULT 1,
    Expiry_Date DATE NOT NULL
);
GO

-- -------------------------------------------------------------------------
-- Entity #10: Concession_Order (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Concession_Order', 'U') IS NOT NULL DROP TABLE dbo.Concession_Order;
CREATE TABLE Concession_Order (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NULL,
    Employee_ID INT NOT NULL,
    Order_Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    Total_Items_Count INT NOT NULL CHECK (Total_Items_Count > 0),
    Subtotal_Amount DECIMAL(10,2) NOT NULL CHECK (Subtotal_Amount >= 0),
    Sales_Tax DECIMAL(10,2) NOT NULL CHECK (Sales_Tax >= 0),
    Discount_Given DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (Discount_Given >= 0),
    Total_Payable DECIMAL(10,2) NOT NULL CHECK (Total_Payable >= 0),
    Payment_Method VARCHAR(30) NOT NULL DEFAULT 'Cash' CHECK (Payment_Method IN ('Cash', 'Credit Card', 'Debit Card', 'Mobile Wallet')),
    Counter_Number INT NOT NULL DEFAULT 1 CHECK (Counter_Number > 0),
    Order_Status VARCHAR(20) NOT NULL DEFAULT 'Completed' CHECK (Order_Status IN ('Completed', 'Pending', 'Cancelled', 'Refunded')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #10.1: Concession_Item_Order (Associative Entity for Concessions)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Concession_Item_Order', 'U') IS NOT NULL DROP TABLE dbo.Concession_Item_Order;
CREATE TABLE Concession_Item_Order (
    Order_ID INT NOT NULL,
    Item_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price_Charged DECIMAL(8,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    Notes VARCHAR(100) NULL,
    PRIMARY KEY (Order_ID, Item_ID),
    FOREIGN KEY (Order_ID) REFERENCES Concession_Order(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Item_ID) REFERENCES Tuck_Shop(Item_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #11: Parking (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Parking', 'U') IS NOT NULL DROP TABLE dbo.Parking;
CREATE TABLE Parking (
    Parking_ID INT PRIMARY KEY,
    Customer_ID INT NULL,
    Slot_Number VARCHAR(20) NOT NULL,
    Vehicle_Type VARCHAR(30) NOT NULL CHECK (Vehicle_Type IN ('Car', 'Motorcycle', 'SUV', 'Van', 'EV')),
    License_Plate VARCHAR(25) NOT NULL,
    Entry_Time DATETIME NOT NULL,
    Exit_Time DATETIME NULL,
    Parked_Duration_Hours FLOAT NOT NULL DEFAULT 1.0 CHECK (Parked_Duration_Hours >= 0),
    Hourly_Rate DECIMAL(6,2) NOT NULL CHECK (Hourly_Rate >= 0),
    Total_Parking_Fee DECIMAL(8,2) NOT NULL CHECK (Total_Parking_Fee >= 0),
    Parking_Bay_Zone CHAR(1) NOT NULL DEFAULT 'A' CHECK (Parking_Bay_Zone IN ('A', 'B', 'C', 'D')),
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Paid' CHECK (Payment_Status IN ('Paid', 'Pending', 'Waived')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #12: Security_Checkpoint (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Security_Checkpoint', 'U') IS NOT NULL DROP TABLE dbo.Security_Checkpoint;
CREATE TABLE Security_Checkpoint (
    Checkpoint_ID INT PRIMARY KEY,
    Gate_Name VARCHAR(50) NOT NULL,
    Guard_Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Ticket_ID INT NOT NULL,
    Inspection_Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    Luggage_Scanned BIT NOT NULL DEFAULT 1,
    Metal_Detector_Cleared BIT NOT NULL DEFAULT 1,
    Pass_Status VARCHAR(20) NOT NULL DEFAULT 'Approved' CHECK (Pass_Status IN ('Approved', 'Denied', 'Flagged')),
    Supervisor_Notified BIT NOT NULL DEFAULT 0,
    Remarks VARCHAR(150) NOT NULL DEFAULT 'Normal Screening',
    Scanner_Device_ID VARCHAR(30) NOT NULL DEFAULT 'SCN-01',
    FOREIGN KEY (Guard_Employee_ID) REFERENCES Employee(Employee_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Ticket_ID) REFERENCES Ticket(Ticket_ID)
);
GO

-- -------------------------------------------------------------------------
-- Entity #13: Movie_Review (12 Attributes)
-- -------------------------------------------------------------------------
IF OBJECT_ID('dbo.Movie_Review', 'U') IS NOT NULL DROP TABLE dbo.Movie_Review;
CREATE TABLE Movie_Review (
    Review_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Movie_ID INT NOT NULL,
    Rating_Stars INT NOT NULL CHECK (Rating_Stars BETWEEN 1 AND 5),
    Review_Title VARCHAR(100) NOT NULL,
    Review_Text VARCHAR(500) NOT NULL,
    Review_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Helpful_Votes INT NOT NULL DEFAULT 0 CHECK (Helpful_Votes >= 0),
    Is_Verified_Watcher BIT NOT NULL DEFAULT 1,
    Sentiment_Tag VARCHAR(30) NOT NULL DEFAULT 'Positive' CHECK (Sentiment_Tag IN ('Positive', 'Neutral', 'Negative')),
    Platform_Used VARCHAR(30) NOT NULL DEFAULT 'Web Portal' CHECK (Platform_Used IN ('Web Portal', 'Mobile App', 'Kiosk')),
    Moderation_Status VARCHAR(20) NOT NULL DEFAULT 'Approved' CHECK (Moderation_Status IN ('Approved', 'Pending', 'Rejected')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movie(Movie_ID)
);
GO

-- ==========================================================================")
-- 8.1.C ALTER OPERATIONS DEMONSTRATION ON AT LEAST 5 DIFFERENT TABLES
-- Demonstrating ADD COLUMN, DROP COLUMN, RENAME COLUMN, MODIFY/ALTER DATA TYPE
-- ==========================================================================")

-- Table 1 (Customer): ADD COLUMN
ALTER TABLE Customer ADD Middle_Name VARCHAR(50) NULL;
GO

-- Table 2 (Movie): MODIFY / ALTER DATA TYPE
ALTER TABLE Movie ALTER COLUMN Title VARCHAR(200) NOT NULL;
GO

-- Table 3 (Tuck_Shop): ADD COLUMN and then DROP COLUMN
ALTER TABLE Tuck_Shop ADD Promotional_Tag VARCHAR(50) NULL;
GO
ALTER TABLE Tuck_Shop DROP COLUMN Promotional_Tag;
GO

-- Table 4 (Employee): RENAME COLUMN (using sp_rename in SQL Server)
EXEC sp_rename 'Employee.Emergency_Contact', 'Primary_Contact', 'COLUMN';
GO
-- Revert rename back to ensure downstream code consistency
EXEC sp_rename 'Employee.Primary_Contact', 'Emergency_Contact', 'COLUMN';
GO

-- Table 5 (Parking): ADD COLUMN and ALTER DATA TYPE
ALTER TABLE Parking ADD Notes VARCHAR(50) NULL;
GO
ALTER TABLE Parking ALTER COLUMN Notes VARCHAR(150) NULL;
GO
ALTER TABLE Parking DROP COLUMN Notes;
GO

-- ==========================================================================")
-- 8.1.D DROP DEMONSTRATION
-- Showing safe table creation and removal of a temporary audit table
-- ==========================================================================")
CREATE TABLE System_Audit_Temp (
    Audit_ID INT PRIMARY KEY,
    Audit_Action VARCHAR(100) NOT NULL,
    Action_Timestamp DATETIME DEFAULT GETDATE(),
    Performed_By VARCHAR(50) NOT NULL
);
GO

-- Effect: Removes table metadata and deallocates data pages permanently
DROP TABLE System_Audit_Temp;
GO


-- ==========================================================================
-- SECTION 8.2 - DATA MANIPULATION LANGUAGE (DML) - INSERT OPERATIONS
-- Enforcing requirement: At least 30 tuples inserted per relation/table
-- Realistic, coherent data with referential integrity maintained
-- ==========================================================================

-- -------------------------------------------------------------------------
-- Data Ingestion: Customer (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Customer (Customer_ID, First_Name, Last_Name, Email, Gender, Date_Of_Birth, Membership_Type, Registration_Date, Loyalty_Points, City, Postal_Code, Is_Active) VALUES
(1, 'Talha', 'Sarfraz', 'talha.sarfraz@gmail.com', 'M', '2001-05-14', 'VIP', '2023-01-10', 450, 'Lahore', '54000', 1),
(2, 'Arslan', 'Tariq', 'arslan.tariq@yahoo.com', 'M', '1999-11-23', 'Platinum', '2023-01-15', 380, 'Lahore', '54600', 1),
(3, 'Hassan', 'Ali', 'hassan.ali@outlook.com', 'M', '2000-03-19', 'Gold', '2023-02-01', 290, 'Karachi', '74200', 1),
(4, 'Arslan', 'Mehmood', 'arslan.m@gmail.com', 'M', '1998-08-30', 'Regular', '2023-02-12', 120, 'Islamabad', '44000', 1),
(5, 'Ayesha', 'Farooq', 'ayesha.f@gmail.com', 'F', '2002-12-05', 'VIP', '2023-02-20', 510, 'Lahore', '54770', 1),
(6, 'Hamza', 'Siddique', 'hamza.sid@hotmail.com', 'M', '1997-04-16', 'Silver', '2023-03-01', 210, 'Faisalabad', '38000', 1),
(7, 'Sara', 'Naveed', 'sara.naveed@gmail.com', 'F', '2001-09-28', 'Gold', '2023-03-10', 330, 'Rawalpindi', '46000', 1),
(8, 'Bilal', 'Khan', 'bilal.khan@live.com', 'M', '1996-01-12', 'Regular', '2023-03-15', 80, 'Multan', '60000', 1),
(9, 'Zainab', 'Malik', 'zainab.m@gmail.com', 'F', '2003-07-22', 'Silver', '2023-03-25', 190, 'Lahore', '54000', 1),
(10, 'Usman', 'Sheikh', 'usman.sh@gmail.com', 'M', '1995-10-18', 'Platinum', '2023-04-02', 420, 'Gujranwala', '52250', 1),
(11, 'Fatima', 'Noor', 'fatima.noor@gmail.com', 'F', '2000-02-14', 'Regular', '2023-04-10', 95, 'Sialkot', '51310', 1),
(12, 'Omer', 'Javed', 'omer.javed@yahoo.com', 'M', '1998-06-25', 'Gold', '2023-04-18', 310, 'Lahore', '54810', 1),
(13, 'Mariam', 'Raza', 'mariam.raza@gmail.com', 'F', '2002-04-09', 'VIP', '2023-05-01', 600, 'Islamabad', '44000', 1),
(14, 'Saad', 'Munir', 'saad.munir@outlook.com', 'M', '1994-12-30', 'Regular', '2023-05-10', 110, 'Peshawar', '25000', 1),
(15, 'Hina', 'Altaf', 'hina.altaf@gmail.com', 'F', '1999-03-11', 'Silver', '2023-05-20', 240, 'Lahore', '54000', 1),
(16, 'Ali', 'Rehman', 'ali.rehman@gmail.com', 'M', '2001-10-04', 'Gold', '2023-06-01', 340, 'Karachi', '75300', 1),
(17, 'Khadija', 'Bibi', 'khadija.b@yahoo.com', 'F', '1997-08-15', 'Regular', '2023-06-15', 70, 'Quetta', '87300', 1),
(18, 'Zubair', 'Shah', 'zubair.shah@gmail.com', 'M', '1993-05-21', 'Platinum', '2023-06-25', 470, 'Lahore', '54600', 1),
(19, 'Sana', 'Iqbal', 'sana.iqbal@hotmail.com', 'F', '2002-01-30', 'Silver', '2023-07-05', 180, 'Hyderabad', '71000', 1),
(20, 'Waqas', 'Afzal', 'waqas.afzal@gmail.com', 'M', '1996-11-09', 'Regular', '2023-07-12', 130, 'Gujrat', '50700', 1),
(21, 'Nimra', 'Khalid', 'nimra.khalid@gmail.com', 'F', '2000-09-17', 'VIP', '2023-07-22', 530, 'Islamabad', '44000', 1),
(22, 'Asad', 'Virk', 'asad.virk@yahoo.com', 'M', '1995-07-08', 'Gold', '2023-08-01', 320, 'Sheikhupura', '39350', 1),
(23, 'Mahnoor', 'Cheema', 'mahnoor.c@gmail.com', 'F', '2001-11-19', 'Silver', '2023-08-15', 225, 'Lahore', '54700', 1),
(24, 'Farhan', 'Qureshi', 'farhan.q@outlook.com', 'M', '1998-03-27', 'Regular', '2023-08-25', 60, 'Sargodha', '40100', 1),
(25, 'Rida', 'Fatima', 'rida.fatima@gmail.com', 'F', '2003-05-14', 'Gold', '2023-09-02', 360, 'Lahore', '54000', 1),
(26, 'Taimoor', 'Baig', 'taimoor.baig@gmail.com', 'M', '1992-09-03', 'Platinum', '2023-09-12', 490, 'Rawalpindi', '46000', 1),
(27, 'Mehak', 'Aziz', 'mehak.aziz@hotmail.com', 'F', '1999-06-16', 'Silver', '2023-09-20', 175, 'Bahawalpur', '63100', 1),
(28, 'Shahid', 'Afridi', 'shahid.a@live.com', 'M', '1994-02-28', 'VIP', '2023-10-01', 580, 'Peshawar', '25000', 1),
(29, 'Iqra', 'Yousaf', 'iqra.y@gmail.com', 'F', '2002-08-08', 'Regular', '2023-10-10', 105, 'Kasur', '55050', 1),
(30, 'Noman', 'Bashir', 'noman.bashir@yahoo.com', 'M', '1997-12-14', 'Gold', '2023-10-20', 305, 'Lahore', '54660', 1),
(31, 'Alina', 'Dar', 'alina.dar@gmail.com', 'F', '2001-03-03', 'Silver', '2023-11-01', 215, 'Sialkot', '51310', 1),
(32, 'Haris', 'Rauf', 'haris.rauf@gmail.com', 'M', '1996-05-18', 'Platinum', '2023-11-15', 440, 'Islamabad', '44000', 1),
(33, 'Sadia', 'Imran', 'sadia.imran@outlook.com', 'F', '1998-10-22', 'Regular', '2023-11-25', 90, 'Lahore', '54000', 1),
(34, 'Kamran', 'Akmal', 'kamran.akmal@gmail.com', 'M', '1993-01-07', 'Gold', '2023-12-05', 335, 'Lahore', '54500', 1),
(35, 'Bushra', 'Ansari', 'bushra.ansari@gmail.com', 'F', '2000-07-11', 'VIP', '2023-12-18', 620, 'Karachi', '74000', 1);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Phone_Number (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Phone_Number (Phone_Num, Customer_ID, Phone_Type, Is_Primary, Added_Date) VALUES
('0346-7665411', 1, 'Mobile', 1, '2023-01-10'),
('0300-8798234', 2, 'Mobile', 1, '2023-01-15'),
('0301-1111111', 3, 'Mobile', 1, '2023-02-01'),
('0302-2222222', 4, 'Mobile', 1, '2023-02-12'),
('0303-3333333', 5, 'Mobile', 1, '2023-02-20'),
('0304-4444444', 6, 'Mobile', 1, '2023-03-01'),
('0305-5555555', 7, 'Mobile', 1, '2023-03-10'),
('0306-6666666', 8, 'Mobile', 1, '2023-03-15'),
('0307-7777777', 9, 'Mobile', 1, '2023-03-25'),
('0308-8888888', 10, 'Mobile', 1, '2023-04-02'),
('0309-9999999', 11, 'Mobile', 1, '2023-04-10'),
('0310-0000001', 12, 'Mobile', 1, '2023-04-18'),
('0311-1111112', 13, 'Mobile', 1, '2023-05-01'),
('0312-2222223', 14, 'Mobile', 1, '2023-05-10'),
('0313-3333334', 15, 'Mobile', 1, '2023-05-20'),
('0314-4444445', 16, 'Mobile', 1, '2023-06-01'),
('0315-5555556', 17, 'Mobile', 1, '2023-06-15'),
('0316-6666667', 18, 'Mobile', 1, '2023-06-25'),
('0317-7777778', 19, 'Mobile', 1, '2023-07-05'),
('0318-8888889', 20, 'Mobile', 1, '2023-07-12'),
('0321-1234567', 21, 'Mobile', 1, '2023-07-22'),
('0322-2345678', 22, 'Mobile', 1, '2023-08-01'),
('0323-3456789', 23, 'Mobile', 1, '2023-08-15'),
('0324-4567890', 24, 'Mobile', 1, '2023-08-25'),
('0325-5678901', 25, 'Mobile', 1, '2023-09-02'),
('0331-6789012', 26, 'Mobile', 1, '2023-09-12'),
('0332-7890123', 27, 'Mobile', 1, '2023-09-20'),
('0333-8901234', 28, 'Mobile', 1, '2023-10-01'),
('0334-9012345', 29, 'Mobile', 1, '2023-10-10'),
('0335-0123456', 30, 'Mobile', 1, '2023-10-20'),
('0341-1122334', 31, 'Mobile', 1, '2023-11-01'),
('0342-2233445', 32, 'Mobile', 1, '2023-11-15'),
('0343-3344556', 33, 'Mobile', 1, '2023-11-25'),
('0344-4455667', 34, 'Mobile', 1, '2023-12-05'),
('0345-5566778', 35, 'Mobile', 1, '2023-12-18');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Movie (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Movie (Movie_ID, Title, Genre, Duration_Minutes, Release_Date, Language, Director, Age_Rating, IMDb_Rating, Production_Budget, Box_Office_Revenue, Status) VALUES
(1, 'Kung Fu Panda 4', 'Animation', 94, '2024-03-08', 'English', 'Mike Mitchell', 'PG', 6.7, 85000000.0, 545000000.0, 'Now Showing'),
(2, 'Interstellar', 'Sci-Fi', 169, '2014-11-07', 'English', 'Christopher Nolan', 'PG-13', 8.7, 165000000.0, 773000000.0, 'Archived'),
(3, 'Inception', 'Sci-Fi', 148, '2010-07-16', 'English', 'Christopher Nolan', 'PG-13', 8.8, 160000000.0, 836800000.0, 'Archived'),
(4, 'Joker', 'Drama', 122, '2019-10-04', 'English', 'Todd Phillips', 'R', 8.4, 55000000.0, 1074000000.0, 'Archived'),
(5, 'Avatar: The Way of Water', 'Fantasy', 192, '2022-12-16', 'English', 'James Cameron', 'PG-13', 7.6, 350000000.0, 2320000000.0, 'Archived'),
(6, 'Gladiator II', 'Action', 148, '2024-11-22', 'English', 'Ridley Scott', 'R', 7.2, 250000000.0, 460000000.0, 'Now Showing'),
(7, 'Up', 'Animation', 96, '2009-05-29', 'English', 'Pete Docter', 'PG', 8.3, 175000000.0, 735100000.0, 'Archived'),
(8, 'The Dark Knight', 'Action', 152, '2008-07-18', 'English', 'Christopher Nolan', 'PG-13', 9.0, 185000000.0, 1006000000.0, 'Archived'),
(9, 'Oppenheimer', 'Drama', 180, '2023-07-21', 'English', 'Christopher Nolan', 'R', 8.9, 100000000.0, 957000000.0, 'Archived'),
(10, 'Barbie', 'Comedy', 114, '2023-07-21', 'English', 'Greta Gerwig', 'PG-13', 7.0, 145000000.0, 1445000000.0, 'Archived'),
(11, 'Dune: Part Two', 'Sci-Fi', 166, '2024-03-01', 'English', 'Denis Villeneuve', 'PG-13', 8.6, 190000000.0, 714000000.0, 'Now Showing'),
(12, 'Spider-Man: Across the Spider-Verse', 'Animation', 140, '2023-06-02', 'English', 'Joaquim Dos Santos', 'PG', 8.7, 100000000.0, 690000000.0, 'Archived'),
(13, 'Avengers: Endgame', 'Action', 181, '2019-04-26', 'English', 'Anthony Russo', 'PG-13', 8.4, 356000000.0, 2799000000.0, 'Archived'),
(14, 'Top Gun: Maverick', 'Action', 130, '2022-05-27', 'English', 'Joseph Kosinski', 'PG-13', 8.3, 170000000.0, 1495000000.0, 'Archived'),
(15, 'Titanic', 'Romance', 195, '1997-12-19', 'English', 'James Cameron', 'PG-13', 7.9, 200000000.0, 2264000000.0, 'Archived'),
(16, 'Parasite', 'Thriller', 132, '2019-11-08', 'Korean', 'Bong Joon Ho', 'R', 8.5, 11400000.0, 263000000.0, 'Archived'),
(17, 'Spirited Away', 'Animation', 125, '2001-07-20', 'Japanese', 'Hayao Miyazaki', 'PG', 8.6, 19200000.0, 395800000.0, 'Archived'),
(18, 'The Matrix', 'Sci-Fi', 136, '1999-03-31', 'English', 'Lana Wachowski', 'R', 8.7, 63000000.0, 467200000.0, 'Archived'),
(19, 'Whiplash', 'Drama', 106, '2014-10-10', 'English', 'Damien Chazelle', 'R', 8.5, 3300000.0, 49000000.0, 'Archived'),
(20, 'The Lion King', 'Animation', 88, '1994-06-24', 'English', 'Roger Allers', 'G', 8.5, 45000000.0, 968500000.0, 'Archived'),
(21, 'Pulp Fiction', 'Crime', 154, '1994-10-14', 'English', 'Quentin Tarantino', 'R', 8.9, 8500000.0, 213900000.0, 'Archived'),
(22, 'Forrest Gump', 'Drama', 142, '1994-07-06', 'English', 'Robert Zemeckis', 'PG-13', 8.8, 55000000.0, 678200000.0, 'Archived'),
(23, 'The Shawshank Redemption', 'Drama', 142, '1994-09-22', 'English', 'Frank Darabont', 'R', 9.3, 25000000.0, 73300000.0, 'Archived'),
(24, 'Fight Club', 'Drama', 139, '1999-10-15', 'English', 'David Fincher', 'R', 8.8, 63000000.0, 101200000.0, 'Archived'),
(25, 'Goodfellas', 'Crime', 145, '1990-09-21', 'English', 'Martin Scorsese', 'R', 8.7, 25000000.0, 47100000.0, 'Archived'),
(26, 'The Prestige', 'Mystery', 130, '2006-10-20', 'English', 'Christopher Nolan', 'PG-13', 8.5, 40000000.0, 109700000.0, 'Archived'),
(27, 'Mission: Impossible - Dead Reckoning', 'Action', 163, '2023-07-12', 'English', 'Christopher McQuarrie', 'PG-13', 7.7, 291000000.0, 567500000.0, 'Archived'),
(28, 'John Wick: Chapter 4', 'Action', 169, '2023-03-24', 'English', 'Chad Stahelski', 'R', 7.7, 100000000.0, 440100000.0, 'Archived'),
(29, 'Spider-Man: No Way Home', 'Action', 148, '2021-12-17', 'English', 'Jon Watts', 'PG-13', 8.2, 200000000.0, 1922000000.0, 'Archived'),
(30, 'The Batman', 'Action', 176, '2022-03-04', 'English', 'Matt Reeves', 'PG-13', 7.8, 200000000.0, 772000000.0, 'Archived'),
(31, 'Guardians of the Galaxy Vol. 3', 'Action', 150, '2023-05-05', 'English', 'James Gunn', 'PG-13', 7.9, 250000000.0, 845600000.0, 'Archived'),
(32, 'Deadpool & Wolverine', 'Action', 128, '2024-07-26', 'English', 'Shawn Levy', 'R', 7.8, 200000000.0, 1338000000.0, 'Now Showing'),
(33, 'Inside Out 2', 'Animation', 96, '2024-06-14', 'English', 'Kelsey Mann', 'PG', 7.7, 200000000.0, 1698000000.0, 'Now Showing'),
(34, 'Wicked', 'Musical', 160, '2024-11-20', 'English', 'Jon M. Chu', 'PG', 8.0, 145000000.0, 720000000.0, 'Now Showing'),
(35, 'Moana 2', 'Animation', 100, '2024-11-27', 'English', 'David Derrick Jr.', 'PG', 7.0, 150000000.0, 1020000000.0, 'Now Showing');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Screen (120 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Screen (Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Row_Count, Seats_Per_Row, Sound_System, Projector_Model, Screen_Width_Feet, Screen_Height_Feet, Cleaning_Status, Is_Active) VALUES
(1, 'IMAX Screen 1', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(2, 'IMAX Screen 2', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(3, 'IMAX Screen 3', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(4, 'IMAX Screen 4', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(5, 'IMAX Screen 5', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(6, 'IMAX Screen 6', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(7, 'IMAX Screen 7', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(8, 'IMAX Screen 8', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(9, 'IMAX Screen 9', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(10, 'IMAX Screen 10', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(11, 'IMAX Screen 11', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(12, 'IMAX Screen 12', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(13, 'IMAX Screen 13', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(14, 'IMAX Screen 14', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(15, 'IMAX Screen 15', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(16, 'IMAX Screen 16', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(17, 'IMAX Screen 17', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(18, 'IMAX Screen 18', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(19, 'IMAX Screen 19', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(20, 'IMAX Screen 20', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(21, 'IMAX Screen 21', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(22, 'IMAX Screen 22', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(23, 'IMAX Screen 23', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(24, 'IMAX Screen 24', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(25, 'IMAX Screen 25', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(26, 'IMAX Screen 26', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(27, 'IMAX Screen 27', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(28, 'IMAX Screen 28', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(29, 'IMAX Screen 29', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(30, 'IMAX Screen 30', 'IMAX', 250, 10, 25, 'Dolby Atmos 12.2', 'Barco DP4K-60L Laser', 72.5, 52.8, 'Clean', 1),
(31, 'Gold Class Screen 1', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(32, 'Gold Class Screen 2', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(33, 'Gold Class Screen 3', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(34, 'Gold Class Screen 4', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(35, 'Gold Class Screen 5', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(36, 'Gold Class Screen 6', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(37, 'Gold Class Screen 7', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(38, 'Gold Class Screen 8', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(39, 'Gold Class Screen 9', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(40, 'Gold Class Screen 10', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(41, 'Gold Class Screen 11', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(42, 'Gold Class Screen 12', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(43, 'Gold Class Screen 13', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(44, 'Gold Class Screen 14', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(45, 'Gold Class Screen 15', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(46, 'Gold Class Screen 16', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(47, 'Gold Class Screen 17', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(48, 'Gold Class Screen 18', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(49, 'Gold Class Screen 19', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(50, 'Gold Class Screen 20', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(51, 'Gold Class Screen 21', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(52, 'Gold Class Screen 22', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(53, 'Gold Class Screen 23', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(54, 'Gold Class Screen 24', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(55, 'Gold Class Screen 25', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(56, 'Gold Class Screen 26', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(57, 'Gold Class Screen 27', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(58, 'Gold Class Screen 28', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(59, 'Gold Class Screen 29', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(60, 'Gold Class Screen 30', 'Gold_Class', 60, 5, 12, 'Meyer Sound EXP', 'Christie CP4430-RGB', 45.0, 24.0, 'Clean', 1),
(61, 'Premium VIP Screen 1', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(62, 'Premium VIP Screen 2', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(63, 'Premium VIP Screen 3', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(64, 'Premium VIP Screen 4', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(65, 'Premium VIP Screen 5', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(66, 'Premium VIP Screen 6', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(67, 'Premium VIP Screen 7', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(68, 'Premium VIP Screen 8', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(69, 'Premium VIP Screen 9', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(70, 'Premium VIP Screen 10', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(71, 'Premium VIP Screen 11', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(72, 'Premium VIP Screen 12', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(73, 'Premium VIP Screen 13', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(74, 'Premium VIP Screen 14', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(75, 'Premium VIP Screen 15', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(76, 'Premium VIP Screen 16', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(77, 'Premium VIP Screen 17', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(78, 'Premium VIP Screen 18', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(79, 'Premium VIP Screen 19', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(80, 'Premium VIP Screen 20', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(81, 'Premium VIP Screen 21', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(82, 'Premium VIP Screen 22', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(83, 'Premium VIP Screen 23', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(84, 'Premium VIP Screen 24', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(85, 'Premium VIP Screen 25', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(86, 'Premium VIP Screen 26', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(87, 'Premium VIP Screen 27', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(88, 'Premium VIP Screen 28', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(89, 'Premium VIP Screen 29', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(90, 'Premium VIP Screen 30', 'Premium_VIP', 100, 8, 13, 'JBL Synthesis Custom', 'Sony SRX-R515DS', 50.0, 28.0, 'Clean', 1),
(91, 'Silver Economy Screen 1', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(92, 'Silver Economy Screen 2', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(93, 'Silver Economy Screen 3', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(94, 'Silver Economy Screen 4', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(95, 'Silver Economy Screen 5', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(96, 'Silver Economy Screen 6', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(97, 'Silver Economy Screen 7', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(98, 'Silver Economy Screen 8', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(99, 'Silver Economy Screen 9', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(100, 'Silver Economy Screen 10', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(101, 'Silver Economy Screen 11', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(102, 'Silver Economy Screen 12', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(103, 'Silver Economy Screen 13', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(104, 'Silver Economy Screen 14', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(105, 'Silver Economy Screen 15', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(106, 'Silver Economy Screen 16', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(107, 'Silver Economy Screen 17', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(108, 'Silver Economy Screen 18', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(109, 'Silver Economy Screen 19', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(110, 'Silver Economy Screen 20', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(111, 'Silver Economy Screen 21', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(112, 'Silver Economy Screen 22', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(113, 'Silver Economy Screen 23', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(114, 'Silver Economy Screen 24', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(115, 'Silver Economy Screen 25', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(116, 'Silver Economy Screen 26', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(117, 'Silver Economy Screen 27', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(118, 'Silver Economy Screen 28', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(119, 'Silver Economy Screen 29', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1),
(120, 'Silver Economy Screen 30', 'Silver_Economy', 180, 10, 18, 'Dolby Surround 7.1', 'NEC NC3541L', 42.0, 22.0, 'Clean', 1);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: IMAXScreen (30 tuples)
-- -------------------------------------------------------------------------
INSERT INTO IMAXScreen (Screen_ID, Laser_Projection_Type, Aspect_Ratio, Dual_Laser_3D, Curved_Angle_Degrees, Commercial_License_Code) VALUES
(1, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-001'),
(2, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-002'),
(3, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-003'),
(4, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-004'),
(5, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-005'),
(6, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-006'),
(7, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-007'),
(8, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-008'),
(9, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-009'),
(10, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-010'),
(11, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-011'),
(12, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-012'),
(13, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-013'),
(14, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-014'),
(15, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-015'),
(16, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-016'),
(17, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-017'),
(18, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-018'),
(19, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-019'),
(20, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-020'),
(21, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-021'),
(22, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-022'),
(23, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-023'),
(24, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-024'),
(25, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-025'),
(26, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-026'),
(27, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-027'),
(28, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-028'),
(29, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-029'),
(30, 'Dual 4K Laser', '1.43:1', 1, 26.5, 'IMAX-LIC-030');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: GoldScreen (30 tuples)
-- -------------------------------------------------------------------------
INSERT INTO GoldScreen (Screen_ID, Lounge_Service_Type, Recliner_Model, Butler_Service_Enabled, Complimentary_Snack_Tier, Call_Button_Active) VALUES
(31, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(32, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(33, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(34, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(35, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(36, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(37, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(38, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(39, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(40, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(41, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(42, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(43, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(44, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(45, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(46, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(47, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(48, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(49, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(50, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(51, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(52, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(53, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(54, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(55, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(56, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(57, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(58, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(59, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1),
(60, 'Full Dining Service', 'La-Z-Boy Cinema Luxe', 1, 'Platinum Combo', 1);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: PremiumScreen (30 tuples)
-- -------------------------------------------------------------------------
INSERT INTO PremiumScreen (Screen_ID, Luxury_Level, Private_Balcony_Seats, Wine_Bar_Access, VIP_Restroom_Access, Heated_Seats) VALUES
(61, 'Presidential VIP', 16, 1, 1, 1),
(62, 'Presidential VIP', 16, 1, 1, 1),
(63, 'Presidential VIP', 16, 1, 1, 1),
(64, 'Presidential VIP', 16, 1, 1, 1),
(65, 'Presidential VIP', 16, 1, 1, 1),
(66, 'Presidential VIP', 16, 1, 1, 1),
(67, 'Presidential VIP', 16, 1, 1, 1),
(68, 'Presidential VIP', 16, 1, 1, 1),
(69, 'Presidential VIP', 16, 1, 1, 1),
(70, 'Presidential VIP', 16, 1, 1, 1),
(71, 'Presidential VIP', 16, 1, 1, 1),
(72, 'Presidential VIP', 16, 1, 1, 1),
(73, 'Presidential VIP', 16, 1, 1, 1),
(74, 'Presidential VIP', 16, 1, 1, 1),
(75, 'Presidential VIP', 16, 1, 1, 1),
(76, 'Presidential VIP', 16, 1, 1, 1),
(77, 'Presidential VIP', 16, 1, 1, 1),
(78, 'Presidential VIP', 16, 1, 1, 1),
(79, 'Presidential VIP', 16, 1, 1, 1),
(80, 'Presidential VIP', 16, 1, 1, 1),
(81, 'Presidential VIP', 16, 1, 1, 1),
(82, 'Presidential VIP', 16, 1, 1, 1),
(83, 'Presidential VIP', 16, 1, 1, 1),
(84, 'Presidential VIP', 16, 1, 1, 1),
(85, 'Presidential VIP', 16, 1, 1, 1),
(86, 'Presidential VIP', 16, 1, 1, 1),
(87, 'Presidential VIP', 16, 1, 1, 1),
(88, 'Presidential VIP', 16, 1, 1, 1),
(89, 'Presidential VIP', 16, 1, 1, 1),
(90, 'Presidential VIP', 16, 1, 1, 1);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: SilverScreen (30 tuples)
-- -------------------------------------------------------------------------
INSERT INTO SilverScreen (Screen_ID, Discount_Tier_Percent, Economy_Bundle_Eligible, Student_Pass_Accepted, Group_Discount_Active, Free_Refill_Eligible) VALUES
(91, 20, 1, 1, 1, 0),
(92, 20, 1, 1, 1, 0),
(93, 20, 1, 1, 1, 0),
(94, 20, 1, 1, 1, 0),
(95, 20, 1, 1, 1, 0),
(96, 20, 1, 1, 1, 0),
(97, 20, 1, 1, 1, 0),
(98, 20, 1, 1, 1, 0),
(99, 20, 1, 1, 1, 0),
(100, 20, 1, 1, 1, 0),
(101, 20, 1, 1, 1, 0),
(102, 20, 1, 1, 1, 0),
(103, 20, 1, 1, 1, 0),
(104, 20, 1, 1, 1, 0),
(105, 20, 1, 1, 1, 0),
(106, 20, 1, 1, 1, 0),
(107, 20, 1, 1, 1, 0),
(108, 20, 1, 1, 1, 0),
(109, 20, 1, 1, 1, 0),
(110, 20, 1, 1, 1, 0),
(111, 20, 1, 1, 1, 0),
(112, 20, 1, 1, 1, 0),
(113, 20, 1, 1, 1, 0),
(114, 20, 1, 1, 1, 0),
(115, 20, 1, 1, 1, 0),
(116, 20, 1, 1, 1, 0),
(117, 20, 1, 1, 1, 0),
(118, 20, 1, 1, 1, 0),
(119, 20, 1, 1, 1, 0),
(120, 20, 1, 1, 1, 0);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Showtime (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Showtime (Show_ID, Movie_ID, Screen_ID, Show_Date, Start_Time, End_Time, Base_Price, Show_Format, Available_Seats, Audio_Language, Subtitle_Language, Show_Status) VALUES
(1, 1, 1, '2024-12-02', '2024-12-02 18:30:00', '2024-12-02 21:00:00', 1200.0, 'IMAX 3D', 119, 'English', 'English', 'Completed'),
(2, 2, 2, '2024-12-03', '2024-12-03 18:30:00', '2024-12-03 21:00:00', 1200.0, 'IMAX 3D', 118, 'English', 'English', 'Completed'),
(3, 3, 3, '2024-12-04', '2024-12-04 18:30:00', '2024-12-04 21:00:00', 1200.0, 'IMAX 3D', 117, 'English', 'English', 'Completed'),
(4, 4, 4, '2024-12-05', '2024-12-05 18:30:00', '2024-12-05 21:00:00', 1200.0, 'IMAX 3D', 116, 'English', 'English', 'Completed'),
(5, 5, 5, '2024-12-06', '2024-12-06 18:30:00', '2024-12-06 21:00:00', 1200.0, 'IMAX 3D', 115, 'English', 'English', 'Completed'),
(6, 6, 6, '2024-12-07', '2024-12-07 18:30:00', '2024-12-07 21:00:00', 1200.0, 'IMAX 3D', 114, 'English', 'English', 'Completed'),
(7, 7, 7, '2024-12-08', '2024-12-08 18:30:00', '2024-12-08 21:00:00', 1200.0, 'IMAX 3D', 113, 'English', 'English', 'Completed'),
(8, 8, 8, '2024-12-09', '2024-12-09 18:30:00', '2024-12-09 21:00:00', 1200.0, 'IMAX 3D', 112, 'English', 'English', 'Completed'),
(9, 9, 9, '2024-12-10', '2024-12-10 18:30:00', '2024-12-10 21:00:00', 1200.0, 'IMAX 3D', 111, 'English', 'English', 'Completed'),
(10, 10, 10, '2024-12-11', '2024-12-11 18:30:00', '2024-12-11 21:00:00', 1200.0, 'IMAX 3D', 110, 'English', 'English', 'Completed'),
(11, 11, 11, '2024-12-12', '2024-12-12 18:30:00', '2024-12-12 21:00:00', 2200.0, '2D', 109, 'English', 'English', 'Completed'),
(12, 12, 12, '2024-12-13', '2024-12-13 18:30:00', '2024-12-13 21:00:00', 2200.0, '2D', 108, 'English', 'English', 'Completed'),
(13, 13, 13, '2024-12-14', '2024-12-14 18:30:00', '2024-12-14 21:00:00', 2200.0, '2D', 107, 'English', 'English', 'Completed'),
(14, 14, 14, '2024-12-15', '2024-12-15 18:30:00', '2024-12-15 21:00:00', 2200.0, '2D', 106, 'English', 'English', 'Completed'),
(15, 15, 15, '2024-12-16', '2024-12-16 18:30:00', '2024-12-16 21:00:00', 2200.0, '2D', 105, 'English', 'English', 'Completed'),
(16, 16, 16, '2024-12-17', '2024-12-17 18:30:00', '2024-12-17 21:00:00', 2200.0, '2D', 104, 'Korean', 'English', 'Scheduled'),
(17, 17, 17, '2024-12-18', '2024-12-18 18:30:00', '2024-12-18 21:00:00', 2200.0, '2D', 103, 'Japanese', 'English', 'Scheduled'),
(18, 18, 18, '2024-12-19', '2024-12-19 18:30:00', '2024-12-19 21:00:00', 2200.0, '2D', 102, 'English', 'English', 'Scheduled'),
(19, 19, 19, '2024-12-20', '2024-12-20 18:30:00', '2024-12-20 21:00:00', 2200.0, '2D', 101, 'English', 'English', 'Scheduled'),
(20, 20, 20, '2024-12-21', '2024-12-21 18:30:00', '2024-12-21 21:00:00', 2200.0, '2D', 100, 'English', 'English', 'Scheduled'),
(21, 21, 21, '2024-12-22', '2024-12-22 18:30:00', '2024-12-22 21:00:00', 1600.0, '3D', 99, 'English', 'English', 'Scheduled'),
(22, 22, 22, '2024-12-23', '2024-12-23 18:30:00', '2024-12-23 21:00:00', 1600.0, '3D', 98, 'English', 'English', 'Scheduled'),
(23, 23, 23, '2024-12-24', '2024-12-24 18:30:00', '2024-12-24 21:00:00', 1600.0, '3D', 97, 'English', 'English', 'Scheduled'),
(24, 24, 24, '2024-12-25', '2024-12-25 18:30:00', '2024-12-25 21:00:00', 1600.0, '3D', 96, 'English', 'English', 'Scheduled'),
(25, 25, 25, '2024-12-26', '2024-12-26 18:30:00', '2024-12-26 21:00:00', 1600.0, '3D', 95, 'English', 'English', 'Scheduled'),
(26, 26, 26, '2024-12-27', '2024-12-27 18:30:00', '2024-12-27 21:00:00', 900.0, '3D', 94, 'English', 'English', 'Scheduled'),
(27, 27, 27, '2024-12-28', '2024-12-28 18:30:00', '2024-12-28 21:00:00', 900.0, '3D', 93, 'English', 'English', 'Scheduled'),
(28, 28, 28, '2024-12-01', '2024-12-01 18:30:00', '2024-12-01 21:00:00', 900.0, '3D', 92, 'English', 'English', 'Scheduled'),
(29, 29, 29, '2024-12-02', '2024-12-02 18:30:00', '2024-12-02 21:00:00', 900.0, '3D', 91, 'English', 'English', 'Scheduled'),
(30, 30, 30, '2024-12-03', '2024-12-03 18:30:00', '2024-12-03 21:00:00', 900.0, '3D', 90, 'English', 'English', 'Scheduled'),
(31, 31, 31, '2024-12-04', '2024-12-04 18:30:00', '2024-12-04 21:00:00', 900.0, '4DX', 89, 'English', 'English', 'Scheduled'),
(32, 32, 32, '2024-12-05', '2024-12-05 18:30:00', '2024-12-05 21:00:00', 900.0, '4DX', 88, 'English', 'English', 'Scheduled'),
(33, 33, 33, '2024-12-06', '2024-12-06 18:30:00', '2024-12-06 21:00:00', 900.0, '4DX', 87, 'English', 'English', 'Scheduled'),
(34, 34, 34, '2024-12-07', '2024-12-07 18:30:00', '2024-12-07 21:00:00', 900.0, '4DX', 86, 'English', 'English', 'Scheduled'),
(35, 35, 35, '2024-12-08', '2024-12-08 18:30:00', '2024-12-08 21:00:00', 900.0, '4DX', 85, 'English', 'English', 'Scheduled');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Seat (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Seat (Seat_ID, Screen_ID, Row_Letter, Seat_Number, Seat_Code, Seat_Class, Price_Multiplier, Is_Wheelchair_Accessible, Is_Reserved, Maintenance_Status, Vibration_Supported, Seat_Color) VALUES
(1, 1, 'A', 1, 'A-01', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(2, 2, 'B', 2, 'B-02', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(3, 3, 'C', 3, 'C-03', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(4, 4, 'D', 4, 'D-04', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(5, 5, 'E', 5, 'E-05', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(6, 6, 'F', 6, 'F-06', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(7, 7, 'G', 7, 'G-07', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(8, 8, 'A', 8, 'A-08', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(9, 9, 'B', 9, 'B-09', 'VIP', 1.5, 0, 1, 'Operational', 1, 'Burgundy'),
(10, 10, 'C', 10, 'C-10', 'VIP', 1.5, 1, 1, 'Operational', 1, 'Burgundy'),
(11, 11, 'D', 11, 'D-11', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(12, 12, 'E', 12, 'E-12', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(13, 13, 'F', 13, 'F-13', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(14, 14, 'G', 14, 'G-14', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(15, 15, 'A', 15, 'A-15', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(16, 16, 'B', 1, 'B-01', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(17, 17, 'C', 2, 'C-02', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(18, 18, 'D', 3, 'D-03', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(19, 19, 'E', 4, 'E-04', 'Recliner', 1.3, 0, 1, 'Operational', 0, 'Burgundy'),
(20, 20, 'F', 5, 'F-05', 'Recliner', 1.3, 1, 1, 'Operational', 0, 'Burgundy'),
(21, 21, 'G', 6, 'G-06', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(22, 22, 'A', 7, 'A-07', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(23, 23, 'B', 8, 'B-08', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(24, 24, 'C', 9, 'C-09', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(25, 25, 'D', 10, 'D-10', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(26, 26, 'E', 11, 'E-11', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(27, 27, 'F', 12, 'F-12', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(28, 28, 'G', 13, 'G-13', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(29, 29, 'A', 14, 'A-14', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(30, 30, 'B', 15, 'B-15', 'Standard', 1.0, 1, 0, 'Operational', 0, 'Burgundy'),
(31, 31, 'C', 1, 'C-01', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(32, 32, 'D', 2, 'D-02', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(33, 33, 'E', 3, 'E-03', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(34, 34, 'F', 4, 'F-04', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy'),
(35, 35, 'G', 5, 'G-05', 'Standard', 1.0, 0, 0, 'Operational', 0, 'Burgundy');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Booking (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Booking (Booking_ID, Customer_ID, Show_ID, Booking_Timestamp, Total_Seats_Booked, Total_Amount, Discount_Amount, Tax_Amount, Net_Payable, Booking_Status, Payment_Status, Booking_Channel) VALUES
(1, 1, 1, '2024-12-02 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(2, 2, 2, '2024-12-03 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(3, 3, 3, '2024-12-04 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(4, 4, 4, '2024-12-05 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(5, 5, 5, '2024-12-06 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(6, 6, 6, '2024-12-07 14:15:00', 2, 3000.0, 150.0, 456.0, 3306.0, 'Confirmed', 'Paid', 'Box_Office'),
(7, 7, 7, '2024-12-08 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(8, 8, 8, '2024-12-09 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(9, 9, 9, '2024-12-10 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(10, 10, 10, '2024-12-11 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(11, 11, 11, '2024-12-12 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(12, 12, 12, '2024-12-13 14:15:00', 2, 3000.0, 150.0, 456.0, 3306.0, 'Confirmed', 'Paid', 'Box_Office'),
(13, 13, 13, '2024-12-14 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(14, 14, 14, '2024-12-15 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(15, 15, 15, '2024-12-16 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(16, 16, 16, '2024-12-17 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(17, 17, 17, '2024-12-18 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(18, 18, 18, '2024-12-19 14:15:00', 2, 3000.0, 150.0, 456.0, 3306.0, 'Confirmed', 'Paid', 'Box_Office'),
(19, 19, 19, '2024-12-20 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(20, 20, 20, '2024-12-21 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(21, 21, 21, '2024-12-22 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(22, 22, 22, '2024-12-23 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(23, 23, 23, '2024-12-24 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(24, 24, 24, '2024-12-25 14:15:00', 2, 3000.0, 150.0, 456.0, 3306.0, 'Confirmed', 'Paid', 'Box_Office'),
(25, 25, 25, '2024-12-26 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(26, 26, 26, '2024-12-27 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(27, 27, 27, '2024-12-28 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(28, 28, 28, '2024-12-01 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(29, 29, 29, '2024-12-02 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online'),
(30, 30, 30, '2024-12-03 14:15:00', 2, 3000.0, 150.0, 456.0, 3306.0, 'Confirmed', 'Paid', 'Box_Office'),
(31, 31, 31, '2024-12-04 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Cancelled', 'Refunded', 'Online'),
(32, 32, 32, '2024-12-05 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(33, 33, 33, '2024-12-06 14:15:00', 1, 1500.0, 150.0, 216.0, 1566.0, 'Confirmed', 'Paid', 'Online'),
(34, 34, 34, '2024-12-07 14:15:00', 2, 3000.0, 0.0, 480.0, 3480.0, 'Confirmed', 'Paid', 'Box_Office'),
(35, 35, 35, '2024-12-08 14:15:00', 1, 1500.0, 0.0, 240.0, 1740.0, 'Confirmed', 'Paid', 'Online');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Ticket (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Ticket (Ticket_ID, Booking_ID, Seat_ID, Ticket_Number, Barcode_Number, Ticket_Type, Base_Price, Final_Price, Is_Validated, Validation_Time, Checkin_Gate, Print_Count) VALUES
(1, 1, 1, 'TKT-2024-0001', 'BRC-987654-0001', 'Adult', 1500.0, 1500.0, 1, '2024-12-02 18:15:00', 'Gate 2', 1),
(2, 2, 2, 'TKT-2024-0002', 'BRC-987654-0002', 'Adult', 1500.0, 1500.0, 1, '2024-12-03 18:15:00', 'Gate 3', 1),
(3, 3, 3, 'TKT-2024-0003', 'BRC-987654-0003', 'Adult', 1500.0, 1500.0, 1, '2024-12-04 18:15:00', 'Gate 4', 1),
(4, 4, 4, 'TKT-2024-0004', 'BRC-987654-0004', 'Student', 1500.0, 1350.0, 1, '2024-12-05 18:15:00', 'Gate 1', 1),
(5, 5, 5, 'TKT-2024-0005', 'BRC-987654-0005', 'Adult', 1500.0, 1500.0, 1, '2024-12-06 18:15:00', 'Gate 2', 1),
(6, 6, 6, 'TKT-2024-0006', 'BRC-987654-0006', 'Adult', 1500.0, 1500.0, 1, '2024-12-07 18:15:00', 'Gate 3', 1),
(7, 7, 7, 'TKT-2024-0007', 'BRC-987654-0007', 'Adult', 1500.0, 1500.0, 1, '2024-12-08 18:15:00', 'Gate 4', 1),
(8, 8, 8, 'TKT-2024-0008', 'BRC-987654-0008', 'Student', 1500.0, 1350.0, 1, '2024-12-09 18:15:00', 'Gate 1', 1),
(9, 9, 9, 'TKT-2024-0009', 'BRC-987654-0009', 'Adult', 1500.0, 1500.0, 1, '2024-12-10 18:15:00', 'Gate 2', 1),
(10, 10, 10, 'TKT-2024-0010', 'BRC-987654-0010', 'Adult', 1500.0, 1500.0, 1, '2024-12-11 18:15:00', 'Gate 3', 1),
(11, 11, 11, 'TKT-2024-0011', 'BRC-987654-0011', 'Adult', 1500.0, 1500.0, 1, '2024-12-12 18:15:00', 'Gate 4', 1),
(12, 12, 12, 'TKT-2024-0012', 'BRC-987654-0012', 'Student', 1500.0, 1350.0, 1, '2024-12-13 18:15:00', 'Gate 1', 1),
(13, 13, 13, 'TKT-2024-0013', 'BRC-987654-0013', 'Adult', 1500.0, 1500.0, 1, '2024-12-14 18:15:00', 'Gate 2', 1),
(14, 14, 14, 'TKT-2024-0014', 'BRC-987654-0014', 'Adult', 1500.0, 1500.0, 1, '2024-12-15 18:15:00', 'Gate 3', 1),
(15, 15, 15, 'TKT-2024-0015', 'BRC-987654-0015', 'Adult', 1500.0, 1500.0, 1, '2024-12-16 18:15:00', 'Gate 4', 1),
(16, 16, 16, 'TKT-2024-0016', 'BRC-987654-0016', 'Student', 1500.0, 1350.0, 1, '2024-12-17 18:15:00', 'Gate 1', 1),
(17, 17, 17, 'TKT-2024-0017', 'BRC-987654-0017', 'Adult', 1500.0, 1500.0, 1, '2024-12-18 18:15:00', 'Gate 2', 1),
(18, 18, 18, 'TKT-2024-0018', 'BRC-987654-0018', 'Adult', 1500.0, 1500.0, 1, '2024-12-19 18:15:00', 'Gate 3', 1),
(19, 19, 19, 'TKT-2024-0019', 'BRC-987654-0019', 'Adult', 1500.0, 1500.0, 1, '2024-12-20 18:15:00', 'Gate 4', 1),
(20, 20, 20, 'TKT-2024-0020', 'BRC-987654-0020', 'Student', 1500.0, 1350.0, 1, '2024-12-21 18:15:00', 'Gate 1', 1),
(21, 21, 21, 'TKT-2024-0021', 'BRC-987654-0021', 'Adult', 1500.0, 1500.0, 1, '2024-12-22 18:15:00', 'Gate 2', 1),
(22, 22, 22, 'TKT-2024-0022', 'BRC-987654-0022', 'Adult', 1500.0, 1500.0, 1, '2024-12-23 18:15:00', 'Gate 3', 1),
(23, 23, 23, 'TKT-2024-0023', 'BRC-987654-0023', 'Adult', 1500.0, 1500.0, 1, '2024-12-24 18:15:00', 'Gate 4', 1),
(24, 24, 24, 'TKT-2024-0024', 'BRC-987654-0024', 'Student', 1500.0, 1350.0, 1, '2024-12-25 18:15:00', 'Gate 1', 1),
(25, 25, 25, 'TKT-2024-0025', 'BRC-987654-0025', 'Adult', 1500.0, 1500.0, 1, '2024-12-26 18:15:00', 'Gate 2', 1),
(26, 26, 26, 'TKT-2024-0026', 'BRC-987654-0026', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 3', 1),
(27, 27, 27, 'TKT-2024-0027', 'BRC-987654-0027', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 4', 1),
(28, 28, 28, 'TKT-2024-0028', 'BRC-987654-0028', 'Student', 1500.0, 1350.0, 0, NULL, 'Gate 1', 1),
(29, 29, 29, 'TKT-2024-0029', 'BRC-987654-0029', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 2', 1),
(30, 30, 30, 'TKT-2024-0030', 'BRC-987654-0030', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 3', 1),
(31, 31, 31, 'TKT-2024-0031', 'BRC-987654-0031', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 4', 1),
(32, 32, 32, 'TKT-2024-0032', 'BRC-987654-0032', 'Student', 1500.0, 1350.0, 0, NULL, 'Gate 1', 1),
(33, 33, 33, 'TKT-2024-0033', 'BRC-987654-0033', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 2', 1),
(34, 34, 34, 'TKT-2024-0034', 'BRC-987654-0034', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 3', 1),
(35, 35, 35, 'TKT-2024-0035', 'BRC-987654-0035', 'Adult', 1500.0, 1500.0, 0, NULL, 'Gate 4', 1);
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Employee (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Employee (Employee_ID, First_Name, Last_Name, CNIC, Designation, Department, Monthly_Salary, Shift_Timing, Hire_Date, Emergency_Contact, Performance_Rating, Employment_Status) VALUES
(1, 'Hamza', 'Ali', '35201-1000013-2', 'General Manager', 'Management', 185000.0, 'Morning', '2022-02-02', '0300-8880001', 3.6, 'Active'),
(2, 'Usman', 'Tariq', '35201-1000026-3', 'Assistant Manager', 'Management', 120000.0, 'Evening', '2022-03-03', '0300-8880002', 3.7, 'Active'),
(3, 'Noman', 'Khan', '35201-1000039-4', 'Senior IT Officer', 'Technical', 95000.0, 'Night', '2022-04-04', '0300-8880003', 3.8, 'Active'),
(4, 'Bilal', 'Ahmed', '35201-1000052-5', 'Projectionist Lead', 'Technical', 80000.0, 'Rotational', '2022-05-05', '0300-8880004', 3.9, 'Active'),
(5, 'Saif', 'Ullah', '35201-1000065-6', 'Floor Supervisor', 'Management', 75000.0, 'Morning', '2022-06-06', '0300-8880005', 4.0, 'Active'),
(6, 'Usman', 'Ali', '35201-1000078-7', 'Senior Cashier', 'Ticketing', 55000.0, 'Evening', '2022-07-07', '0300-8880006', 4.1, 'Active'),
(7, 'Fahad', 'Raza', '35201-1000091-8', 'Box Office Agent', 'Ticketing', 48000.0, 'Night', '2022-08-08', '0300-8880007', 4.2, 'Active'),
(8, 'Adeel', 'Akram', '35201-1000104-9', 'Concession Lead', 'Concessions', 52000.0, 'Rotational', '2022-09-09', '0300-8880008', 4.3, 'Active'),
(9, 'Zeeshan', 'Malik', '35201-1000117-1', 'Barista / Server', 'Concessions', 42000.0, 'Morning', '2022-10-10', '0300-8880009', 4.4, 'Active'),
(10, 'Kashif', 'Saeed', '35201-1000130-2', 'Chief Security Officer', 'Security', 65000.0, 'Evening', '2022-11-11', '0300-8880010', 4.5, 'Active'),
(11, 'Rizwan', 'Haider', '35201-1000143-3', 'Security Guard', 'Security', 40000.0, 'Night', '2022-12-12', '0300-8880011', 4.6, 'Active'),
(12, 'Waseem', 'Abbas', '35201-1000156-4', 'Head of Janitorial', 'Janitorial', 45000.0, 'Rotational', '2022-01-13', '0300-8880012', 4.7, 'Active'),
(13, 'Muneeb', 'Ur-Rehman', '35201-1000169-5', 'Cinema Attendant', 'Ticketing', 38000.0, 'Morning', '2022-02-14', '0300-8880013', 4.8, 'Active'),
(14, 'Salman', 'Butt', '35201-1000182-6', 'Sound Technician', 'Technical', 72000.0, 'Evening', '2022-03-15', '0300-8880014', 4.9, 'Active'),
(15, 'Tariq', 'Mahmood', '35201-1000195-7', 'Inventory Clerk', 'Concessions', 46000.0, 'Night', '2022-04-16', '0300-8880015', 3.5, 'Active'),
(16, 'Junaid', 'Jamshed', '35201-1000208-8', 'General Manager', 'Management', 185000.0, 'Rotational', '2022-05-17', '0300-8880016', 3.6, 'Active'),
(17, 'Shahbaz', 'Sharif', '35201-1000221-9', 'Assistant Manager', 'Management', 120000.0, 'Morning', '2022-06-18', '0300-8880017', 3.7, 'Active'),
(18, 'Nawaz', 'Sharif', '35201-1000234-1', 'Senior IT Officer', 'Technical', 95000.0, 'Evening', '2022-07-19', '0300-8880018', 3.8, 'Active'),
(19, 'Imran', 'Khan', '35201-1000247-2', 'Projectionist Lead', 'Technical', 80000.0, 'Night', '2022-08-20', '0300-8880019', 3.9, 'Active'),
(20, 'Asif', 'Zardari', '35201-1000260-3', 'Floor Supervisor', 'Management', 75000.0, 'Rotational', '2022-09-21', '0300-8880020', 4.0, 'Active'),
(21, 'Bilawal', 'Bhutto', '35201-1000273-4', 'Senior Cashier', 'Ticketing', 55000.0, 'Morning', '2022-10-22', '0300-8880021', 4.1, 'Active'),
(22, 'Murad', 'Saeed', '35201-1000286-5', 'Box Office Agent', 'Ticketing', 48000.0, 'Evening', '2022-11-23', '0300-8880022', 4.2, 'Active'),
(23, 'Shehryar', 'Afridi', '35201-1000299-6', 'Concession Lead', 'Concessions', 52000.0, 'Night', '2022-12-24', '0300-8880023', 4.3, 'Active'),
(24, 'Fawad', 'Chaudhry', '35201-1000312-7', 'Barista / Server', 'Concessions', 42000.0, 'Rotational', '2022-01-25', '0300-8880024', 4.4, 'Active'),
(25, 'Shah', 'Mahmood', '35201-1000325-8', 'Chief Security Officer', 'Security', 65000.0, 'Morning', '2022-02-26', '0300-8880025', 4.5, 'Active'),
(26, 'Pervez', 'Khattak', '35201-1000338-9', 'Security Guard', 'Security', 40000.0, 'Evening', '2022-03-27', '0300-8880026', 4.6, 'Active'),
(27, 'Shafqat', 'Mahmood', '35201-1000351-1', 'Head of Janitorial', 'Janitorial', 45000.0, 'Night', '2022-04-28', '0300-8880027', 4.7, 'Active'),
(28, 'Khusro', 'Bakhtiar', '35201-1000364-2', 'Cinema Attendant', 'Ticketing', 38000.0, 'Rotational', '2022-05-01', '0300-8880028', 4.8, 'Active'),
(29, 'Ali', 'Zaidi', '35201-1000377-3', 'Sound Technician', 'Technical', 72000.0, 'Morning', '2022-06-02', '0300-8880029', 4.9, 'Active'),
(30, 'Omar', 'Ayub', '35201-1000390-4', 'Inventory Clerk', 'Concessions', 46000.0, 'Evening', '2022-07-03', '0300-8880030', 3.5, 'Active'),
(31, 'Shaukat', 'Tarin', '35201-1000403-5', 'General Manager', 'Management', 185000.0, 'Night', '2022-08-04', '0300-8880031', 3.6, 'Active'),
(32, 'Abdul', 'Razak', '35201-1000416-6', 'Assistant Manager', 'Management', 120000.0, 'Rotational', '2022-09-05', '0300-8880032', 3.7, 'Active'),
(33, 'Babar', 'Azam', '35201-1000429-7', 'Senior IT Officer', 'Technical', 95000.0, 'Morning', '2022-10-06', '0300-8880033', 3.8, 'Active'),
(34, 'Mohammad', 'Rizwan', '35201-1000442-8', 'Projectionist Lead', 'Technical', 80000.0, 'Evening', '2022-11-07', '0300-8880034', 3.9, 'Active'),
(35, 'Shaheen', 'Afridi', '35201-1000455-9', 'Floor Supervisor', 'Management', 75000.0, 'Night', '2022-12-08', '0300-8880035', 4.0, 'Active');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Tuck_Shop (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Tuck_Shop (Item_ID, Item_Name, Category, Size_Option, Unit_Price, Cost_Price, Stock_Quantity, Reorder_Level, Supplier_Name, Calories_Kcal, Is_Available, Expiry_Date) VALUES
(1, 'Salted Popcorn (Regular)', 'Popcorn', 'Regular', 350.0, 110.0, 250, 40, 'Golden Corn Ltd', 320, 1, '2025-06-30'),
(2, 'Caramel Popcorn (Large)', 'Popcorn', 'Large', 550.0, 180.0, 180, 30, 'Sweet Treats Co', 540, 1, '2025-06-30'),
(3, 'Cheese Burst Popcorn (Jumbo)', 'Popcorn', 'Jumbo', 680.0, 220.0, 120, 25, 'Golden Corn Ltd', 620, 1, '2025-06-30'),
(4, 'Coca Cola 500ml', 'Beverages', 'Regular', 180.0, 75.0, 500, 80, 'Coca-Cola Beverages', 210, 1, '2025-12-31'),
(5, 'Diet Coke 500ml', 'Beverages', 'Regular', 190.0, 80.0, 300, 50, 'Coca-Cola Beverages', 0, 1, '2025-12-31'),
(6, 'Sprite Zero 500ml', 'Beverages', 'Regular', 180.0, 75.0, 320, 50, 'Coca-Cola Beverages', 0, 1, '2025-12-31'),
(7, 'Fanta Orange 500ml', 'Beverages', 'Regular', 180.0, 75.0, 280, 40, 'Coca-Cola Beverages', 220, 1, '2025-12-31'),
(8, 'Mineral Water 500ml', 'Beverages', 'Regular', 90.0, 35.0, 600, 100, 'Aquafina Pakistan', 0, 1, '2026-03-31'),
(9, 'Cheese Nachos with Jalapenos', 'Snacks', 'Regular', 480.0, 160.0, 160, 30, 'Mexicana Foods', 490, 1, '2025-05-15'),
(10, 'Salsa Dip Crispy Nachos', 'Snacks', 'Regular', 450.0, 150.0, 140, 25, 'Mexicana Foods', 410, 1, '2025-05-15'),
(11, 'Loaded Beef Nachos Supreme', 'Snacks', 'Large', 720.0, 280.0, 90, 20, 'Mexicana Foods', 750, 1, '2025-05-15'),
(12, 'Crispy Chicken Tenders (4pcs)', 'Snacks', 'Regular', 580.0, 240.0, 110, 25, 'K&Ns Foods', 520, 1, '2025-04-30'),
(13, 'Classic Hotdog with Relish', 'Snacks', 'Regular', 420.0, 160.0, 130, 30, 'Meat One Ltd', 430, 1, '2025-04-30'),
(14, 'Chocolate Fudge Brownie', 'Bakery', 'Regular', 320.0, 120.0, 95, 20, 'Sweet Tooth Bakery', 380, 1, '2025-03-31'),
(15, 'Warm Chocolate Chip Cookie', 'Bakery', 'Regular', 240.0, 80.0, 150, 30, 'Sweet Tooth Bakery', 290, 1, '2025-03-31'),
(16, 'Red Velvet Cupcake', 'Bakery', 'Regular', 280.0, 100.0, 80, 20, 'Sweet Tooth Bakery', 340, 1, '2025-03-31'),
(17, 'M&Ms Chocolate Candies', 'Candy', 'Small', 260.0, 110.0, 220, 40, 'Mars Inc Distributors', 240, 1, '2025-11-30'),
(18, 'Skittles Wild Berry', 'Candy', 'Small', 250.0, 105.0, 200, 35, 'Mars Inc Distributors', 210, 1, '2025-11-30'),
(19, 'Sour Patch Kids Gummy', 'Candy', 'Small', 290.0, 120.0, 170, 30, 'Mondelez Imports', 230, 1, '2025-11-30'),
(20, 'Snickers Bar Regular', 'Candy', 'Small', 180.0, 80.0, 250, 50, 'Mars Inc Distributors', 250, 1, '2025-12-31'),
(21, 'Couple Movie Combo (2 Pop + 2 Drinks)', 'Combos', 'Large', 1250.0, 450.0, 100, 20, 'In-House Bundling', 850, 1, '2025-06-30'),
(22, 'Family Feast Combo (Jumbo Pop + 4 Drinks + Nachos)', 'Combos', 'Jumbo', 2100.0, 780.0, 70, 15, 'In-House Bundling', 1450, 1, '2025-06-30'),
(23, 'Solo Binge Combo (Popcorn + Drink)', 'Combos', 'Regular', 650.0, 230.0, 150, 30, 'In-House Bundling', 510, 1, '2025-06-30'),
(24, 'Kids Delight Combo (Small Pop + Juice + Toy)', 'Combos', 'Small', 580.0, 210.0, 110, 25, 'In-House Bundling', 390, 1, '2025-06-30'),
(25, 'Iced Cafe Latte 400ml', 'Beverages', 'Regular', 380.0, 130.0, 140, 25, 'Espresso Beans Ltd', 160, 1, '2025-06-30'),
(26, 'Spanish Cold Brew Coffee', 'Beverages', 'Regular', 420.0, 150.0, 120, 20, 'Espresso Beans Ltd', 190, 1, '2025-06-30'),
(27, 'Peach Iced Tea 500ml', 'Beverages', 'Regular', 260.0, 90.0, 210, 35, 'Lipton Beverages', 140, 1, '2025-08-31'),
(28, 'Green Tea Lemon Mint', 'Beverages', 'Regular', 220.0, 60.0, 160, 30, 'Lipton Beverages', 20, 1, '2025-08-31'),
(29, 'Gourmet Truffle Fries', 'Snacks', 'Regular', 490.0, 170.0, 115, 25, 'Crispy Bites Co', 420, 1, '2025-05-15'),
(30, 'Peri Peri Seasoned Popcorn', 'Popcorn', 'Large', 520.0, 175.0, 135, 25, 'Golden Corn Ltd', 490, 1, '2025-06-30'),
(31, 'Butter Scotch Popcorn', 'Popcorn', 'Regular', 460.0, 155.0, 140, 30, 'Golden Corn Ltd', 480, 1, '2025-06-30'),
(32, 'Strawberry Slush 400ml', 'Beverages', 'Regular', 280.0, 85.0, 190, 40, 'Slush Puppie Int', 180, 1, '2025-09-30'),
(33, 'Blueberry Frozen Slush 400ml', 'Beverages', 'Regular', 280.0, 85.0, 180, 40, 'Slush Puppie Int', 180, 1, '2025-09-30'),
(34, 'Belgian Waffle on a Stick', 'Bakery', 'Regular', 390.0, 140.0, 90, 20, 'Sweet Tooth Bakery', 360, 1, '2025-03-31'),
(35, 'Soft Pretzel with Mustard Dip', 'Bakery', 'Regular', 340.0, 110.0, 110, 25, 'Sweet Tooth Bakery', 310, 1, '2025-03-31');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Concession_Order (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Concession_Order (Order_ID, Customer_ID, Employee_ID, Order_Timestamp, Total_Items_Count, Subtotal_Amount, Sales_Tax, Discount_Given, Total_Payable, Payment_Method, Counter_Number, Order_Status) VALUES
(1, 1, 9, '2024-12-02 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(2, 2, 10, '2024-12-03 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(3, 3, 11, '2024-12-04 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(4, 4, 12, '2024-12-05 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(5, 5, 8, '2024-12-06 18:45:00', 1, 450.0, 72.0, 50.0, 472.0, 'Cash', 2, 'Completed'),
(6, 6, 9, '2024-12-07 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(7, 7, 10, '2024-12-08 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(8, 8, 11, '2024-12-09 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(9, 9, 12, '2024-12-10 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(10, 10, 8, '2024-12-11 18:45:00', 2, 850.0, 136.0, 50.0, 936.0, 'Credit Card', 3, 'Completed'),
(11, 11, 9, '2024-12-12 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(12, 12, 10, '2024-12-13 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(13, 13, 11, '2024-12-14 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(14, 14, 12, '2024-12-15 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(15, 15, 8, '2024-12-16 18:45:00', 1, 450.0, 72.0, 50.0, 472.0, 'Debit Card', 4, 'Completed'),
(16, 16, 9, '2024-12-17 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(17, 17, 10, '2024-12-18 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(18, 18, 11, '2024-12-19 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(19, 19, 12, '2024-12-20 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(20, 20, 8, '2024-12-21 18:45:00', 2, 850.0, 136.0, 50.0, 936.0, 'Mobile Wallet', 1, 'Completed'),
(21, 21, 9, '2024-12-22 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(22, 22, 10, '2024-12-23 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(23, 23, 11, '2024-12-24 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(24, 24, 12, '2024-12-25 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(25, 25, 8, '2024-12-26 18:45:00', 1, 450.0, 72.0, 50.0, 472.0, 'Cash', 2, 'Completed'),
(26, 26, 9, '2024-12-27 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(27, 27, 10, '2024-12-28 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(28, 28, 11, '2024-12-01 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(29, 29, 12, '2024-12-02 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(30, 30, 8, '2024-12-03 18:45:00', 2, 850.0, 136.0, 50.0, 936.0, 'Credit Card', 3, 'Completed'),
(31, NULL, 9, '2024-12-04 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Debit Card', 4, 'Completed'),
(32, NULL, 10, '2024-12-05 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Mobile Wallet', 1, 'Completed'),
(33, NULL, 11, '2024-12-06 18:45:00', 1, 450.0, 72.0, 0.0, 522.0, 'Cash', 2, 'Completed'),
(34, NULL, 12, '2024-12-07 18:45:00', 2, 850.0, 136.0, 0.0, 986.0, 'Credit Card', 3, 'Completed'),
(35, NULL, 8, '2024-12-08 18:45:00', 1, 450.0, 72.0, 50.0, 472.0, 'Debit Card', 4, 'Completed');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Concession_Item_Order (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Concession_Item_Order (Order_ID, Item_ID, Quantity, Unit_Price_Charged, Subtotal, Notes) VALUES
(1, 2, 1, 550.0, 550.0, 'Extra butter'),
(2, 3, 1, 680.0, 680.0, 'Extra butter'),
(3, 4, 2, 180.0, 360.0, 'Cold drink'),
(4, 5, 1, 190.0, 190.0, 'Cold drink'),
(5, 6, 1, 180.0, 180.0, 'Cold drink'),
(6, 7, 2, 180.0, 360.0, 'Cold drink'),
(7, 8, 1, 90.0, 90.0, 'Cold drink'),
(8, 9, 1, 480.0, 480.0, 'Standard order'),
(9, 10, 2, 450.0, 900.0, 'Standard order'),
(10, 11, 1, 720.0, 720.0, 'Standard order'),
(11, 12, 1, 580.0, 580.0, 'Standard order'),
(12, 13, 2, 420.0, 840.0, 'Standard order'),
(13, 14, 1, 320.0, 320.0, 'Standard order'),
(14, 15, 1, 240.0, 240.0, 'Standard order'),
(15, 16, 2, 280.0, 560.0, 'Standard order'),
(16, 17, 1, 260.0, 260.0, 'Standard order'),
(17, 18, 1, 250.0, 250.0, 'Standard order'),
(18, 19, 2, 290.0, 580.0, 'Standard order'),
(19, 20, 1, 180.0, 180.0, 'Standard order'),
(20, 21, 1, 1250.0, 1250.0, 'Standard order'),
(21, 22, 2, 2100.0, 4200.0, 'Standard order'),
(22, 23, 1, 650.0, 650.0, 'Standard order'),
(23, 24, 1, 580.0, 580.0, 'Standard order'),
(24, 25, 2, 380.0, 760.0, 'Standard order'),
(25, 26, 1, 420.0, 420.0, 'Standard order'),
(26, 27, 1, 260.0, 260.0, 'Standard order'),
(27, 28, 2, 220.0, 440.0, 'Standard order'),
(28, 1, 1, 350.0, 350.0, 'Extra butter'),
(29, 2, 1, 550.0, 550.0, 'Extra butter'),
(30, 3, 2, 680.0, 1360.0, 'Extra butter'),
(31, 4, 1, 180.0, 180.0, 'Cold drink'),
(32, 5, 1, 190.0, 190.0, 'Cold drink'),
(33, 6, 2, 180.0, 360.0, 'Cold drink'),
(34, 7, 1, 180.0, 180.0, 'Cold drink'),
(35, 8, 1, 90.0, 90.0, 'Cold drink');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Parking (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Parking (Parking_ID, Customer_ID, Slot_Number, Vehicle_Type, License_Plate, Entry_Time, Exit_Time, Parked_Duration_Hours, Hourly_Rate, Total_Parking_Fee, Parking_Bay_Zone, Payment_Status) VALUES
(1, 1, 'P-02', 'Car', 'LHR-2001', '2024-12-02 18:00:00', '2024-12-02 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(2, 2, 'P-03', 'SUV', 'LHR-2002', '2024-12-03 18:00:00', '2024-12-03 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(3, 3, 'P-04', 'Motorcycle', 'LHR-2003', '2024-12-04 18:00:00', '2024-12-04 21:30:00', 3.5, 50.0, 175.0, 'A', 'Paid'),
(4, 4, 'P-05', 'Van', 'LHR-2004', '2024-12-05 18:00:00', '2024-12-05 21:30:00', 3.5, 150.0, 525.0, 'A', 'Paid'),
(5, 5, 'P-06', 'EV', 'LHR-2005', '2024-12-06 18:00:00', '2024-12-06 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(6, 6, 'P-07', 'Car', 'LHR-2006', '2024-12-07 18:00:00', '2024-12-07 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(7, 7, 'P-08', 'SUV', 'LHR-2007', '2024-12-08 18:00:00', '2024-12-08 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(8, 8, 'P-09', 'Motorcycle', 'LHR-2008', '2024-12-09 18:00:00', '2024-12-09 21:30:00', 3.5, 50.0, 175.0, 'A', 'Paid'),
(9, 9, 'P-10', 'Van', 'LHR-2009', '2024-12-10 18:00:00', '2024-12-10 21:30:00', 3.5, 150.0, 525.0, 'A', 'Paid'),
(10, 10, 'P-11', 'EV', 'LHR-2010', '2024-12-11 18:00:00', '2024-12-11 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(11, 11, 'P-12', 'Car', 'LHR-2011', '2024-12-12 18:00:00', '2024-12-12 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(12, 12, 'P-13', 'SUV', 'LHR-2012', '2024-12-13 18:00:00', '2024-12-13 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(13, 13, 'P-14', 'Motorcycle', 'LHR-2013', '2024-12-14 18:00:00', '2024-12-14 21:30:00', 3.5, 50.0, 175.0, 'A', 'Paid'),
(14, 14, 'P-15', 'Van', 'LHR-2014', '2024-12-15 18:00:00', '2024-12-15 21:30:00', 3.5, 150.0, 525.0, 'A', 'Paid'),
(15, 15, 'P-16', 'EV', 'LHR-2015', '2024-12-16 18:00:00', '2024-12-16 21:30:00', 3.5, 100.0, 350.0, 'A', 'Paid'),
(16, 16, 'P-17', 'Car', 'LHR-2016', '2024-12-17 18:00:00', '2024-12-17 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(17, 17, 'P-18', 'SUV', 'LHR-2017', '2024-12-18 18:00:00', '2024-12-18 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(18, 18, 'P-19', 'Motorcycle', 'LHR-2018', '2024-12-19 18:00:00', '2024-12-19 21:30:00', 3.5, 50.0, 175.0, 'B', 'Paid'),
(19, 19, 'P-20', 'Van', 'LHR-2019', '2024-12-20 18:00:00', '2024-12-20 21:30:00', 3.5, 150.0, 525.0, 'B', 'Paid'),
(20, 20, 'P-21', 'EV', 'LHR-2020', '2024-12-21 18:00:00', '2024-12-21 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(21, 21, 'P-22', 'Car', 'LHR-2021', '2024-12-22 18:00:00', '2024-12-22 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(22, 22, 'P-23', 'SUV', 'LHR-2022', '2024-12-23 18:00:00', '2024-12-23 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(23, 23, 'P-24', 'Motorcycle', 'LHR-2023', '2024-12-24 18:00:00', '2024-12-24 21:30:00', 3.5, 50.0, 175.0, 'B', 'Paid'),
(24, 24, 'P-25', 'Van', 'LHR-2024', '2024-12-25 18:00:00', '2024-12-25 21:30:00', 3.5, 150.0, 525.0, 'B', 'Paid'),
(25, 25, 'P-26', 'EV', 'LHR-2025', '2024-12-26 18:00:00', '2024-12-26 21:30:00', 3.5, 100.0, 350.0, 'B', 'Paid'),
(26, 26, 'P-27', 'Car', 'LHR-2026', '2024-12-27 18:00:00', '2024-12-27 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid'),
(27, 27, 'P-28', 'SUV', 'LHR-2027', '2024-12-28 18:00:00', '2024-12-28 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid'),
(28, 28, 'P-29', 'Motorcycle', 'LHR-2028', '2024-12-01 18:00:00', '2024-12-01 21:30:00', 3.5, 50.0, 175.0, 'C', 'Paid'),
(29, 29, 'P-30', 'Van', 'LHR-2029', '2024-12-02 18:00:00', '2024-12-02 21:30:00', 3.5, 150.0, 525.0, 'C', 'Paid'),
(30, 30, 'P-31', 'EV', 'LHR-2030', '2024-12-03 18:00:00', '2024-12-03 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid'),
(31, NULL, 'P-32', 'Car', 'LHR-2031', '2024-12-04 18:00:00', '2024-12-04 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid'),
(32, NULL, 'P-33', 'SUV', 'LHR-2032', '2024-12-05 18:00:00', '2024-12-05 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid'),
(33, NULL, 'P-34', 'Motorcycle', 'LHR-2033', '2024-12-06 18:00:00', '2024-12-06 21:30:00', 3.5, 50.0, 175.0, 'C', 'Paid'),
(34, NULL, 'P-35', 'Van', 'LHR-2034', '2024-12-07 18:00:00', '2024-12-07 21:30:00', 3.5, 150.0, 525.0, 'C', 'Paid'),
(35, NULL, 'P-36', 'EV', 'LHR-2035', '2024-12-08 18:00:00', '2024-12-08 21:30:00', 3.5, 100.0, 350.0, 'C', 'Paid');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Security_Checkpoint (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Security_Checkpoint (Checkpoint_ID, Gate_Name, Guard_Employee_ID, Customer_ID, Ticket_ID, Inspection_Timestamp, Luggage_Scanned, Metal_Detector_Cleared, Pass_Status, Supervisor_Notified, Remarks, Scanner_Device_ID) VALUES
(1, 'Main Gate 2', 10, 1, 1, '2024-12-02 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(2, 'Main Gate 3', 11, 2, 2, '2024-12-03 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(3, 'Main Gate 1', 10, 3, 3, '2024-12-04 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(4, 'Main Gate 2', 11, 4, 4, '2024-12-05 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(5, 'Main Gate 3', 10, 5, 5, '2024-12-06 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(6, 'Main Gate 1', 11, 6, 6, '2024-12-07 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(7, 'Main Gate 2', 10, 7, 7, '2024-12-08 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(8, 'Main Gate 3', 11, 8, 8, '2024-12-09 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(9, 'Main Gate 1', 10, 9, 9, '2024-12-10 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(10, 'Main Gate 2', 11, 10, 10, '2024-12-11 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(11, 'Main Gate 3', 10, 11, 11, '2024-12-12 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(12, 'Main Gate 1', 11, 12, 12, '2024-12-13 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(13, 'Main Gate 2', 10, 13, 13, '2024-12-14 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(14, 'Main Gate 3', 11, 14, 14, '2024-12-15 18:20:00', 1, 1, 'Approved', 0, 'Handbag inspected manually', 'SCN-03'),
(15, 'Main Gate 1', 10, 15, 15, '2024-12-16 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(16, 'Main Gate 2', 11, 16, 16, '2024-12-17 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(17, 'Main Gate 3', 10, 17, 17, '2024-12-18 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(18, 'Main Gate 1', 11, 18, 18, '2024-12-19 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(19, 'Main Gate 2', 10, 19, 19, '2024-12-20 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(20, 'Main Gate 3', 11, 20, 20, '2024-12-21 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(21, 'Main Gate 1', 10, 21, 21, '2024-12-22 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(22, 'Main Gate 2', 11, 22, 22, '2024-12-23 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(23, 'Main Gate 3', 10, 23, 23, '2024-12-24 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(24, 'Main Gate 1', 11, 24, 24, '2024-12-25 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(25, 'Main Gate 2', 10, 25, 25, '2024-12-26 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(26, 'Main Gate 3', 11, 26, 26, '2024-12-27 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(27, 'Main Gate 1', 10, 27, 27, '2024-12-28 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(28, 'Main Gate 2', 11, 28, 28, '2024-12-01 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(29, 'Main Gate 3', 10, 29, 29, '2024-12-02 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(30, 'Main Gate 1', 11, 30, 30, '2024-12-03 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(31, 'Main Gate 2', 10, 31, 31, '2024-12-04 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(32, 'Main Gate 3', 11, 32, 32, '2024-12-05 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03'),
(33, 'Main Gate 1', 10, 33, 33, '2024-12-06 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-01'),
(34, 'Main Gate 2', 11, 34, 34, '2024-12-07 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-02'),
(35, 'Main Gate 3', 10, 35, 35, '2024-12-08 18:20:00', 1, 1, 'Approved', 0, 'Clear screening', 'SCN-03');
GO

-- -------------------------------------------------------------------------
-- Data Ingestion: Movie_Review (35 tuples)
-- -------------------------------------------------------------------------
INSERT INTO Movie_Review (Review_ID, Customer_ID, Movie_ID, Rating_Stars, Review_Title, Review_Text, Review_Date, Helpful_Votes, Is_Verified_Watcher, Sentiment_Tag, Platform_Used, Moderation_Status) VALUES
(1, 1, 1, 3, 'Spectacular animation and fun humor!', 'The screening of movie #1 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-02', 13, 1, 'Positive', 'Web Portal', 'Approved'),
(2, 2, 2, 4, 'Mind-bending cinematic masterpiece', 'The screening of movie #2 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-03', 16, 1, 'Positive', 'Web Portal', 'Approved'),
(3, 3, 3, 5, 'Nolan at his absolute finest', 'The screening of movie #3 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-04', 19, 1, 'Positive', 'Web Portal', 'Approved'),
(4, 4, 4, 4, 'Haunting and deeply moving performance', 'The screening of movie #4 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-05', 22, 1, 'Positive', 'Web Portal', 'Approved'),
(5, 5, 5, 3, 'Visual effects are out of this world', 'The screening of movie #5 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-06', 25, 1, 'Positive', 'Web Portal', 'Approved'),
(6, 6, 6, 5, 'Epic historical action thriller', 'The screening of movie #6 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-07', 28, 1, 'Positive', 'Web Portal', 'Approved'),
(7, 7, 7, 3, 'Tears and laughter in equal measure', 'The screening of movie #7 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-08', 31, 1, 'Positive', 'Web Portal', 'Approved'),
(8, 8, 8, 4, 'The definitive comic book masterpiece', 'The screening of movie #8 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-09', 34, 1, 'Positive', 'Web Portal', 'Approved'),
(9, 9, 9, 5, 'Gripping, intense biographical drama', 'The screening of movie #9 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-10', 37, 1, 'Positive', 'Web Portal', 'Approved'),
(10, 10, 10, 4, 'Clever satire and beautiful art design', 'The screening of movie #10 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-11', 40, 1, 'Positive', 'Web Portal', 'Approved'),
(11, 11, 11, 3, 'Sci-fi worldbuilding at its peak', 'The screening of movie #11 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-12', 43, 1, 'Positive', 'Web Portal', 'Approved'),
(12, 12, 12, 5, 'Groundbreaking animation style', 'The screening of movie #12 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-13', 46, 1, 'Positive', 'Web Portal', 'Approved'),
(13, 13, 13, 3, 'Emotional conclusion to an epic saga', 'The screening of movie #13 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-14', 49, 1, 'Positive', 'Web Portal', 'Approved'),
(14, 14, 14, 4, 'Pure adrenaline and thrilling flight scenes', 'The screening of movie #14 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-15', 52, 1, 'Positive', 'Web Portal', 'Approved'),
(15, 15, 15, 5, 'Timeless tragic love story', 'The screening of movie #15 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-16', 55, 1, 'Positive', 'Web Portal', 'Approved'),
(16, 16, 16, 4, 'Intelligent social commentary and thrills', 'The screening of movie #16 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-17', 58, 1, 'Positive', 'Web Portal', 'Approved'),
(17, 17, 17, 3, 'Poetic and magical Japanese storytelling', 'The screening of movie #17 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-18', 61, 1, 'Positive', 'Web Portal', 'Approved'),
(18, 18, 18, 5, 'Ahead of its time, absolute classic', 'The screening of movie #18 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-19', 64, 1, 'Positive', 'Web Portal', 'Approved'),
(19, 19, 19, 3, 'Intense music and drumming drama', 'The screening of movie #19 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-20', 67, 1, 'Positive', 'Web Portal', 'Approved'),
(20, 20, 20, 4, 'Pure nostalgia and royal majesty', 'The screening of movie #20 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-21', 70, 1, 'Positive', 'Web Portal', 'Approved'),
(21, 21, 21, 5, 'Quentin Tarantino genius writing', 'The screening of movie #21 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-22', 73, 1, 'Positive', 'Web Portal', 'Approved'),
(22, 22, 22, 4, 'Heartwarming and beautifully simple', 'The screening of movie #22 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-23', 76, 1, 'Positive', 'Web Portal', 'Approved'),
(23, 23, 23, 3, 'Greatest prison escape film ever made', 'The screening of movie #23 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-24', 79, 1, 'Positive', 'Web Portal', 'Approved'),
(24, 24, 24, 5, 'Thought-provoking modern classic', 'The screening of movie #24 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-25', 82, 1, 'Positive', 'Web Portal', 'Approved'),
(25, 25, 25, 3, 'Masterclass in mafia gangster cinema', 'The screening of movie #25 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-26', 85, 1, 'Positive', 'Web Portal', 'Approved'),
(26, 26, 26, 4, 'Twists and turns until the very end', 'The screening of movie #26 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-27', 88, 1, 'Positive', 'Web Portal', 'Approved'),
(27, 27, 27, 5, 'Breathtaking action and stuntwork', 'The screening of movie #27 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-28', 91, 1, 'Positive', 'Web Portal', 'Approved'),
(28, 28, 28, 4, 'Non-stop stylish action perfection', 'The screening of movie #28 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-01', 94, 1, 'Positive', 'Web Portal', 'Approved'),
(29, 29, 29, 3, 'Amazing multiverse nostalgia trip', 'The screening of movie #29 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-02', 97, 1, 'Positive', 'Web Portal', 'Approved'),
(30, 30, 30, 5, 'Dark, gritty, and atmospheric detective noir', 'The screening of movie #30 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-03', 100, 1, 'Positive', 'Web Portal', 'Approved'),
(31, 31, 31, 3, 'Heartfelt and wonderful trilogy closer', 'The screening of movie #31 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-04', 103, 1, 'Positive', 'Web Portal', 'Approved'),
(32, 32, 32, 4, 'Hilarious comedy with great action', 'The screening of movie #32 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-05', 106, 1, 'Positive', 'Web Portal', 'Approved'),
(33, 33, 33, 5, 'Brilliant exploration of teenage anxiety', 'The screening of movie #33 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-06', 109, 1, 'Positive', 'Web Portal', 'Approved'),
(34, 34, 34, 4, 'Spectacular musical numbers and costumes', 'The screening of movie #34 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-07', 112, 1, 'Positive', 'Web Portal', 'Approved'),
(35, 35, 35, 3, 'Fun family adventure with great songs', 'The screening of movie #35 was exceptional. Sound quality, picture clarity, and seating comfort exceeded expectations.', '2024-12-08', 115, 1, 'Positive', 'Web Portal', 'Approved');
GO

-- ==========================================================================
-- 8.2.C UPDATE OPERATIONS (Demonstrating at least 5 UPDATE queries)
-- ==========================================================================

-- Update 1: Upgrade customer membership tier and grant bonus loyalty points
UPDATE Customer
SET Membership_Type = 'VIP',
    Loyalty_Points = Loyalty_Points + 100
WHERE Customer_ID = 4 AND Loyalty_Points >= 100;
GO

-- Update 2: Apply 10% promotional price reduction on high-inventory beverages
UPDATE Tuck_Shop
SET Unit_Price = ROUND(Unit_Price * 0.90, 2)
WHERE Category = 'Beverages' AND Stock_Quantity > 300;
GO

-- Update 3: Annual 8% performance merit salary increment for top-rated staff
UPDATE Employee
SET Monthly_Salary = ROUND(Monthly_Salary * 1.08, 2)
WHERE Performance_Rating >= 4.5 AND Employment_Status = 'Active';
GO

-- Update 4: Mark scheduled showtime as 'Housefull' when remaining seats drop below 10
UPDATE Showtime
SET Show_Status = 'Housefull'
WHERE Available_Seats <= 10 AND Show_Status = 'Selling Fast';
GO

-- Update 5: Validate ticket upon security checkpoint verification
UPDATE Ticket
SET Is_Validated = 1,
    Validation_Time = GETDATE()
WHERE Ticket_ID = 30 AND Is_Validated = 0;
GO

-- ==========================================================================
-- 8.2.D WHERE CLAUSE AND OPERATORS DEMONSTRATION (30 DISTINCT QUERIES)
-- Covering: =, <>, !=, <, >, <=, >=, AND, OR, NOT, +, -, *, /,
-- DISTINCT, GROUP BY, HAVING, BETWEEN, LIKE, IN, ORDER BY
-- ==========================================================================

-- Query #1 [Operator: =]
-- Purpose: Retrieve the full profile of all registered customers who reside in the city of 'Lahore'.
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type, City FROM Customer WHERE City = 'Lahore';
GO

-- Query #2 [Operator: <>]
-- Purpose: Find all movies in the cinema catalog whose parental age rating is not 'R' (Restricted).
SELECT Movie_ID, Title, Genre, Age_Rating, IMDb_Rating FROM Movie WHERE Age_Rating <> 'R';
GO

-- Query #3 [Operator: !=]
-- Purpose: Retrieve all staff members who are not assigned to the 'Morning' shift schedule.
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Shift_Timing FROM Employee WHERE Shift_Timing != 'Morning';
GO

-- Query #4 [Operator: <]
-- Purpose: Identify all tuck shop items that are priced affordably at less than 250 PKR.
SELECT Item_ID, Item_Name, Category, Unit_Price, Stock_Quantity FROM Tuck_Shop WHERE Unit_Price < 250.00;
GO

-- Query #5 [Operator: >]
-- Purpose: List all blockbuster movies with an exceptional IMDb rating strictly greater than 8.5.
SELECT Movie_ID, Title, Director, IMDb_Rating, Box_Office_Revenue FROM Movie WHERE IMDb_Rating > 8.5;
GO

-- Query #6 [Operator: <=]
-- Purpose: Find all movie showtimes that have 95 or fewer available seats remaining (selling fast).
SELECT Show_ID, Movie_ID, Screen_ID, Show_Date, Base_Price, Available_Seats, Show_Format FROM Showtime WHERE Available_Seats <= 95;
GO

-- Query #7 [Operator: >=]
-- Purpose: Retrieve all senior personnel earning a monthly salary of at least 75,000 PKR.
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary >= 75000.00;
GO

-- Query #8 [Operator: AND]
-- Purpose: Find active VIP tier members who have earned more than 400 loyalty points.
SELECT Customer_ID, First_Name, Last_Name, Membership_Type, Loyalty_Points, Is_Active FROM Customer WHERE Membership_Type = 'VIP' AND Loyalty_Points > 400;
GO

-- Query #9 [Operator: OR]
-- Purpose: Retrieve bookings that were either confirmed or completed through the physical 'Box_Office' channel.
SELECT Booking_ID, Customer_ID, Total_Seats_Booked, Net_Payable, Booking_Status, Booking_Channel FROM Booking WHERE Booking_Status = 'Confirmed' OR Booking_Channel = 'Box_Office';
GO

-- Query #10 [Operator: NOT]
-- Purpose: Retrieve all movies that do not belong to the 'Drama' genre.
SELECT Movie_ID, Title, Genre, Duration_Minutes, IMDb_Rating FROM Movie WHERE NOT (Genre = 'Drama');
GO

-- Query #11 [Operator: + (Arithmetic in WHERE)]
-- Purpose: Calculate ticket gross cost with an added 100 PKR surcharge where the adjusted price exceeds 1500 PKR.
SELECT Ticket_ID, Ticket_Number, Base_Price, (Base_Price + 100.00) AS Gross_Price_With_Surcharge FROM Ticket WHERE (Base_Price + 100.00) > 1500.00;
GO

-- Query #12 [Operator: - (Arithmetic in WHERE)]
-- Purpose: Display bookings where adjusted subtotal (Total_Amount - Discount_Amount) strictly exceeds 2000 PKR.
SELECT Booking_ID, Total_Amount, Discount_Amount, (Total_Amount - Discount_Amount) AS Adjusted_Subtotal FROM Booking WHERE (Total_Amount - Discount_Amount) > 2000.00;
GO

-- Query #13 [Operator: * (Arithmetic in WHERE)]
-- Purpose: Compute total inventory valuation (Stock_Quantity * Cost_Price) for items whose total stock valuation exceeds 30,000 PKR.
SELECT Item_ID, Item_Name, Stock_Quantity, Cost_Price, (Stock_Quantity * Cost_Price) AS Total_Stock_Valuation FROM Tuck_Shop WHERE (Stock_Quantity * Cost_Price) > 30000.00;
GO

-- Query #14 [Operator: / (Arithmetic in WHERE)]
-- Purpose: Calculate the estimated hourly wage (Monthly_Salary / 160 hours) for staff earning an hourly rate of at least 450 PKR.
SELECT Employee_ID, First_Name, Last_Name, Designation, Monthly_Salary, ROUND(Monthly_Salary / 160.0, 2) AS Hourly_Rate_PKR FROM Employee WHERE (Monthly_Salary / 160.0) >= 450.00;
GO

-- Query #15 [Operator: DISTINCT]
-- Purpose: Retrieve a distinct list of all cinematic genres currently represented in the cinema database.
SELECT DISTINCT Genre FROM Movie WHERE Status IN ('Now Showing', 'Archived');
GO

-- Query #16 [Operator: GROUP BY]
-- Purpose: Aggregate customer distribution by city to determine regional customer density.
SELECT City, COUNT(Customer_ID) AS Total_Customers FROM Customer WHERE Is_Active = 1 GROUP BY City;
GO

-- Query #17 [Operator: HAVING]
-- Purpose: Identify departments whose average employee monthly salary exceeds 60,000 PKR.
SELECT Department, COUNT(Employee_ID) AS Total_Staff, ROUND(AVG(Monthly_Salary), 2) AS Avg_Monthly_Salary FROM Employee WHERE Employment_Status = 'Active' GROUP BY Department HAVING AVG(Monthly_Salary) > 60000.00;
GO

-- Query #18 [Operator: BETWEEN]
-- Purpose: Find all classic films released between January 1, 1990 and December 31, 2005.
SELECT Movie_ID, Title, Release_Date, Genre, Director FROM Movie WHERE Release_Date BETWEEN '1990-01-01' AND '2005-12-31';
GO

-- Query #19 [Operator: LIKE]
-- Purpose: Retrieve all customer records whose registered email address is hosted on '@gmail.com'.
SELECT Customer_ID, First_Name, Last_Name, Email, City FROM Customer WHERE Email LIKE '%@gmail.com';
GO

-- Query #20 [Operator: IN]
-- Purpose: List all tuck shop snack items belonging specifically to the categories 'Popcorn', 'Bakery', or 'Combos'.
SELECT Item_ID, Item_Name, Category, Unit_Price, Size_Option FROM Tuck_Shop WHERE Category IN ('Popcorn', 'Bakery', 'Combos');
GO

-- Query #21 [Operator: ORDER BY]
-- Purpose: List all movies in the cinema database sorted from highest to lowest IMDb rating.
SELECT Movie_ID, Title, Genre, IMDb_Rating, Duration_Minutes FROM Movie WHERE Status = 'Archived' ORDER BY IMDb_Rating DESC;
GO

-- Query #22 [Operator: AND with < and >]
-- Purpose: Find high-tier showtimes with base price between 1000 and 2000 PKR hosted in 'IMAX 3D' format.
SELECT Show_ID, Movie_ID, Screen_ID, Base_Price, Show_Format, Available_Seats FROM Showtime WHERE Base_Price > 1000.00 AND Base_Price < 2000.00 AND Show_Format = 'IMAX 3D';
GO

-- Query #23 [Operator: LIKE with prefix]
-- Purpose: Find all employees whose last name begins with the letter 'A' or 'M'.
SELECT Employee_ID, First_Name, Last_Name, Designation, Department FROM Employee WHERE Last_Name LIKE 'A%' OR Last_Name LIKE 'M%';
GO

-- Query #24 [Operator: NOT IN]
-- Purpose: Find all vehicles parked that are neither motorcycles nor passenger vans.
SELECT Parking_ID, Customer_ID, Slot_Number, Vehicle_Type, License_Plate, Total_Parking_Fee FROM Parking WHERE Vehicle_Type NOT IN ('Motorcycle', 'Van');
GO

-- Query #25 [Operator: DISTINCT with ORDER BY]
-- Purpose: Retrieve all distinct customer membership tiers ordered alphabetically.
SELECT DISTINCT Membership_Type FROM Customer WHERE Is_Active = 1 ORDER BY Membership_Type ASC;
GO

-- Query #26 [Operator: GROUP BY with COUNT and SUM]
-- Purpose: Display total booking count and cumulative net revenue collected per booking channel.
SELECT Booking_Channel, COUNT(Booking_ID) AS Total_Bookings, SUM(Net_Payable) AS Total_Revenue_PKR FROM Booking WHERE Booking_Status = 'Confirmed' GROUP BY Booking_Channel;
GO

-- Query #27 [Operator: HAVING with COUNT]
-- Purpose: Identify cinema screen halls that host at least 1 active scheduled showtime.
SELECT Screen_ID, COUNT(Show_ID) AS Total_Scheduled_Shows FROM Showtime GROUP BY Screen_ID HAVING COUNT(Show_ID) >= 1;
GO

-- Query #28 [Operator: BETWEEN with AND]
-- Purpose: Retrieve vehicle parking sessions where parked duration was between 2.0 and 4.0 hours in parking Zone 'A'.
SELECT Parking_ID, Slot_Number, Vehicle_Type, Parked_Duration_Hours, Total_Parking_Fee FROM Parking WHERE (Parked_Duration_Hours BETWEEN 2.0 AND 4.0) AND Parking_Bay_Zone = 'A';
GO

-- Query #29 [Operator: + with profit threshold]
-- Purpose: Identify tuck shop items offering a gross profit margin of over 200 PKR per unit (Unit_Price > Cost_Price + 200).
SELECT Item_ID, Item_Name, Unit_Price, Cost_Price, (Unit_Price - Cost_Price) AS Profit_Margin FROM Tuck_Shop WHERE Unit_Price > (Cost_Price + 200.00);
GO

-- Query #30 [Operator: != with ORDER BY]
-- Purpose: List all active screens that are not 'IMAX' format, sorted by seating capacity in descending order.
SELECT Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Row_Count FROM Screen WHERE Screen_Type != 'IMAX' AND Is_Active = 1 ORDER BY Total_Capacity DESC;
GO

-- ==========================================================================
-- 8.3 SQL JOINS DEMONSTRATION (At least 2 queries for each type of join)
-- Types: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, CROSS JOIN, SELF JOIN
-- ==========================================================================

-- Join Query #1 [Type: INNER JOIN]
-- Purpose: INNER JOIN Query 1: Retrieve customer personal details alongside their confirmed booking IDs, seats booked, and total payable.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Email, b.Booking_ID, b.Total_Seats_Booked, b.Net_Payable, b.Booking_Channel FROM Customer c INNER JOIN Booking b ON c.Customer_ID = b.Customer_ID WHERE b.Booking_Status = 'Confirmed';
GO

-- Join Query #2 [Type: INNER JOIN]
-- Purpose: INNER JOIN Query 2: Retrieve detailed showtime schedule displaying movie title, genre, screen name, show date, and format.
SELECT s.Show_ID, m.Title AS Movie_Title, m.Genre, sc.Screen_Name, sc.Screen_Type, s.Show_Date, s.Start_Time, s.Base_Price, s.Show_Format FROM Showtime s INNER JOIN Movie m ON s.Movie_ID = m.Movie_ID INNER JOIN Screen sc ON s.Screen_ID = sc.Screen_ID WHERE s.Show_Status IN ('Scheduled', 'Completed');
GO

-- Join Query #3 [Type: LEFT JOIN]
-- Purpose: LEFT JOIN Query 1: List all customers and any movie reviews they have authored, including customers who haven't reviewed yet.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type, r.Review_ID, r.Rating_Stars, r.Review_Title FROM Customer c LEFT JOIN Movie_Review r ON c.Customer_ID = r.Customer_ID;
GO

-- Join Query #4 [Type: LEFT JOIN]
-- Purpose: LEFT JOIN Query 2: Display all cinema screens and their scheduled showtimes, including screens currently without a scheduled movie.
SELECT sc.Screen_ID, sc.Screen_Name, sc.Screen_Type, sc.Total_Capacity, sh.Show_ID, sh.Show_Date, sh.Base_Price FROM Screen sc LEFT JOIN Showtime sh ON sc.Screen_ID = sh.Screen_ID WHERE sc.Screen_ID <= 40;
GO

-- Join Query #5 [Type: RIGHT JOIN]
-- Purpose: RIGHT JOIN Query 1: Ensure all booking records are returned along with customer contact data.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, b.Booking_ID, b.Booking_Timestamp, b.Net_Payable, b.Payment_Status FROM Customer c RIGHT JOIN Booking b ON c.Customer_ID = b.Customer_ID;
GO

-- Join Query #6 [Type: RIGHT JOIN]
-- Purpose: RIGHT JOIN Query 2: Display all concession orders processed alongside employee staff details responsible for the counter.
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Designation, co.Order_ID, co.Total_Items_Count, co.Total_Payable, co.Payment_Method FROM Employee e RIGHT JOIN Concession_Order co ON e.Employee_ID = co.Employee_ID;
GO

-- Join Query #7 [Type: FULL OUTER JOIN]
-- Purpose: FULL OUTER JOIN Query 1: Retrieve complete record set of customers and vehicle parking logs to identify both parking-only visitors and transit patrons.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, p.Parking_ID, p.Slot_Number, p.Vehicle_Type, p.Total_Parking_Fee FROM Customer c FULL OUTER JOIN Parking p ON c.Customer_ID = p.Customer_ID;
GO

-- Join Query #8 [Type: FULL OUTER JOIN]
-- Purpose: FULL OUTER JOIN Query 2: Cross-check security guards and inspection checkpoint logs to audit staff assignment coverage.
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Department, sc.Checkpoint_ID, sc.Gate_Name, sc.Pass_Status FROM Employee e FULL OUTER JOIN Security_Checkpoint sc ON e.Employee_ID = sc.Guard_Employee_ID;
GO

-- Join Query #9 [Type: CROSS JOIN]
-- Purpose: CROSS JOIN Query 1: Generate a hypothetical matrix pairing the top 3 feature films against 3 distinct screen technology types.
SELECT m.Title AS Movie_Title, sc.Screen_Type, sc.Sound_System FROM (SELECT Movie_ID, Title FROM Movie WHERE Movie_ID <= 3) m CROSS JOIN (SELECT DISTINCT Screen_Type, Sound_System FROM Screen WHERE Screen_Type IN ('IMAX', 'Gold_Class', 'Silver_Economy')) sc;
GO

-- Join Query #10 [Type: CROSS JOIN]
-- Purpose: CROSS JOIN Query 2: Create a combination matrix of distinct customer membership tiers and concession snack sizes for promotional bundle planning.
SELECT m.Membership_Type, s.Size_Option FROM (SELECT DISTINCT Membership_Type FROM Customer WHERE Membership_Type IN ('Regular', 'Gold', 'VIP')) m CROSS JOIN (SELECT DISTINCT Size_Option FROM Tuck_Shop WHERE Size_Option IN ('Small', 'Regular', 'Large')) s;
GO

-- Join Query #11 [Type: SELF JOIN]
-- Purpose: SELF JOIN Query 1: Find pairs of employees working within the exact same department and sharing the same shift timing.
SELECT A.Employee_ID AS Emp1_ID, (A.First_Name || ' ' || A.Last_Name) AS Emp1_Name, B.Employee_ID AS Emp2_ID, (B.First_Name || ' ' || B.Last_Name) AS Emp2_Name, A.Department, A.Shift_Timing FROM Employee A INNER JOIN Employee B ON A.Department = B.Department AND A.Shift_Timing = B.Shift_Timing AND A.Employee_ID < B.Employee_ID;
GO

-- Join Query #12 [Type: SELF JOIN]
-- Purpose: SELF JOIN Query 2: Find pairs of movies that share the exact same genre but have different runtimes.
SELECT A.Movie_ID AS Movie1_ID, A.Title AS Movie1_Title, B.Movie_ID AS Movie2_ID, B.Title AS Movie2_Title, A.Genre, A.Duration_Minutes AS Duration1, B.Duration_Minutes AS Duration2 FROM Movie A INNER JOIN Movie B ON A.Genre = B.Genre AND A.Movie_ID < B.Movie_ID AND A.Duration_Minutes <> B.Duration_Minutes WHERE A.Genre = 'Action';
GO

-- ==========================================================================
-- 8.4 SQL SUBQUERIES DEMONSTRATION (20 Distinct Subqueries)
-- Types: Single-row, Multiple-row (IN/NOT IN), Nested, Correlated,
-- EXISTS/NOT EXISTS, ANY/ALL, Scalar in SELECT, Derived Table in FROM
-- ==========================================================================

-- Subquery #1 [Type: Single-row Subquery]
-- Purpose: Find the movie that achieved the single highest worldwide box office revenue.
SELECT Movie_ID, Title, Director, Box_Office_Revenue FROM Movie WHERE Box_Office_Revenue = (SELECT MAX(Box_Office_Revenue) FROM Movie);
GO

-- Subquery #2 [Type: Single-row Subquery]
-- Purpose: Find all cinema employees whose monthly salary is greater than the overall cinema average monthly salary.
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary > (SELECT AVG(Monthly_Salary) FROM Employee);
GO

-- Subquery #3 [Type: Single-row Subquery]
-- Purpose: Identify the top loyalty customer who holds the absolute maximum number of loyalty points.
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type, Loyalty_Points FROM Customer WHERE Loyalty_Points = (SELECT MAX(Loyalty_Points) FROM Customer);
GO

-- Subquery #4 [Type: Multiple-row Subquery (IN)]
-- Purpose: Retrieve details of all customers who have booked tickets for any movie directed by 'Christopher Nolan'.
SELECT Customer_ID, First_Name, Last_Name, Email, Membership_Type FROM Customer WHERE Customer_ID IN (SELECT b.Customer_ID FROM Booking b INNER JOIN Showtime s ON b.Show_ID = s.Show_ID WHERE s.Movie_ID IN (SELECT Movie_ID FROM Movie WHERE Director = 'Christopher Nolan'));
GO

-- Subquery #5 [Type: Multiple-row Subquery (NOT IN)]
-- Purpose: Retrieve all tuck shop concession items that have never been ordered in any concession transaction.
SELECT Item_ID, Item_Name, Category, Unit_Price, Stock_Quantity FROM Tuck_Shop WHERE Item_ID NOT IN (SELECT DISTINCT Item_ID FROM Concession_Item_Order);
GO

-- Subquery #6 [Type: Multiple-row Subquery (IN)]
-- Purpose: Find all screens currently hosting scheduled showtimes priced above 1500 PKR.
SELECT Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Sound_System FROM Screen WHERE Screen_ID IN (SELECT Screen_ID FROM Showtime WHERE Base_Price > 1500.00);
GO

-- Subquery #7 [Type: Nested Subquery]
-- Purpose: Retrieve movies whose duration exceeds the average duration of all movies in the 'Sci-Fi' genre.
SELECT Movie_ID, Title, Genre, Duration_Minutes, Director FROM Movie WHERE Duration_Minutes > (SELECT AVG(Duration_Minutes) FROM Movie WHERE Genre = 'Sci-Fi');
GO

-- Subquery #8 [Type: Nested Subquery]
-- Purpose: Retrieve customer information for the patron who paid the highest single booking amount in the system.
SELECT Customer_ID, First_Name, Last_Name, Email, City FROM Customer WHERE Customer_ID = (SELECT Customer_ID FROM Booking WHERE Net_Payable = (SELECT MAX(Net_Payable) FROM Booking));
GO

-- Subquery #9 [Type: Nested Subquery]
-- Purpose: Find tuck shop items that are priced strictly higher than the average price of items in the 'Beverages' category.
SELECT Item_ID, Item_Name, Category, Unit_Price FROM Tuck_Shop WHERE Unit_Price > (SELECT AVG(Unit_Price) FROM Tuck_Shop WHERE Category = 'Beverages');
GO

-- Subquery #10 [Type: Correlated Subquery]
-- Purpose: Find all movies whose IMDb rating is strictly above the average IMDb rating of movies within the exact same genre.
SELECT m1.Movie_ID, m1.Title, m1.Genre, m1.IMDb_Rating FROM Movie m1 WHERE m1.IMDb_Rating > (SELECT AVG(m2.IMDb_Rating) FROM Movie m2 WHERE m2.Genre = m1.Genre);
GO

-- Subquery #11 [Type: Correlated Subquery]
-- Purpose: Find all employees whose monthly salary exceeds the average monthly salary of their own respective department.
SELECT e1.Employee_ID, e1.First_Name, e1.Last_Name, e1.Department, e1.Monthly_Salary FROM Employee e1 WHERE e1.Monthly_Salary > (SELECT AVG(e2.Monthly_Salary) FROM Employee e2 WHERE e2.Department = e1.Department);
GO

-- Subquery #12 [Type: Correlated Subquery]
-- Purpose: Identify customers whose individual spending on bookings exceeds the average total booking expenditure of all customers.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type FROM Customer c WHERE (SELECT SUM(b.Net_Payable) FROM Booking b WHERE b.Customer_ID = c.Customer_ID) > (SELECT AVG(Net_Payable) FROM Booking);
GO

-- Subquery #13 [Type: Subquery with EXISTS]
-- Purpose: Retrieve all customers who have at least one successfully cleared security screening recorded at a checkpoint.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Email FROM Customer c WHERE EXISTS (SELECT 1 FROM Security_Checkpoint sc WHERE sc.Customer_ID = c.Customer_ID AND sc.Pass_Status = 'Approved');
GO

-- Subquery #14 [Type: Subquery with EXISTS]
-- Purpose: Find screens that have at least one wheelchair accessible seat installed.
SELECT sc.Screen_ID, sc.Screen_Name, sc.Screen_Type, sc.Total_Capacity FROM Screen sc WHERE EXISTS (SELECT 1 FROM Seat st WHERE st.Screen_ID = sc.Screen_ID AND st.Is_Wheelchair_Accessible = 1);
GO

-- Subquery #15 [Type: Subquery with NOT EXISTS]
-- Purpose: Identify registered customers who have never utilized the cinema vehicle parking facility.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.City FROM Customer c WHERE NOT EXISTS (SELECT 1 FROM Parking p WHERE p.Customer_ID = c.Customer_ID);
GO

-- Subquery #16 [Type: Subquery with NOT EXISTS]
-- Purpose: Retrieve movies currently in catalog that have received zero critical ratings below 4 stars.
SELECT m.Movie_ID, m.Title, m.Genre, m.IMDb_Rating FROM Movie m WHERE NOT EXISTS (SELECT 1 FROM Movie_Review r WHERE r.Movie_ID = m.Movie_ID AND r.Rating_Stars < 4);
GO

-- Subquery #17 [Type: Subquery with ANY / SOME]
-- Purpose: Find employees whose salary is greater than the salary of AT LEAST ONE (ANY) employee in the 'Ticketing' department.
SELECT Employee_ID, First_Name, Last_Name, Designation, Department, Monthly_Salary FROM Employee WHERE Monthly_Salary > ANY (SELECT Monthly_Salary FROM Employee WHERE Department = 'Ticketing');
GO

-- Subquery #18 [Type: Subquery with ALL]
-- Purpose: Find movies that earned more in worldwide box office revenue than ALL movies in the 'Animation' category.
SELECT Movie_ID, Title, Genre, Box_Office_Revenue FROM Movie WHERE Box_Office_Revenue > ALL (SELECT Box_Office_Revenue FROM Movie WHERE Genre = 'Animation');
GO

-- Subquery #19 [Type: Scalar Subquery in SELECT]
-- Purpose: Display each customer's basic profile alongside a computed count of total tickets they have booked.
SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Membership_Type, (SELECT COUNT(t.Ticket_ID) FROM Ticket t INNER JOIN Booking b ON t.Booking_ID = b.Booking_ID WHERE b.Customer_ID = c.Customer_ID) AS Total_Tickets_Purchased FROM Customer c WHERE c.Customer_ID <= 15;
GO

-- Subquery #20 [Type: Subquery in FROM clause (Derived Table)]
-- Purpose: From a derived table aggregating sales statistics per booking channel, display channels where average transaction value exceeds 1800 PKR.
SELECT dt.Booking_Channel, dt.Total_Bookings, dt.Total_Revenue, dt.Avg_Booking_Value FROM (SELECT Booking_Channel, COUNT(Booking_ID) AS Total_Bookings, SUM(Net_Payable) AS Total_Revenue, ROUND(AVG(Net_Payable), 2) AS Avg_Booking_Value FROM Booking GROUP BY Booking_Channel) AS dt WHERE dt.Avg_Booking_Value > 1800.00;
GO
