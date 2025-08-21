-- notifications.sql
-- This script creates a table for storing notifications in the FunnyFlow application.

CREATE TABLE notifications
(
    id SERIAL PRIMARY KEY,
    -- Unique identifier for each notification
    user_id INTEGER NOT NULL,
    -- The user who receives the notification
    message TEXT NOT NULL,
    -- The notification message
    is_read BOOLEAN DEFAULT FALSE,
    -- Whether the notification has been read
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- When the notification was created

    -- Foreign key constraint to reference users table
    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- Index to quickly find unread notifications for a user
CREATE INDEX idx_notifications_user_unread ON notifications (user_id, is_read);