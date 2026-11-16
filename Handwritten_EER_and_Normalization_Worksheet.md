# BSCS Database Systems — Term Project Handwritten Deliverables Guide
**Course:** CS-311: Database Systems  
**Instructor:** Miss Duaa-e-Nadeem  
**Student Name:** Talha Sarfraz (SAP ID: 70150006) & Group  
**Degree Program:** Bachelor of Science in Computer Science (BSCS 5th-A)  
**Institution:** Department of Computer Science, The University of Lahore  
**Project:** Enhanced Cinema Management System (Enterprise Full-Stack)

---

## 📌 Student Submission Instructions
The term project guidelines explicitly require **handwritten components**:
1. **Component #8: Enhanced Entity Relationship (EER) Diagram** (Superclass and at least 3 subclasses with specialization/generalization constraints, neatly drawn).
2. **Component #9: Relational Model Mapping from EER** (Mapping equations identifying PK, FK, and referential constraints).
3. **Component #15: Database Normalization up to BCNF** (Step-by-step from UNF $\to$ 1NF $\to$ 2NF $\to$ 3NF $\to$ BCNF with Functional Dependencies).

This document serves as your **exact transcription guide**. You can:
- Directly copy the ASCII / blueprint layout below onto standard A4 lined/grid sheets using blue/black ballpoint pens.
- Or print the accompanying SVG templates (`Handwritten_EER_Diagram_Template.svg` and `Handwritten_BCNF_Normalization_Sheet.svg`) for physical submission or digital pen annotation.

---

# Deliverable 1: Handwritten Enhanced Entity-Relationship (EER) Diagram

### Visual Hierarchy to Draw on Physical A4 Paper:
```
                                +---------------------------------------------------+
                                |               SCREEN (Superclass)                 |
                                |---------------------------------------------------|
                                | - <u>Screen_ID</u> (Primary Key : INT)             |
                                | - Screen_Name (Candidate Key - UNIQUE)            |
                                | - Screen_Type (Discriminator : IMAX/Gold/VIP/Silv)|
                                | - Total_Capacity (INTEGER, CHECK > 0)             |
                                | - Row_Count (INTEGER)                             |
                                | - Seats_Per_Row (INTEGER)                         |
                                | - Sound_System (Dolby Atmos 7.1/12.2)             |
                                | - Projector_Model (Barco / Christie 4K Laser)     |
                                | - Screen_Width_Feet (FLOAT)                       |
                                | - Screen_Height_Feet (FLOAT)                      |
                                | - Cleaning_Status (Clean/In-Progress/Inspection)  |
                                | - Is_Active (BIT Boolean Flag)                    |
                                +---------------------------------------------------+
                                                          ||
                                              (Total Participation: Double Line)
                                                          ||
                                                         ( d )   <-- Disjoint Constraint Circle
                                                     /     |    \     \
                                                    /      |     \     \
       +-------------------------------------------+       |      \     +--------------------------------------------+
       |         IMAXScreen (Subclass)             |       |       \    |          SilverScreen (Subclass)           |
       |-------------------------------------------|       |        \   |--------------------------------------------|
       | - <u>Screen_ID</u> (PK, FK : INT)          |       |         \  | - <u>Screen_ID</u> (PK, FK : INT)           |
       | - Laser_Projection_Type (Dual 4K Laser)   |       |          \ | - Discount_Tier_Percent (INTEGER 20%)      |
       | - Aspect_Ratio ('1.43:1' IMAX Standard)   |       |           \| - Economy_Bundle_Eligible (BIT)            |
       | - Dual_Laser_3D (BIT)                     |       |            | - Student_Pass_Accepted (BIT)              |
       | - Curved_Angle_Degrees (FLOAT 26.5)       |       |            | - Group_Discount_Active (BIT)              |
       | - Audio_Channel_Count (INTEGER 12)        |       |            | - Free_Refill_Eligible (BIT)               |
       | - Max_Screen_Luminance_Nits (INT 1000+)   |       |            | - Aisle_Ramp_Access (BIT)                  |
       | - HFR_Supported (High Frame Rate BIT)     |       |            | - Booster_Seat_Quantity (INTEGER 25)       |
       | - Calibration_Frequency_Days (INT 30)     |       |            | - Bulk_Ticket_Eligible (BIT)               |
       | - Commercial_License_Code (UNIQUE)        |       |            | - Matinee_Discount_Rate (DECIMAL 0.25)     |
       +-------------------------------------------+       |            +--------------------------------------------+
                                                           |                           ^
                                                           |                           |
                                +--------------------------+---+                       |
                                |                              |                       |
                 +-----------------------------+ +-----------------------------+       |
                 |    GoldScreen (Subclass)    | |   PremiumScreen (Subclass)  |       |
                 |-----------------------------| |-----------------------------|-------+
                 | - <u>Screen_ID</u> (PK, FK)   | | - <u>Screen_ID</u> (PK, FK)   |
                 | - Lounge_Service_Type       | | - Luxury_Level (Presidential) |
                 | - Recliner_Model (Luxe 2.0) | | - Private_Balcony_Seats (16)  |
                 | - Butler_Service_Enabled    | | - Wine_Bar_Access (BIT)       |
                 | - Complimentary_Snack_Tier  | | - VIP_Restroom_Access (BIT)   |
                 | - Call_Button_Active (BIT)  | | - Heated_Seats (BIT)          |
                 | - USB_Charging_Speed_Watts  | | - Acoustic_Damping_Rating (A) |
                 | - Legrest_Angle_Max (160 deg| | - Coat_Check_Available (BIT) |
                 | - Pillow_Blanket_Provided   | | - Concierge_Desk_Station (VIP)|
                 | - Lounge_Access_Code [UQ]   | | - Noise_Isolation_Db (65 dB)  |
                 +-----------------------------+ +-----------------------------+
```

### Explanatory Text to Handwrite Below the Diagram:
1. **Superclass:** `Screen` represents generic cinema auditoriums with 12 baseline architectural attributes.
2. **Specialized Subclasses:** `IMAXScreen`, `GoldScreen`, `PremiumScreen`, and `SilverScreen`. Each subclass strictly possesses **10 specialized relational attributes** representing distinct operational, mechanical, and hospitality specifications.
3. **Disjoint Constraint (`d` in circle):** An auditorium instance can belong to at most one screen subtype (an auditorium cannot be simultaneously an IMAXScreen and a GoldScreen).
4. **Total Participation Constraint (Double Line `=`):** Every screen entity in the database must belong to at least one (and due to disjointness, exactly one) specialized subclass. There are no generic, unclassified screening rooms.

---

# Deliverable 2: Handwritten EER to Relational Model Mapping

### Relational Schema Equations to Copy by Hand:
**Mapping Algorithm Applied:** Option 8.1.A (Multiple relations: Superclass and Subclasses).
- **Rule:** A relation is created for the superclass containing its primary key and shared attributes. A separate relation is created for each subclass containing its specialized attributes plus the superclass primary key, which serves as both Primary Key and Foreign Key.

```text
1. Screen ( 
       <u>Screen_ID</u>, Screen_Name, Screen_Type, Total_Capacity, Row_Count, 
       Seats_Per_Row, Sound_System, Projector_Model, Screen_Width_Feet, 
       Screen_Height_Feet, Cleaning_Status, Is_Active 
   )
   Primary Key: Screen_ID
   Alternate Candidate Key: Screen_Name (UNIQUE)

2. IMAXScreen ( 
       <u>Screen_ID</u>, Laser_Projection_Type, Aspect_Ratio, Dual_Laser_3D, 
       Curved_Angle_Degrees, Audio_Channel_Count, Max_Screen_Luminance_Nits, 
       HFR_Supported, Calibration_Frequency_Days, Commercial_License_Code 
   )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID REFERENCES Screen(Screen_ID) ON DELETE CASCADE ON UPDATE CASCADE
   Alternate Key: Commercial_License_Code (UNIQUE)

3. GoldScreen ( 
       <u>Screen_ID</u>, Lounge_Service_Type, Recliner_Model, Butler_Service_Enabled, 
       Complimentary_Snack_Tier, Call_Button_Active, USB_Charging_Speed_Watts, 
       Legrest_Angle_Max, Pillow_Blanket_Provided, Lounge_Access_Code 
   )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID REFERENCES Screen(Screen_ID) ON DELETE CASCADE ON UPDATE CASCADE
   Alternate Key: Lounge_Access_Code (UNIQUE)

4. PremiumScreen ( 
       <u>Screen_ID</u>, Luxury_Level, Private_Balcony_Seats, Wine_Bar_Access, 
       VIP_Restroom_Access, Heated_Seats, Acoustic_Damping_Rating, 
       Coat_Check_Available, Concierge_Desk_Station, Noise_Isolation_Db 
   )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID REFERENCES Screen(Screen_ID) ON DELETE CASCADE ON UPDATE CASCADE

5. SilverScreen ( 
       <u>Screen_ID</u>, Discount_Tier_Percent, Economy_Bundle_Eligible, 
       Student_Pass_Accepted, Group_Discount_Active, Free_Refill_Eligible, 
       Aisle_Ramp_Access, Booster_Seat_Quantity, Bulk_Ticket_Eligible, Matinee_Discount_Rate 
   )
   Primary Key: Screen_ID
   Foreign Key: Screen_ID REFERENCES Screen(Screen_ID) ON DELETE CASCADE ON UPDATE CASCADE
```

---

# Deliverable 3: Handwritten Database Normalization up to BCNF

## Step 0: Unnormalized Form (UNF)
Universal relation capturing a cinema patron visit, ticket booking, and tuck shop purchase:
```text
R_UNF ( 
    Booking_ID, Booking_Date, Customer_ID, Customer_Name, Customer_Email, Customer_City,
    { Phone_Number }, Show_ID, Show_Date, Start_Time, Base_Price, Movie_ID, Movie_Title, 
    Genre, Director, Screen_ID, Screen_Name, Screen_Type, 
    { Seat_Number, Seat_Class, Ticket_Price, Barcode_Number }, 
    { Item_ID, Item_Name, Quantity, Unit_Price }, Total_Paid 
)
```
- **Anomalies in UNF:**
  - *Insertion Anomaly:* Cannot add a new movie or concession item without an active booking.
  - *Deletion Anomaly:* Deleting a booking record deletes customer demographic data or movie metadata.
  - *Update Anomaly:* Updating a movie genre requires updating hundreds of redundant booking rows.

---

## Step 1: First Normal Form (1NF)
**Condition:** A relation is in 1NF if and only if all attribute domains contain only atomic (indivisible) values, and there are no repeating groups or multivalued arrays.

**Action Taken:**
1. Extract multivalued attribute `{ Phone_Number }` into dedicated entity `Phone_Number (<u>Phone_Num</u>, <u>Customer_ID</u>)`.
2. Flatten repeating seat/ticket reservations and concession items into distinct row entries.
3. Formulate the composite primary key: `(Booking_ID, Seat_ID, Item_ID)`.

```text
R_1NF ( 
    <u>Booking_ID</u>, <u>Seat_ID</u>, <u>Item_ID</u>, Customer_ID, Customer_Name, Customer_Email,
    Customer_City, Show_ID, Show_Date, Start_Time, Movie_ID, Movie_Title, Genre, 
    Screen_ID, Screen_Name, Seat_Code, Seat_Class, Ticket_Number, Barcode_Number, 
    Quantity, Unit_Price, Net_Payable 
)
```
*Status:* 1NF Satisfied.

---

## Step 2: Second Normal Form (2NF)
**Condition:** A relation is in 2NF if it is in 1NF and **no non-prime attribute is partially dependent on any candidate key** (elimination of Partial Functional Dependencies).

**Identified Functional Dependencies (FDs):**
- $\text{FD}_1 \text{ [Partial]}: \text{Booking\_ID} \to \text{Customer\_ID}, \text{Show\_ID}, \text{Booking\_Timestamp}, \text{Net\_Payable}$
- $\text{FD}_2 \text{ [Partial]}: \text{Seat\_ID} \to \text{Screen\_ID}, \text{Row\_Letter}, \text{Seat\_Number}, \text{Seat\_Class}, \text{Price\_Multiplier}$
- $\text{FD}_3 \text{ [Partial]}: \text{Item\_ID} \to \text{Item\_Name}, \text{Category}, \text{Unit\_Price}, \text{Stock\_Quantity}$
- $\text{FD}_4 \text{ [Full]}: (\text{Booking\_ID}, \text{Seat\_ID}) \to \text{Ticket\_ID}, \text{Ticket\_Number}, \text{Barcode\_Number}, \text{Final\_Price}$
- $\text{FD}_5 \text{ [Full]}: (\text{Order\_ID}, \text{Item\_ID}) \to \text{Quantity}, \text{Unit\_Price\_Charged}, \text{Subtotal}$

**Decomposition into 2NF Relations:**
```text
1. Booking ( <u>Booking_ID</u>, Customer_ID, Show_ID, Booking_Timestamp, Net_Payable )
2. Ticket ( <u>Ticket_ID</u>, Booking_ID, Seat_ID, Ticket_Number, Barcode_Number, Final_Price )
3. Seat ( <u>Seat_ID</u>, Screen_ID, Row_Letter, Seat_Number, Seat_Code, Seat_Class )
4. Tuck_Shop ( <u>Item_ID</u>, Item_Name, Category, Unit_Price, Stock_Quantity )
5. Concession_Order ( <u>Order_ID</u>, Customer_ID, Order_Timestamp, Total_Payable )
6. Concession_Item_Order ( <u>Order_ID</u>, <u>Item_ID</u>, Quantity, Unit_Price_Charged, Subtotal )
```
*Status:* 2NF Satisfied.

---

## Step 3: Third Normal Form (3NF)
**Condition:** A relation is in 3NF if it is in 2NF and **no non-prime attribute is transitively dependent on the primary key** (elimination of Transitive Dependencies $X \to Y \text{ and } Y \to Z$).

**Identified Transitive Dependencies:**
1. In `Booking`: $\text{Booking\_ID} \to \text{Customer\_ID} \text{ and } \text{Customer\_ID} \to \{\text{First\_Name, Last\_Name, Email, City}\}$
   - *Transitive Dependency:* $\text{Booking\_ID} \to \text{Customer Demographics}$
2. In `Booking`: $\text{Booking\_ID} \to \text{Show\_ID} \text{ and } \text{Show\_ID} \to \{\text{Movie\_ID, Screen\_ID, Show\_Date, Start\_Time}\}$
   - *Transitive Dependency:* $\text{Booking\_ID} \to \text{Showtime Parameters}$
3. In `Showtime`: $\text{Show\_ID} \to \text{Movie\_ID} \text{ and } \text{Movie\_ID} \to \{\text{Title, Genre, Duration\_Minutes, Director}\}$
   - *Transitive Dependency:* $\text{Show\_ID} \to \text{Movie Metadata}$
4. In `Showtime`: $\text{Show\_ID} \to \text{Screen\_ID} \text{ and } \text{Screen\_ID} \to \{\text{Screen\_Name, Screen\_Type, Total\_Capacity}\}$
   - *Transitive Dependency:* $\text{Show\_ID} \to \text{Auditorium Specifications}$

**Decomposition into 3NF Relations:**
- Isolate `Customer`, `Showtime`, `Movie`, and `Screen` into dedicated, independent entities.
- Every non-key attribute is now dependent **only on the candidate key**, the whole key, and nothing but the key.

*Status:* 3NF Satisfied.

---

## Step 4: Boyce-Codd Normal Form (BCNF)
**Condition:** A relation is in BCNF if and only if for every non-trivial functional dependency $X \to Y$, **$X$ is a Superkey**.

**Evaluation of Candidate Keys & Determinants Across Schema:**
1. **Relation `Customer`:**
   - Determinant 1: $\text{Customer\_ID} \to \text{All attributes}$ ($\text{Customer\_ID}$ is the Primary Key $\implies$ Superkey).
   - Determinant 2: $\text{Email} \to \text{All attributes}$ ($\text{Email}$ is declared UNIQUE $\implies$ Candidate Key $\implies$ Superkey).
   - *Conclusion:* Holds for BCNF.
2. **Relation `Movie`:**
   - Determinant 1: $\text{Movie\_ID} \to \text{All attributes}$ ($\text{Movie\_ID}$ is Primary Key $\implies$ Superkey).
   - *Conclusion:* Holds for BCNF.
3. **Relation `Ticket`:**
   - Determinant 1: $\text{Ticket\_ID} \to \text{All attributes}$ (Primary Key $\implies$ Superkey).
   - Determinant 2: $\text{Ticket\_Number} \to \text{All attributes}$ (UNIQUE candidate key $\implies$ Superkey).
   - Determinant 3: $\text{Barcode\_Number} \to \text{All attributes}$ (UNIQUE candidate key $\implies$ Superkey).
   - *Conclusion:* Holds for BCNF.
4. **Relation `Employee`:**
   - Determinant 1: $\text{Employee\_ID} \to \text{All attributes}$ (Primary Key $\implies$ Superkey).
   - Determinant 2: $\text{CNIC} \to \text{All attributes}$ (National CNIC is UNIQUE $\implies$ Superkey).
   - *Conclusion:* Holds for BCNF.
5. **Relation `Screen` & Subclasses:**
   - In `Screen`: $\text{Screen\_ID}$ (PK) and $\text{Screen\_Name}$ (UNIQUE) are both superkeys.
   - In `IMAXScreen`: $\text{Screen\_ID}$ (PK) and $\text{Commercial\_License\_Code}$ (UNIQUE) are both superkeys.
   - In `GoldScreen`: $\text{Screen\_ID}$ (PK) and $\text{Lounge\_Access\_Code}$ (UNIQUE) are both superkeys.
   - *Conclusion:* Holds for BCNF.

**Final Normalization Verdict:**
- Zero multi-attribute anomalies remain.
- Full Lossless-Join Decomposition achieved.
- All functional dependencies are preserved.
- **The Cinema Management System relational schema is strictly in BCNF.**
