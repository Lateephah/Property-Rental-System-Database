 # Creating the Database
/* The first step was to create a dedicated database, `airbnb_db`, which serves as the 
container for all entities and relationships in the property rental management system. */
CREATE DATABASE airbnb_db;


# Selecting the Database
/* After creating the database, the session was switched to `airbnb_db` so that all 
subsequent objects (tables, constraints, and data) would be created within the 
correct schema.*/
USE airbnb_db;


# Creating the Landlords Table
/* The `landlords` table stores information about property owners. A unique constraint 
was applied to both email and phone numbers to prevent duplicate landlord records.*/
CREATE TABLE landlords (
    landlord_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


# Creating The Tenant Table
/* The `tenants` table stores information about individuals renting properties. Each 
tenant is uniquely identified and includes basic contact information and date of birth.*/
CREATE TABLE tenants (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Creating The Properties Table
/* The `properties` table captures details about rental properties and links each property 
to its owner through a foreign key relationship with the `landlords` table. */
CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    landlord_id INT NOT NULL,
    property_name VARCHAR(100),
    property_type VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    bedrooms INT,
    bathrooms INT,
    monthly_rent DECIMAL(12,2),
    status VARCHAR(20),

    FOREIGN KEY (landlord_id)
        REFERENCES landlords(landlord_id)
);


# Creating the Leases Table
/* The `leases` table represents rental agreements between tenants and properties. 
It serves as a bridge table that connects tenants to the properties they occupy.*/
CREATE TABLE leases (
    lease_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    tenant_id INT NOT NULL,
    lease_start DATE NOT NULL,
    lease_end DATE NOT NULL,
    monthly_rent DECIMAL(12,2),
    security_deposit DECIMAL(12,2),

    FOREIGN KEY (property_id)
        REFERENCES properties(property_id),

    FOREIGN KEY (tenant_id)
        REFERENCES tenants(tenant_id)
);


# Creating the Payments Table
/* The `payments` table records rent payments associated with each lease agreement, 
enabling the tracking of payment history and statuses.*/
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    lease_id INT NOT NULL,
    payment_date DATE,
    amount_paid DECIMAL(12,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),

    FOREIGN KEY (lease_id)
        REFERENCES leases(lease_id)
);


# Creating the Maintenance Requests Table
/* The `maintenance_requests` table stores issues reported for properties, allowing
 maintenance activities to be tracked independently from lease and payment information.*/
CREATE TABLE maintenance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    request_date DATE,
    issue_description TEXT,
    request_status VARCHAR(50),

    FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
);

# previewing properties table
SELECT *
FROM  properties;

#  Adding Constraint to property_type
/* A check constraint was added to ensure that only valid property types 
(`Apartment`, `House`, `Studio`, and `Duplex`) can be inserted.*/
ALTER TABLE properties
ADD CONSTRAINT chk_property_type
CHECK (
    property_type IN (
        'Apartment',
        'House',
        'Studio',
        'Duplex'
    )
);


# Adding Constraint to property_status
/* A check constraint was added to restrict property statuses to `Occupied`, `Vacant`, 
or `Maintenance`.*/
ALTER TABLE properties
ADD CONSTRAINT chk_property_status
CHECK (
    status IN (
        'Occupied',
        'Vacant',
        'Maintenance'
    )
);


# Adding Constraint to payment_status in payment table
/* A check constraint was implemented to ensure that payment records can only have 
the statuses `Paid`, `Pending`, or `Failed`.*/
ALTER TABLE payments
ADD CONSTRAINT chk_payment_status
CHECK (
    payment_status IN (
        'Paid',
        'Pending',
        'Failed'
    )
);


# Adding Constraint to maintenance_status in maintenance_requests table
/* A check constraint was added to enforce valid maintenance request statuses: 
`Open`, `In Progress`, and `Resolved`.*/
ALTER TABLE maintenance_requests 
ADD CONSTRAINT chk_request_status
CHECK (
    request_status IN (
        'Open',
        'In Progress',
        'Resolved'
    )
);


# Adding Financial Constraint to monthly_rent in leases table
ALTER TABLE leases
ADD CONSTRAINT chk_monthly_rent
CHECK (monthly_rent > 0);

#  Adding Constraint to security_deposit in leases table
ALTER TABLE leases
ADD CONSTRAINT chk_security_deposit
CHECK (security_deposit >= 0);
/* Validation rules were added to ensure that monthly rent values are always
 positive and security deposits cannot be negative.*/


# Adding Constraint to Phone in landlords table
/* Regular expression constraints were implemented to enforce valid Nigerian phone 
numbers and properly formatted email addresses.*/
ALTER TABLE landlords
ADD CONSTRAINT chk_phone_format
CHECK (phone REGEXP '^0[0-9]{10}$');


# Contact Information Validation
/* Regular expression constraints were implemented to enforce valid Nigerian phone 
numbers and properly formatted email addresses.*/

-- Adding Constraint to Phone in tenants table
ALTER TABLE tenants
ADD CONSTRAINT chk_tenant_phone_format
CHECK (phone REGEXP '^0[0-9]{10}$');

-- Adding Constraint to email in landlords table
ALTER TABLE landlords
ADD CONSTRAINT chk_landlord_email_format
CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Adding Constraint to email in tenants table
ALTER TABLE tenants
ADD CONSTRAINT chk_tenant_email_format
CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


# Populating the Database
/* Sample records were inserted into each table to simulate real-world operations
 and demonstrate the relationships between entities.*/
 
# Inserting Sample Landlords
INSERT INTO landlords
(first_name,last_name,email,phone)
VALUES
('John','Doe','john@gmail.com','08011111111'),
('Mary','Smith','mary@gmail.com','08022222222');

SELECT * 
FROM landlords;
 # Two landlord records were inserted to represent property owners in the system.


# Inserting Sample Tenants
INSERT INTO tenants
(first_name,last_name,email,phone,date_of_birth)
VALUES
('David','Johnson','david@gmail.com','08033333333','1995-05-10'),
('Sarah','Williams','sarah@gmail.com','08044444444','1998-09-15');

SELECT * 
FROM tenants;
# Two tenant records were inserted to simulate individuals renting properties.


-- Sample Data to properties Table
INSERT INTO properties
(
landlord_id,
property_name,
property_type,
address,
city,
state,
bedrooms,
bathrooms,
monthly_rent,
status
)
VALUES
(
1,
'Sunset Apartments',
'Apartment',
'12 Admiralty Way',
'Lagos',
'Lagos',
2,
2,
450000,
'Occupied'
),
(
2,
'Green Villa',
'House',
'45 GRA Road',
'Port Harcourt',
'Rivers',
4,
3,
850000,
'Vacant'
);
#Sample properties were added and linked to their respective landlords using foreign keys.

# Testing Constraint Enforcement: Invalid Property Type

## Attempt 1:
INSERT INTO properties
(
landlord_id,
property_name,
property_type,
address,
city,
state,
bedrooms,
bathrooms,
monthly_rent,
status
)
VALUES
(
1,
'Blue Estate',
'Castle',
'20 Banana Island',
'Lagos',
'Lagos',
5,
4,
1200000,
'Vacant'
);
/*The attempt was made to insert a property with a type of `Castle`. The operation 
failed because the value violated the `chk_property_type` constraint.*/

# Attempt 2:
INSERT INTO payments
(
lease_id,
payment_date,
amount_paid,
payment_method,
payment_status
)
VALUES
(
1,
'2026-06-30',
450000,
'Bank Transfer',
'Completed'
);
/* This attempt was made to insert a payment with a status of `Completed`. Since this value
 is not among the allowed statuses, the database correctly rejected the record.*/
 
 
-- Attempt 3:
INSERT INTO leases
(
property_id,
tenant_id,
lease_start,
lease_end,
monthly_rent,
security_deposit
)
VALUES
(
1,
1,
'2026-01-01',
'2026-12-31',
-500000,
100000
);
/* The attempt was made to insert a lease with a negative rent amount. The operation 
failed because the `chk_monthly_rent` constraint enforces positive rent values.*/

# Demonstrating Relationship Cardinality

/* Additional records were inserted to better represent real-world business scenarios 
and to demonstrate one-to-many relationships within the database model.*/
INSERT INTO properties
(
landlord_id,
property_name,
property_type,
address,
city,
state,
bedrooms,
bathrooms,
monthly_rent,
status
)
VALUES
(
1,
'Palm Heights',
'Apartment',
'15 Admiralty Way',
'Lagos',
'Lagos',
3,
2,
550000,
'Vacant'
);
/* An additional property was assigned to an existing landlord to demonstrate that
 a single landlord can own multiple properties.*/


-- the second data sample added, on the lease table though
INSERT INTO leases
(
property_id,
tenant_id,
lease_start,
lease_end,
monthly_rent,
security_deposit
)
VALUES
(
2,
1,
'2027-01-01',
'2027-12-31',
850000,
200000
);
/* The additional lease was created for an existing tenant to illustrate that tenants 
may rent different properties over time.*/

-- One lease having multiple payments
INSERT INTO payments
(
lease_id,
payment_date,
amount_paid,
payment_method,
payment_status
)
VALUES
(1,'2026-01-01',450000,'Bank Transfer','Paid'),
(1,'2026-02-01',450000,'Bank Transfer','Paid'),
(1,'2026-03-01',450000,'Bank Transfer','Paid');
/* Multiple payment records were inserted for the same lease to simulate monthly
 rent payments and demonstrate a one-to-many relationship between leases and payments.
*/

# Data Model Evolution in Power BI
/* The first model screenshot shows the initial relationships inferred from the limited 
sample data, where several relationships appeared as one-to-one. And after inserting 
additional records to better reflect real-world scenarios, PowerBI automatically updated 
some relationships to one-to-many, demonstrating that relationship cardinality is 
inferred from the data currently loaded into the model.*/