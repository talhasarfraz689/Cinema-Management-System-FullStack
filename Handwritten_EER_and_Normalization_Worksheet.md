# BSCS Database Systems — Term Project Handwritten Deliverables Guide
**Course:** CS-311: Database Systems  
**Instructor:** Miss Duaa-e-Nadeem  
**Student Name:** Talha Sarfraz (SAP ID: 70150006) & Group  
**Project:** Cinema Management System (Full-Stack)

---

## 📌 Instructions for Students
The term project guidelines specifically require **two handwritten components**:
1. **Component #8: Enhanced Entity Relationship (EER) Diagram**
2. **Component #9: Relational Model Mapping from EER**
3. **Component #15: Database Normalization up to BCNF**

This guide provides the exact diagrams, tables, and text to copy onto physical A4 paper or notebook sheets for your submission.

---

# Deliverable 1: Handwritten Enhanced Entity-Relationship (EER) Diagram

### Layout to Draw by Hand:
```
                                +---------------------------------------------------+
                                |                      SCREEN                       |
                                |---------------------------------------------------|
                                | - Screen_ID (PK)                                  |
                                | - Screen_Name                                     |
                                | - Screen_Type (Discriminator)                     |
                                | - Total_Capacity                                  |
                                | - Row_Count                                       |
                                | - Seats_Per_Row                                   |
                                | - Sound_System                                    |
                                | - Projector_Model                                 |
                                | - Screen_Width_Feet                               |
                                | - Screen_Height_Feet                              |
                                | - Cleaning_Status                                 |
                                | - Is_Active                                       |
                                +---------------------------------------------------+
                                                          ||
                                              (Total Participation: Double Line)
                                                          ||
                                                         ( d )   <-- Disjoint Constraint Circle
                                                     /     |    \     \
                                                    /      |     \     \
                     +-----------------------------+       |      \     +------------------------------+
                     |         IMAXScreen          |       |       \    |         SilverScreen         |
                     |-----------------------------|       |        \   |------------------------------|
                     | - Screen_ID (PK, FK)        |       |         \  | - Screen_ID (PK, FK)         |
                     | - Laser_Projection_Type     |       |          \ | - Discount_Tier_Percent      |
                     | - Aspect_Ratio ('1.43:1')   |       |           \| - Economy_Bundle_Eligible    |
                     | - Dual_Laser_3D (Boolean)   |       |            | - Student_Pass_Accepted      |
                     | - Curved_Angle_Degrees      |       |            | - Group_Discount_Active      |
                     | - Commercial_License_Code   |       |            | - Free_Refill_Eligible       |
                     +-----------------------------+       |            +------------------------------+
                                                           |                           ^
                                                           |                           |
                                +--------------------------+---+                       |
                                |                              |                       |
                 +-----------------------------+ +-----------------------------+       |
                 |         GoldScreen          | |        PremiumScreen        |       |
                 |-----------------------------| |-----------------------------|-------+
                 | - Screen_ID (PK, FK)        | | - Screen_ID (PK, FK)        |
                 | - Lounge_Service_Type       | | - Luxury_Level              |
                 | - Recliner_Model            | | - Private_Balcony_Seats     |
                 | - Butler_Service_Enabled    | | - Wine_Bar_Access           |
                 | - Complimentary_Snack_Tier  | | - VIP_Restroom_Access       |
                 | - Call_Button_Active        | | - Heated_Seats              |
                 +-----------------------------+ +-----------------------------+
```

### Explanatory Text to Write Beneath the Diagram:
1. **Superclass:** `Screen` represents generic cinema screening auditoriums.
2. **Subclasses:** `IMAXScreen`, `GoldScreen`, `PremiumScreen`, `SilverScreen`.
3. **Disjoint Constraint (d):** A screen entity can belong to at most one subtype.
4. **Total Participation Constraint (=):** Every screen must be categorized into exactly one subtype.

---

# Deliverable 2: Handwritten EER to Relational Model Mapping

### Write out the Mapping Equations on Paper:

**Mapping Algorithm Used:** Option 8.1.A (Multiple relations: Superclass and Subclasses).
- **Rule:** Create a relation for the superclass with its primary key. Create a relation for each subclass containing the specialized attributes plus the superclass primary key, which acts as both primary key and foreign key.

```
1. Screen ( <u>Screen_ID</u>, Screen_Name, Screen_Type, Total_Capacity, Row_Count, Seats_Per_Row, 
           Sound_System, Projector_Model, Screen_Width_Feet, Screen_Height_Feet, Cleaning_Status, Is_Active )
   Primary Key: Screen_ID

2. IMAXScreen ( <u>Screen_ID</u>, Laser_Projection_Type, Aspect_Ratio, Dual_Laser_3D, Curved_Angle_Degrees, Commercial_License_Code )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID references Screen(Screen_ID) ON DELETE CASCADE

3. GoldScreen ( <u>Screen_ID</u>, Lounge_Service_Type, Recliner_Model, Butler_Service_Enabled, Complimentary_Snack_Tier, Call_Button_Active )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID references Screen(Screen_ID) ON DELETE CASCADE

4. PremiumScreen ( <u>Screen_ID</u>, Luxury_Level, Private_Balcony_Seats, Wine_Bar_Access, VIP_Restroom_Access, Heated_Seats )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID references Screen(Screen_ID) ON DELETE CASCADE

5. SilverScreen ( <u>Screen_ID</u>, Discount_Tier_Percent, Economy_Bundle_Eligible, Student_Pass_Accepted, Group_Discount_Active, Free_Refill_Eligible )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID references Screen(Screen_ID) ON DELETE CASCADE
```

---

# Deliverable 3: Handwritten Database Normalization (Up to BCNF)

### Unnormalized Form (UNF):
```
UNF_Cinema_Booking (
    Customer_ID, Customer_Name, Customer_Email, Customer_Phone_List,
    Booking_ID, Booking_Date, Show_ID, Show_Date, Start_Time, Base_Price,
    Movie_ID, Movie_Title, Genre, Director,
    Screen_ID, Screen_Name, Screen_Type, Total_Capacity,
    Seat_Number, Ticket_Number, Final_Ticket_Price,
    Concession_Item_ID, Concession_Item_Name, Concession_Category, Unit_Price, Order_Quantity
)
```

### Functional Dependencies (Write all 10):
- **FD1:** `Customer_ID -> Customer_Name, Customer_Email`
- **FD2:** `Customer_ID, Customer_Phone -> Phone_Type`
- **FD3:** `Show_ID -> Show_Date, Start_Time, Base_Price, Movie_ID, Screen_ID`
- **FD4:** `Movie_ID -> Movie_Title, Genre, Director`
- **FD5:** `Screen_ID -> Screen_Name, Screen_Type, Total_Capacity`
- **FD6:** `Booking_ID -> Customer_ID, Show_ID, Booking_Date`
- **FD7:** `Booking_ID, Seat_Number -> Ticket_Number, Final_Ticket_Price`
- **FD8:** `Ticket_Number -> Booking_ID, Seat_Number, Final_Ticket_Price`
- **FD9:** `Concession_Item_ID -> Concession_Item_Name, Concession_Category, Unit_Price`
- **FD10:** `Booking_ID, Concession_Item_ID -> Order_Quantity`

### Step 1: First Normal Form (1NF)
- **Violation:** Multivalued attributes (`Customer_Phone_List`) and repeating groups of seats and concessions.
- **Decomposition:** Make all values atomic; separate phones and repeating orders.
- **Anomalies Eliminated:** Eliminates indeterminate array searches; guarantees scalar values.

### Step 2: Second Normal Form (2NF)
- **Violation:** In composite key relations, partial dependencies exist (e.g. `Movie_Title` depends on `Movie_ID` alone, not the full composite key).
- **Decomposition:** Separate entities whose primary keys are the determinants of the partial dependencies: `Customer`, `Movie`, `Screen`, `Tuck_Shop`.
- **Anomalies Eliminated:**
  - *Insertion Anomaly:* Can now add a Movie or Concession item without requiring an active ticket booking.
  - *Deletion Anomaly:* Deleting a booking does not erase the movie or concession item from the catalog.

### Step 3: Third Normal Form (3NF)
- **Violation:** Transitive dependencies exist: `Booking_ID -> Show_ID -> Movie_ID -> Movie_Title`.
- **Decomposition:** Isolate transitively dependent attributes into their respective parent tables: `Booking`, `Showtime`, `Movie`, `Screen`.
- **Anomalies Eliminated:**
  - *Update Anomaly:* Changing a movie title or screen name requires updating exactly ONE tuple in `Movie` or `Screen`, rather than updating thousands of booking records.

### Step 4: Boyce-Codd Normal Form (BCNF)
- **Condition:** For every functional dependency $X \rightarrow Y$, $X$ must be a superkey.
- **Verification:** Both candidate keys `{Booking_ID, Seat_ID}` and `{Ticket_Number}` are superkeys. Every relation in our final 19-table schema has superkey determinants.
- **Final Decomposed Schema:**
  - `Customer(<u>Customer_ID</u>, First_Name, Last_Name, Email, ...)`
  - `Phone_Number(<u>Phone_Num, Customer_ID</u>, Phone_Type)`
  - `Movie(<u>Movie_ID</u>, Title, Genre, Duration_Minutes, ...)`
  - `Screen(<u>Screen_ID</u>, Screen_Name, Screen_Type, ...)`
  - `Showtime(<u>Show_ID</u>, Movie_ID, Screen_ID, Start_Time, ...)`
  - `Seat(<u>Seat_ID</u>, Screen_ID, Row_Letter, Seat_Number, ...)`
  - `Booking(<u>Booking_ID</u>, Customer_ID, Show_ID, Total_Amount, ...)`
  - `Ticket(<u>Ticket_ID</u>, Booking_ID, Seat_ID, Ticket_Number, ...)`
  - `Tuck_Shop(<u>Item_ID</u>, Item_Name, Unit_Price, Stock_Quantity, ...)`
  - `Concession_Order(<u>Order_ID</u>, Customer_ID, Employee_ID, Total_Payable, ...)`
  - `Concession_Item_Order(<u>Order_ID, Item_ID</u>, Quantity, Subtotal)`
