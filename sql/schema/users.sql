--users.sql
-- This SQL script creates a table for storing user information in the FunnyFlow application.

CREATE TABLE Users
(
    UserID INT PRIMARY KEY IDENTITY (1, 1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL,
    JoinDate DATETIME DEFAULT GETDATE (),
    CONSTRAINT chk_email CHECK (Email LIKE '%@%.%')
);