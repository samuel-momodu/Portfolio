# SQL QUERIES

The SQL codes above have been used to create tables in a relational database.

## OVERVIEW

It is vital to store data correctly. This ensure that it can be efficiently collected, transformed and loaded to the database with minimal memory usage.
When vast amounts of character space are allocated to each column or row, it consumes lots of memory. We reduce the amount of memeory space allocated to each row and column when creating the table, using schemas.

### DEFINING TABLE SCHEMAS
SQL table schemas are the set of rules that govern each table creation on the database. They define the possible amount of data that can be stored in each row or column of a table. Schemas define the relationships (using keys) that exisst between rows, columns and tables.

The aim of this, is to create tables which clearly store data, without consuming lots of space. The data o each tableis readily accessible for either analyis or reporting.

* Use primary keys to establish a relationships between rows and columns of a table.
* Use foreign keeys to establish relationiships between one or more tables.
* Set the data type for each row and column (either float, int or string).
* Define the maximum number of characters that can exist in each row and column.

### GOALS

When a table schema is correctly defined in a relational database, it eradicates the possibility of data loss. This is very useful when setting up a relational database table for a business. This improves the accuracy to which data can be retieved, stored and used to generate reports directly from the relational database.

### BENEFITS

* A proper schema makes it easy for the data to be stired directly from the point of trnasaction, into the database directly.
* Data is readily acessible.
* Data is neatly stored.
* Data can be easily loaded into the database.
* Data can be easily collected from the database.
* Data can be easily analysed.
* New data can be easily added.
* Incorrect data can be easily corrected through updates.
* Table consumes minimal space in the database.

### QUERIES
A few queries that show the created tables, using the schemas above in the OPERATIONA TABLE and sample datasets to fill up the table.

### EMPLOYEE TABLE
![Image of EMPLOYEE QUERY](https://github.com/samuel-momodu/Portfolio/blob/main/SQL-Schemas/QUERY%20ALL%20EMPLOYEE%20TABLE.png)

### CLIENT TABLE
![Image of CLIENT QUERY](https://github.com/samuel-momodu/Portfolio/blob/main/SQL-Schemas/QUERY%20ALL%20CLIENT%20TABLE.png)

### BRANCH TABLE
![Image of BRANCH QUERY](https://github.com/samuel-momodu/Portfolio/blob/main/SQL-Schemas/QUERY%20ALL%20BRANCH%20TABLE.png)

### BRANCH SUPPLIER TABLE
![Image of BRANCH_SUPPLIER QUERY](https://github.com/samuel-momodu/Portfolio/blob/main/SQL-Schemas/QUERY%20ALL%20BRANCH_SUPPLIER%20TABLE.png)

### WORKS WITH TABLE
![Image of WORKS_WITH QUERY](https://github.com/samuel-momodu/Portfolio/blob/main/SQL-Schemas/QUERY%20ALL%20WORKS_WITH%20TABLE.png)

