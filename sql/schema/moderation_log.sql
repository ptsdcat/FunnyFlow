CREATE TABLE ModerationLog
(
    LogID INT PRIMARY KEY IDENTITY (1, 1),
    ContentID INT NOT NULL,
    ModeratorID INT NOT NULL,
    Action VARCHAR(16) NOT NULL,
    Reason TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_ModerationLog_Content FOREIGN KEY (ContentID) REFERENCES Content (ContentID),
    CONSTRAINT FK_ModerationLog_Moderator FOREIGN KEY (ModeratorID) REFERENCES Users (UserID) ON DELETE CASCADE
);