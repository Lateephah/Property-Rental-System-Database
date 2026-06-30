-- First and foremost I created a database called airbnb_db
CREATE DATABASE airbnb_db;

-- Switch my session to the airbnb_db database (db), in other to use the db
USE airbnb_db;

-- creating The Landlord table
CREATE TABLE landlords (
    landlord_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- creating The Tenant table
CREATE TABLE tenants (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- creating The properties table
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


-- creating The leases table
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


-- creating The payments table
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


-- creating The maintenance_requests table
CREATE TABLE maintenance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    request_date DATE,
    issue_description TEXT,
    request_status VARCHAR(50),

    FOREIGN KEY (property_id)
        REFERENCES properties(property_id)
);

SELECT *
FROM  properties;

-- -- Adding Constraint to property_type
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


-- Adding Constraint to property_status
ALTER TABLE properties
ADD CONSTRAINT chk_property_status
CHECK (
    status IN (
        'Occupied',
        'Vacant',
        'Maintenance'
    )
);


-- Adding Constraint to payment_status in payment table
ALTER TABLE payments
ADD CONSTRAINT chk_payment_status
CHECK (
    payment_status IN (
        'Paid',
        'Pending',
        'Failed'
    )
);


-- Adding Constraint to maintenance_status in maintenance_requests table
ALTER TABLE maintenance_requests 
ADD CONSTRAINT chk_request_status
CHECK (
    request_status IN (
        'Open',
        'In Progress',
        'Resolved'
    )
);


-- Adding Constraint to monthly_rent in leases table
ALTER TABLE leases
ADD CONSTRAINT chk_monthly_rent
CHECK (monthly_rent > 0);

--  Adding Constraint to security_deposit in leases table
ALTER TABLE leases
ADD CONSTRAINT chk_security_deposit
CHECK (security_deposit >= 0);


# populating the tables by adding some sample data 
-- Sample Data to Landlords
INSERT INTO landlords
(first_name,last_name,email,phone)
VALUES
('John','Doe','john@gmail.com','08011111111'),
('Mary','Smith','mary@gmail.com','08022222222');

SELECT * 
FROM landlords;
 

-- Sample Data to tenants
INSERT INTO tenants
(first_name,last_name,email,phone,date_of_birth)
VALUES
('David','Johnson','david@gmail.com','08033333333','1995-05-10'),
('Sarah','Williams','sarah@gmail.com','08044444444','1998-09-15');

SELECT * 
FROM tenants;


-- Sample Data to properties
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


-- However this entry violated the constraint 'chk_property_type' because only allowed are 

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

SELECT * 
FROM properties;


-- Another constraint violation: Invalid Payment Status
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

-- Another constraint violation: Negative Rent
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


-- adding more sample to demonstrate the cardinality
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

-- add more
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