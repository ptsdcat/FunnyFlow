-----  FunnyFlow SQL Schema for Funny Content Ratings :D
-- This schema defines the structure for storing ratings and other data related to funny content

CREATE TABLE FunnyContent
(
    ContentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NULL,
    ContentType VARCHAR(16) NOT NULL CHECK (ContentType IN ('Joke', 'Meme', 'Quote', 'Gif', 'Video')),
    ContentText NVARCHAR(MAX) NOT NULL,
    MediaUrl NVARCHAR(512) NULL,
    -- Optional media link
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    -- Track last update
    Status VARCHAR(16) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Flagged')),
    Likes INT NOT NULL DEFAULT 0,
    Dislikes INT NOT NULL DEFAULT 0,
    Views INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_FunnyContent_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_FunnyContent_Category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- Table to store user ratings for content
CREATE TABLE FunnyContentRatings
(
    RatingID INT IDENTITY(1,1) PRIMARY KEY,
    ContentID INT NOT NULL,
    UserID INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    RatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_FunnyContentRatings_Content FOREIGN KEY (ContentID) REFERENCES FunnyContent(ContentID) ON DELETE CASCADE,
    CONSTRAINT FK_FunnyContentRatings_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Table to store comments on funny content
CREATE TABLE FunnyContentComments
(
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    ContentID INT NOT NULL,
    UserID INT NOT NULL,
    CommentText NVARCHAR(1024) NOT NULL,
    CommentedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_FunnyContentComments_Content FOREIGN KEY (ContentID) REFERENCES FunnyContent(ContentID) ON DELETE CASCADE,
    CONSTRAINT FK_FunnyContentComments_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Table to store tags for funny content
CREATE TABLE FunnyContentTags
(
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    TagName NVARCHAR(64) NOT NULL UNIQUE
);

-- Junction table for content and tags (many-to-many)
CREATE TABLE FunnyContentTagMap
(
    ContentID INT NOT NULL,
    TagID INT NOT NULL,
    CONSTRAINT PK_FunnyContentTagMap PRIMARY KEY (ContentID, TagID),
    CONSTRAINT FK_FunnyContentTagMap_Content FOREIGN KEY (ContentID) REFERENCES FunnyContent(ContentID) ON DELETE CASCADE,
    CONSTRAINT FK_FunnyContentTagMap_Tag FOREIGN KEY (TagID) REFERENCES FunnyContentTags(TagID) ON DELETE CASCADE
);

-- Table to store reports/flags on content
CREATE TABLE FunnyContentReports
(
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ContentID INT NOT NULL,
    UserID INT NOT NULL,
    Reason NVARCHAR(256) NOT NULL,
    ReportedAt DATETIME DEFAULT GETDATE(),
    Status VARCHAR(16) NOT NULL DEFAULT 'Open' CHECK (Status IN ('Open', 'Reviewed', 'Dismissed')),
    CONSTRAINT FK_FunnyContentReports_Content FOREIGN KEY (ContentID) REFERENCES FunnyContent(ContentID) ON DELETE CASCADE,
    CONSTRAINT FK_FunnyContentReports_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);