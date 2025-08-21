-- tags.sql
-- Tags Table Schema
-- This table stores tags that can be associated with various content types

CREATE TABLE Tags
(
    TagID INT IDENTITY (1, 1) PRIMARY KEY,
    TagName VARCHAR(255) NOT NULL UNIQUE,
    Description TEXT,
    CreatedAt DATETIME DEFAULT GETDATE (),
    UpdatedAt DATETIME DEFAULT GETDATE (),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedBy INT NULL,
    UpdatedBy INT NULL
);