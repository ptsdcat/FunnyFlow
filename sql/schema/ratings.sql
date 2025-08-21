-- The 'Rating' column stores the rating value as an integer.
-- It cannot be NULL, ensuring every record has a rating assigned.
CREATE TABLE Ratings
(
    RatingsID INT IDENTITY (1, 1) PRIMARY KEY,
    ContentID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT NOT NULL,
    RatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP CONSTRAINT FK_Ratings_Content FOREIGN KEY (ContentID) REFERENCES FunnyContent (ContentID) ON DELETE CASCADE,
    CONSTRAINT FK_Ratings_Users FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE,
    UNIQUE (ContentID, UserID),
    CHECK (Rating BETWEEN 1 AND 5)
);