"""
Cinema Management System — Full Stack REST API Backend
Course: CS-311 Database Systems (Term Project)
Backend: Python Flask + raw SQL (pyodbc with embedded SQLite demonstration fallback)
Database: Microsoft SQL Server (CinemaDB_Project)
"""

import os
import json
import sqlite3
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

DB_FILE = os.path.join(os.path.dirname(__file__), "cinema_embedded.db")
SQL_SCRIPT_PATH = os.path.join(os.path.dirname(__file__), "Cinema_Management_System_Final_Complete.sql")
QUERY_RESULTS_FILE = os.path.join(os.path.dirname(__file__), "database_query_results.json")

# Connection Configuration
SQL_SERVER = os.environ.get("DB_SERVER", "localhost")
SQL_DATABASE = os.environ.get("DB_NAME", "CinemaDB_Project")
SQL_DRIVER = os.environ.get("DB_DRIVER", "ODBC Driver 17 for SQL Server")

USE_EMBEDDED = False

def init_embedded_db():
    """Initializes embedded SQLite database if SQL Server is not reachable."""
    global USE_EMBEDDED
    USE_EMBEDDED = True
    if not os.path.exists(DB_FILE):
        print("[DATABASE] Creating embedded SQLite database with complete 680+ tuples...")
        try:
            import sys
            sys.path.append(r"C:\Users\hp\.gemini\antigravity\brain\2127dc80-57c7-4ba4-a5c2-32469f5a1901\scratch")
            from generate_full_project import (
                customers, phones, movies, screens, imax_screens, gold_screens,
                premium_screens, silver_screens, showtimes, seats, bookings,
                tickets, employees, concession_items, concession_orders,
                concession_item_orders, parking_records, checkpoints, reviews
            )
            conn = sqlite3.connect(DB_FILE)
            cur = conn.cursor()
            
            # Create tables
            cur.executescript("""
            CREATE TABLE Customer (
                Customer_ID INTEGER PRIMARY KEY, First_Name TEXT NOT NULL, Last_Name TEXT NOT NULL,
                Email TEXT NOT NULL UNIQUE, Gender TEXT NOT NULL, Date_Of_Birth TEXT NOT NULL,
                Membership_Type TEXT NOT NULL, Registration_Date TEXT NOT NULL, Loyalty_Points INTEGER NOT NULL,
                City TEXT NOT NULL, Postal_Code TEXT NOT NULL, Is_Active INTEGER NOT NULL DEFAULT 1
            );
            CREATE TABLE Phone_Number (
                Phone_Num TEXT NOT NULL, Customer_ID INTEGER NOT NULL, Phone_Type TEXT NOT NULL DEFAULT 'Mobile',
                Country_Code TEXT NOT NULL DEFAULT '+92', Telecom_Carrier TEXT NOT NULL DEFAULT 'Jazz',
                Is_Primary INTEGER NOT NULL DEFAULT 1, Is_WhatsApp_Enabled INTEGER NOT NULL DEFAULT 1,
                Verification_Status TEXT NOT NULL DEFAULT 'Verified', SMS_Promo_OptIn INTEGER NOT NULL DEFAULT 1,
                Added_Date TEXT NOT NULL,
                PRIMARY KEY (Phone_Num, Customer_ID)
            );
            CREATE TABLE Movie (
                Movie_ID INTEGER PRIMARY KEY, Title TEXT NOT NULL, Genre TEXT NOT NULL, Duration_Minutes INTEGER NOT NULL,
                Release_Date TEXT NOT NULL, Language TEXT NOT NULL, Director TEXT NOT NULL, Age_Rating TEXT NOT NULL,
                IMDb_Rating REAL NOT NULL, Production_Budget REAL NOT NULL, Box_Office_Revenue REAL NOT NULL,
                Status TEXT NOT NULL DEFAULT 'Now Showing'
            );
            CREATE TABLE Screen (
                Screen_ID INTEGER PRIMARY KEY, Screen_Name TEXT NOT NULL UNIQUE, Screen_Type TEXT NOT NULL,
                Total_Capacity INTEGER NOT NULL, Row_Count INTEGER NOT NULL, Seats_Per_Row INTEGER NOT NULL,
                Sound_System TEXT NOT NULL, Projector_Model TEXT NOT NULL, Screen_Width_Feet REAL NOT NULL,
                Screen_Height_Feet REAL NOT NULL, Cleaning_Status TEXT NOT NULL DEFAULT 'Clean',
                Is_Active INTEGER NOT NULL DEFAULT 1
            );
            CREATE TABLE IMAXScreen (
                Screen_ID INTEGER PRIMARY KEY, Laser_Projection_Type TEXT NOT NULL, Aspect_Ratio TEXT NOT NULL,
                Dual_Laser_3D INTEGER NOT NULL, Curved_Angle_Degrees REAL NOT NULL, Audio_Channel_Count INTEGER NOT NULL,
                Max_Screen_Luminance_Nits INTEGER NOT NULL, HFR_Supported INTEGER NOT NULL,
                Calibration_Frequency_Days INTEGER NOT NULL, Commercial_License_Code TEXT NOT NULL UNIQUE
            );
            CREATE TABLE GoldScreen (
                Screen_ID INTEGER PRIMARY KEY, Lounge_Service_Type TEXT NOT NULL, Recliner_Model TEXT NOT NULL,
                Butler_Service_Enabled INTEGER NOT NULL, Complimentary_Snack_Tier TEXT NOT NULL, Call_Button_Active INTEGER NOT NULL,
                USB_Charging_Speed_Watts INTEGER NOT NULL, Legrest_Angle_Max INTEGER NOT NULL,
                Pillow_Blanket_Provided INTEGER NOT NULL, Lounge_Access_Code TEXT NOT NULL UNIQUE
            );
            CREATE TABLE PremiumScreen (
                Screen_ID INTEGER PRIMARY KEY, Luxury_Level TEXT NOT NULL, Private_Balcony_Seats INTEGER NOT NULL,
                Wine_Bar_Access INTEGER NOT NULL, VIP_Restroom_Access INTEGER NOT NULL, Heated_Seats INTEGER NOT NULL,
                Acoustic_Damping_Rating TEXT NOT NULL, Coat_Check_Available INTEGER NOT NULL,
                Concierge_Desk_Station TEXT NOT NULL, Noise_Isolation_Db INTEGER NOT NULL
            );
            CREATE TABLE SilverScreen (
                Screen_ID INTEGER PRIMARY KEY, Discount_Tier_Percent INTEGER NOT NULL, Economy_Bundle_Eligible INTEGER NOT NULL,
                Student_Pass_Accepted INTEGER NOT NULL, Group_Discount_Active INTEGER NOT NULL, Free_Refill_Eligible INTEGER NOT NULL,
                Aisle_Ramp_Access INTEGER NOT NULL, Booster_Seat_Quantity INTEGER NOT NULL,
                Bulk_Ticket_Eligible INTEGER NOT NULL, Matinee_Discount_Rate REAL NOT NULL
            );
            CREATE TABLE Showtime (
                Show_ID INTEGER PRIMARY KEY, Movie_ID INTEGER NOT NULL, Screen_ID INTEGER NOT NULL,
                Show_Date TEXT NOT NULL, Start_Time TEXT NOT NULL, End_Time TEXT NOT NULL,
                Base_Price REAL NOT NULL, Show_Format TEXT NOT NULL, Available_Seats INTEGER NOT NULL,
                Audio_Language TEXT NOT NULL, Subtitle_Language TEXT NOT NULL, Show_Status TEXT NOT NULL
            );
            CREATE TABLE Seat (
                Seat_ID INTEGER PRIMARY KEY, Screen_ID INTEGER NOT NULL, Row_Letter TEXT NOT NULL,
                Seat_Number INTEGER NOT NULL, Seat_Code TEXT NOT NULL, Seat_Class TEXT NOT NULL,
                Price_Multiplier REAL NOT NULL, Is_Wheelchair_Accessible INTEGER NOT NULL,
                Is_Reserved INTEGER NOT NULL, Maintenance_Status TEXT NOT NULL, Vibration_Supported INTEGER NOT NULL, Seat_Color TEXT NOT NULL
            );
            CREATE TABLE Booking (
                Booking_ID INTEGER PRIMARY KEY, Customer_ID INTEGER NOT NULL, Show_ID INTEGER NOT NULL,
                Booking_Timestamp TEXT NOT NULL, Total_Seats_Booked INTEGER NOT NULL, Total_Amount REAL NOT NULL,
                Discount_Amount REAL NOT NULL, Tax_Amount REAL NOT NULL, Net_Payable REAL NOT NULL,
                Booking_Status TEXT NOT NULL, Payment_Status TEXT NOT NULL, Booking_Channel TEXT NOT NULL
            );
            CREATE TABLE Ticket (
                Ticket_ID INTEGER PRIMARY KEY, Booking_ID INTEGER NOT NULL, Seat_ID INTEGER NOT NULL,
                Ticket_Number TEXT NOT NULL UNIQUE, Barcode_Number TEXT NOT NULL UNIQUE, Ticket_Type TEXT NOT NULL,
                Base_Price REAL NOT NULL, Final_Price REAL NOT NULL, Is_Validated INTEGER NOT NULL,
                Validation_Time TEXT, Checkin_Gate TEXT NOT NULL, Print_Count INTEGER NOT NULL
            );
            CREATE TABLE Employee (
                Employee_ID INTEGER PRIMARY KEY, First_Name TEXT NOT NULL, Last_Name TEXT NOT NULL,
                CNIC TEXT NOT NULL UNIQUE, Designation TEXT NOT NULL, Department TEXT NOT NULL,
                Monthly_Salary REAL NOT NULL, Shift_Timing TEXT NOT NULL, Hire_Date TEXT NOT NULL,
                Emergency_Contact TEXT NOT NULL, Performance_Rating REAL NOT NULL, Employment_Status TEXT NOT NULL
            );
            CREATE TABLE Tuck_Shop (
                Item_ID INTEGER PRIMARY KEY, Item_Name TEXT NOT NULL, Category TEXT NOT NULL,
                Size_Option TEXT NOT NULL, Unit_Price REAL NOT NULL, Cost_Price REAL NOT NULL,
                Stock_Quantity INTEGER NOT NULL, Reorder_Level INTEGER NOT NULL, Supplier_Name TEXT NOT NULL,
                Calories_Kcal INTEGER NOT NULL, Is_Available INTEGER NOT NULL, Expiry_Date TEXT NOT NULL
            );
            CREATE TABLE Concession_Order (
                Order_ID INTEGER PRIMARY KEY, Customer_ID INTEGER, Employee_ID INTEGER NOT NULL,
                Order_Timestamp TEXT NOT NULL, Total_Items_Count INTEGER NOT NULL, Subtotal_Amount REAL NOT NULL,
                Sales_Tax REAL NOT NULL, Discount_Given REAL NOT NULL, Total_Payable REAL NOT NULL,
                Payment_Method TEXT NOT NULL, Counter_Number INTEGER NOT NULL, Order_Status TEXT NOT NULL
            );
            CREATE TABLE Concession_Item_Order (
                Order_ID INTEGER NOT NULL, Item_ID INTEGER NOT NULL, Quantity INTEGER NOT NULL,
                Unit_Price_Charged REAL NOT NULL, Discount_Applied REAL NOT NULL, Tax_Amount REAL NOT NULL,
                Subtotal REAL NOT NULL, Preparation_Status TEXT NOT NULL, Special_Instructions TEXT NOT NULL,
                Dispensed_Timestamp TEXT NOT NULL,
                PRIMARY KEY (Order_ID, Item_ID)
            );
            CREATE TABLE Parking (
                Parking_ID INTEGER PRIMARY KEY, Customer_ID INTEGER, Slot_Number TEXT NOT NULL,
                Vehicle_Type TEXT NOT NULL, License_Plate TEXT NOT NULL, Entry_Time TEXT NOT NULL,
                Exit_Time TEXT, Parked_Duration_Hours REAL NOT NULL, Hourly_Rate REAL NOT NULL,
                Total_Parking_Fee REAL NOT NULL, Parking_Bay_Zone TEXT NOT NULL, Payment_Status TEXT NOT NULL
            );
            CREATE TABLE Security_Checkpoint (
                Checkpoint_ID INTEGER PRIMARY KEY, Gate_Name TEXT NOT NULL, Guard_Employee_ID INTEGER NOT NULL,
                Customer_ID INTEGER NOT NULL, Ticket_ID INTEGER NOT NULL, Inspection_Timestamp TEXT NOT NULL,
                Luggage_Scanned INTEGER NOT NULL, Metal_Detector_Cleared INTEGER NOT NULL, Pass_Status TEXT NOT NULL,
                Supervisor_Notified INTEGER NOT NULL, Remarks TEXT NOT NULL, Scanner_Device_ID TEXT NOT NULL
            );
            CREATE TABLE Movie_Review (
                Review_ID INTEGER PRIMARY KEY, Customer_ID INTEGER NOT NULL, Movie_ID INTEGER NOT NULL,
                Rating_Stars INTEGER NOT NULL, Review_Title TEXT NOT NULL, Review_Text TEXT NOT NULL,
                Review_Date TEXT NOT NULL, Helpful_Votes INTEGER NOT NULL, Is_Verified_Watcher INTEGER NOT NULL,
                Sentiment_Tag TEXT NOT NULL, Platform_Used TEXT NOT NULL, Moderation_Status TEXT NOT NULL
            );
            """)

            cur.executemany("INSERT INTO Customer VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", customers)
            cur.executemany("INSERT INTO Phone_Number VALUES (?,?,?,?,?)", phones)
            cur.executemany("INSERT INTO Movie VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", movies)
            cur.executemany("INSERT INTO Screen VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", screens)
            cur.executemany("INSERT INTO IMAXScreen VALUES (?,?,?,?,?,?)", imax_screens)
            cur.executemany("INSERT INTO GoldScreen VALUES (?,?,?,?,?,?)", gold_screens)
            cur.executemany("INSERT INTO PremiumScreen VALUES (?,?,?,?,?,?)", premium_screens)
            cur.executemany("INSERT INTO SilverScreen VALUES (?,?,?,?,?,?)", silver_screens)
            cur.executemany("INSERT INTO Showtime VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", showtimes)
            cur.executemany("INSERT INTO Seat VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", seats)
            cur.executemany("INSERT INTO Booking VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", bookings)
            cur.executemany("INSERT INTO Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", tickets)
            cur.executemany("INSERT INTO Employee VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", employees)
            cur.executemany("INSERT INTO Tuck_Shop VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", concession_items)
            cur.executemany("INSERT INTO Concession_Order VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", concession_orders)
            cur.executemany("INSERT INTO Concession_Item_Order VALUES (?,?,?,?,?,?)", concession_item_orders)
            cur.executemany("INSERT INTO Parking VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", parking_records)
            cur.executemany("INSERT INTO Security_Checkpoint VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", checkpoints)
            cur.executemany("INSERT INTO Movie_Review VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", reviews)
            
            conn.commit()
            conn.close()
            print("[DATABASE] Embedded database successfully created and populated!")
        except Exception as e:
            print(f"[NOTICE] Embedded DB init error: {e}")

def get_db_connection():
    """Returns database connection (SQL Server if reachable, else embedded SQLite)."""
    global USE_EMBEDDED
    if not USE_EMBEDDED:
        try:
            import pyodbc
            conn_str = (
                f"DRIVER={{{SQL_DRIVER}}};"
                f"SERVER={SQL_SERVER};"
                f"DATABASE={SQL_DATABASE};"
                "Trusted_Connection=yes;"
                "TrustServerCertificate=yes;"
            )
            conn = pyodbc.connect(conn_str, timeout=2)
            return conn, "MSSQL"
        except Exception:
            USE_EMBEDDED = True
            init_embedded_db()
            print(f"[NOTICE] SQL Server '{SQL_SERVER}' not reachable. Using Embedded Demonstration Database.")
    
    if not os.path.exists(DB_FILE):
        init_embedded_db()
        
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    return conn, "SQLITE"

# -------------------------------------------------------------
# REST API ENDPOINTS
# -------------------------------------------------------------

@app.route("/")
def home():
    return jsonify({
        "project": "Cinema Management System API",
        "author": "Talha Sarfraz (SAP ID: 70150006) & Group",
        "course": "BSCS CS-311 Database Systems",
        "institution": "The University of Lahore",
        "status": "Online",
        "database": "Embedded SQLite / Microsoft SQL Server CinemaDB_Project"
    })

# CUSTOMERS
@app.route("/api/customers", methods=["GET"])
def get_customers():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT c.Customer_ID, c.First_Name, c.Last_Name, c.Email, c.Gender, 
                   c.Date_Of_Birth, c.Membership_Type, c.Loyalty_Points, c.City, c.Postal_Code, c.Is_Active
            FROM Customer c
            ORDER BY c.Customer_ID ASC
        """)
        rows = cur.fetchall()
        
        cur.execute("SELECT Customer_ID, Phone_Num, Phone_Type FROM Phone_Number")
        phone_rows = cur.fetchall()
        phone_map = {}
        for pr in phone_rows:
            cid = pr[0] if engine == "MSSQL" else pr["Customer_ID"]
            pnum = pr[1] if engine == "MSSQL" else pr["Phone_Num"]
            phone_map.setdefault(cid, []).append(pnum)
            
        customers = []
        for r in rows:
            if engine == "MSSQL":
                cid = r[0]
                customers.append({
                    "id": cid, "first_name": r[1], "last_name": r[2], "name": f"{r[1]} {r[2]}",
                    "email": r[3], "gender": r[4], "dob": str(r[5]), "membership": r[6],
                    "loyalty_points": r[7], "city": r[8], "postal_code": r[9], "is_active": bool(r[10]),
                    "phones": phone_map.get(cid, [])
                })
            else:
                cid = r["Customer_ID"]
                customers.append({
                    "id": cid, "first_name": r["First_Name"], "last_name": r["Last_Name"], "name": f"{r['First_Name']} {r['Last_Name']}",
                    "email": r["Email"], "gender": r["Gender"], "dob": str(r["Date_Of_Birth"]), "membership": r["Membership_Type"],
                    "loyalty_points": r["Loyalty_Points"], "city": r["City"], "postal_code": r["Postal_Code"], "is_active": bool(r["Is_Active"]),
                    "phones": phone_map.get(cid, [])
                })
        conn.close()
        return jsonify(customers)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# MOVIES
@app.route("/api/movies", methods=["GET"])
def get_movies():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT Movie_ID, Title, Genre, Duration_Minutes, Release_Date, Language,
                   Director, Age_Rating, IMDb_Rating, Production_Budget, Box_Office_Revenue, Status
            FROM Movie
            ORDER BY Movie_ID ASC
        """)
        rows = cur.fetchall()
        movies = []
        for r in rows:
            if engine == "MSSQL":
                movies.append({
                    "id": r[0], "title": r[1], "genre": r[2], "duration": r[3],
                    "release_date": str(r[4]), "language": r[5], "director": r[6],
                    "age_rating": r[7], "imdb_rating": float(r[8]),
                    "budget": float(r[9]), "revenue": float(r[10]), "status": r[11]
                })
            else:
                movies.append({
                    "id": r["Movie_ID"], "title": r["Title"], "genre": r["Genre"], "duration": r["Duration_Minutes"],
                    "release_date": str(r["Release_Date"]), "language": r["Language"], "director": r["Director"],
                    "age_rating": r["Age_Rating"], "imdb_rating": float(r["IMDb_Rating"]),
                    "budget": float(r["Production_Budget"]), "revenue": float(r["Box_Office_Revenue"]), "status": r["Status"]
                })
        conn.close()
        return jsonify(movies)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# SCREENS (EER SUPERCLASS)
@app.route("/api/screens", methods=["GET"])
def get_screens():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT Screen_ID, Screen_Name, Screen_Type, Total_Capacity, Row_Count,
                   Seats_Per_Row, Sound_System, Projector_Model, Screen_Width_Feet,
                   Screen_Height_Feet, Cleaning_Status, Is_Active
            FROM Screen
            ORDER BY Screen_ID ASC
        """)
        rows = cur.fetchall()
        screens = []
        for r in rows:
            if engine == "MSSQL":
                screens.append({
                    "id": r[0], "name": r[1], "type": r[2], "capacity": r[3],
                    "rows": r[4], "seats_per_row": r[5], "sound": r[6],
                    "projector": r[7], "width": float(r[8]), "height": float(r[9]),
                    "status": r[10], "is_active": bool(r[11])
                })
            else:
                screens.append({
                    "id": r["Screen_ID"], "name": r["Screen_Name"], "type": r["Screen_Type"], "capacity": r["Total_Capacity"],
                    "rows": r["Row_Count"], "seats_per_row": r["Seats_Per_Row"], "sound": r["Sound_System"],
                    "projector": r["Projector_Model"], "width": float(r["Screen_Width_Feet"]), "height": float(r["Screen_Height_Feet"]),
                    "status": r["Cleaning_Status"], "is_active": bool(r["Is_Active"])
                })
        conn.close()
        return jsonify(screens)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# BOOKINGS
@app.route("/api/bookings", methods=["GET"])
def get_bookings():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT b.Booking_ID, (c.First_Name || ' ' || c.Last_Name) AS Customer_Name,
                   m.Title AS Movie_Title, sc.Screen_Name, b.Booking_Timestamp,
                   b.Total_Seats_Booked, b.Total_Amount, b.Discount_Amount, b.Tax_Amount,
                   b.Net_Payable, b.Booking_Status, b.Payment_Status, b.Booking_Channel
            FROM Booking b
            JOIN Customer c ON b.Customer_ID = c.Customer_ID
            JOIN Showtime s ON b.Show_ID = s.Show_ID
            JOIN Movie m ON s.Movie_ID = m.Movie_ID
            JOIN Screen sc ON s.Screen_ID = sc.Screen_ID
            ORDER BY b.Booking_ID DESC
        """)
        rows = cur.fetchall()
        bookings = []
        for r in rows:
            if engine == "MSSQL":
                bookings.append({
                    "id": r[0], "customer": r[1], "movie": r[2], "screen": r[3],
                    "timestamp": str(r[4]), "seats": r[5], "amount": float(r[6]),
                    "discount": float(r[7]), "tax": float(r[8]), "net": float(r[9]),
                    "status": r[10], "payment": r[11], "channel": r[12]
                })
            else:
                bookings.append({
                    "id": r["Booking_ID"], "customer": r["Customer_Name"], "movie": r["Movie_Title"], "screen": r["Screen_Name"],
                    "timestamp": str(r["Booking_Timestamp"]), "seats": r["Total_Seats_Booked"], "amount": float(r["Total_Amount"]),
                    "discount": float(r["Discount_Amount"]), "tax": float(r["Tax_Amount"]), "net": float(r["Net_Payable"]),
                    "status": r["Booking_Status"], "payment": r["Payment_Status"], "channel": r["Booking_Channel"]
                })
        conn.close()
        return jsonify(bookings)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# TUCK SHOP (CONCESSIONS)
@app.route("/api/tuckshop", methods=["GET"])
def get_tuckshop():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT Item_ID, Item_Name, Category, Size_Option, Unit_Price, Cost_Price,
                   Stock_Quantity, Reorder_Level, Supplier_Name, Calories_Kcal, Is_Available, Expiry_Date
            FROM Tuck_Shop
            ORDER BY Item_ID ASC
        """)
        rows = cur.fetchall()
        items = []
        for r in rows:
            if engine == "MSSQL":
                items.append({
                    "id": r[0], "name": r[1], "category": r[2], "size": r[3],
                    "price": float(r[4]), "cost": float(r[5]), "stock": r[6],
                    "reorder": r[7], "supplier": r[8], "calories": r[9],
                    "available": bool(r[10]), "expiry": str(r[11])
                })
            else:
                items.append({
                    "id": r["Item_ID"], "name": r["Item_Name"], "category": r["Category"], "size": r["Size_Option"],
                    "price": float(r["Unit_Price"]), "cost": float(r["Cost_Price"]), "stock": r["Stock_Quantity"],
                    "reorder": r["Reorder_Level"], "supplier": r["Supplier_Name"], "calories": r["Calories_Kcal"],
                    "available": bool(r["Is_Available"]), "expiry": str(r["Expiry_Date"])
                })
        conn.close()
        return jsonify(items)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# PARKING
@app.route("/api/parking", methods=["GET"])
def get_parking():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT Parking_ID, Customer_ID, Slot_Number, Vehicle_Type, License_Plate,
                   Entry_Time, Exit_Time, Parked_Duration_Hours, Hourly_Rate, Total_Parking_Fee,
                   Parking_Bay_Zone, Payment_Status
            FROM Parking
            ORDER BY Parking_ID DESC
        """)
        rows = cur.fetchall()
        parking = []
        for r in rows:
            if engine == "MSSQL":
                parking.append({
                    "id": r[0], "customer_id": r[1], "slot": r[2], "vehicle_type": r[3],
                    "plate": r[4], "entry": str(r[5]), "exit": str(r[6]),
                    "duration": float(r[7]), "rate": float(r[8]), "fee": float(r[9]),
                    "zone": r[10], "status": r[11]
                })
            else:
                parking.append({
                    "id": r["Parking_ID"], "customer_id": r["Customer_ID"], "slot": r["Slot_Number"], "vehicle_type": r["Vehicle_Type"],
                    "plate": r["License_Plate"], "entry": str(r["Entry_Time"]), "exit": str(r["Exit_Time"]),
                    "duration": float(r["Parked_Duration_Hours"]), "rate": float(r["Hourly_Rate"]), "fee": float(r["Total_Parking_Fee"]),
                    "zone": r["Parking_Bay_Zone"], "status": r["Payment_Status"]
                })
        conn.close()
        return jsonify(parking)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# EMPLOYEES
@app.route("/api/employees", methods=["GET"])
def get_employees():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT Employee_ID, First_Name, Last_Name, CNIC, Designation, Department,
                   Monthly_Salary, Shift_Timing, Hire_Date, Emergency_Contact, Performance_Rating, Employment_Status
            FROM Employee
            ORDER BY Employee_ID ASC
        """)
        rows = cur.fetchall()
        employees = []
        for r in rows:
            if engine == "MSSQL":
                employees.append({
                    "id": r[0], "name": f"{r[1]} {r[2]}", "cnic": r[3], "designation": r[4],
                    "department": r[5], "salary": float(r[6]), "shift": r[7],
                    "hire_date": str(r[8]), "contact": r[9], "rating": float(r[10]), "status": r[11]
                })
            else:
                employees.append({
                    "id": r["Employee_ID"], "name": f"{r['First_Name']} {r['Last_Name']}", "cnic": r["CNIC"],
                    "designation": r["Designation"], "department": r["Department"], "salary": float(r["Monthly_Salary"]),
                    "shift": r["Shift_Timing"], "hire_date": str(r["Hire_Date"]), "contact": r["Emergency_Contact"],
                    "rating": float(r["Performance_Rating"]), "status": r["Employment_Status"]
                })
        conn.close()
        return jsonify(employees)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# SQL EXECUTOR FOR EVALUATORS
@app.route("/api/sql/execute", methods=["POST"])
def execute_sql():
    try:
        data = request.json or {}
        query = data.get("query", "").strip()
        if not query:
            return jsonify({"error": "Empty SQL query"}), 400
            
        conn, engine = get_db_connection()
        cur = conn.cursor()
        cur.execute(query)
        
        if cur.description:
            cols = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            result_rows = []
            for r in rows:
                result_rows.append([str(x) if x is not None else "NULL" for x in r])
            conn.close()
            return jsonify({
                "success": True, "engine": engine, "columns": cols,
                "rows": result_rows, "total_rows": len(result_rows)
            })
        else:
            conn.commit()
            conn.close()
            return jsonify({"success": True, "engine": engine, "message": "Command executed successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# PRELOADED QUERIES (30 WHERE, 12 JOINS, 20 SUBQUERIES)
@app.route("/api/queries/catalog", methods=["GET"])
def get_query_catalog():
    try:
        with open(QUERY_RESULTS_FILE, "r", encoding="utf-8") as f:
            d = json.load(f)
        return jsonify(d)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# DASHBOARD ANALYTICS
@app.route("/api/analytics/dashboard", methods=["GET"])
def get_analytics():
    try:
        conn, engine = get_db_connection()
        cur = conn.cursor()
        
        cur.execute("SELECT COUNT(*) FROM Customer")
        total_customers = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM Movie WHERE Status = 'Now Showing'")
        active_movies = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM Screen")
        total_screens = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*), SUM(Net_Payable) FROM Booking WHERE Booking_Status = 'Confirmed'")
        brow = cur.fetchone()
        total_bookings = brow[0] or 0
        total_revenue = float(brow[1] or 0.0)
        
        cur.execute("SELECT COUNT(*), SUM(Stock_Quantity) FROM Tuck_Shop")
        ts_row = cur.fetchone()
        tuckshop_items = ts_row[0] or 0
        
        conn.close()
        return jsonify({
            "total_customers": total_customers,
            "active_movies": active_movies,
            "total_screens": total_screens,
            "total_bookings": total_bookings,
            "total_revenue": total_revenue,
            "tuckshop_items": tuckshop_items,
            "database_engine": engine
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    init_embedded_db()
    print("[SERVER] Starting Cinema Management System API on port 5000...")
    app.run(host="0.0.0.0", port=5000, debug=True)
