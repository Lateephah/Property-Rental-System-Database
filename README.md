# Property Rental Management System (MySQL)

## Project Overview

This project is a relational database designed from scratch to simulate the backend of a property rental management system similar to Airbnb or a property management platform.

The objective of the project is to demonstrate database design principles, including entity relationship modeling, normalization, constraints, and referential integrity using MySQL.

---

## Project Objectives

* Design a relational database from scratch.
* Create an Entity Relationship Diagram (ERD).
* Implement primary and foreign key relationships.
* Enforce business rules using constraints.
* Populate the database with sample data.
* Demonstrate how invalid data is prevented through constraint enforcement.

---

## Database Entities

The database consists of six core entities:

* Landlords
* Tenants
* Properties
* Leases
* Payments
* Maintenance Requests

---

## Entity Relationships

* One landlord can own multiple properties.
* One property can have multiple lease agreements over time.
* One tenant can sign multiple leases over time.
* One lease can have multiple payment records.
* One property can have multiple maintenance requests.

---
## Data Model and Relationship Detection in Power BI

Two screenshots of the data model are included in this repository.

The first screenshot was taken immediately after loading the initial sample data into Power BI. At that stage, most relationships were inferred as **one-to-one (1:1)** because the sample data did not yet contain repeated foreign key values.

Additional sample records were then inserted to better represent real-world business scenarios, such as:

* One landlord owning multiple properties.
* One lease having multiple payment records.

After refreshing the model, Power BI automatically updated some relationships to **one-to-many (1:*)**, reflecting the intended database design.

This demonstrates an important concept: **Power BI infers relationship cardinality from the data currently loaded into the model rather than solely from the foreign key definitions in the source database.** As more representative data is introduced, the detected relationships may change to better align with the underlying business rules.

## Technologies Used

* MySQL Server
* MySQL Workbench
* Power BI (for visualizing the data model)

---

## Database Features

### Constraints Implemented

* Valid property types
* Valid property statuses
* Valid payment statuses
* Valid maintenance request statuses
* Positive monthly rent values
* Non-negative security deposits
* Unique email addresses
* Referential integrity through foreign keys

---

## Demonstration of Constraint Enforcement

The project includes sample insert statements that intentionally violate business rules to demonstrate how the database prevents invalid data from being stored.

Examples include:

* Invalid property types
* Invalid payment statuses
* Negative rent values
* Ensuring Email formats
* Ensuring phone number formats

---

## Skills Demonstrated

* Database Design
* Data Modeling
* Normalization
* Primary Keys
* Foreign Keys
* Constraints
* Data Integrity
* Relational Database Management
* SQL DDL and DML

---

