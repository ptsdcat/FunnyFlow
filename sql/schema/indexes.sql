-- Indexes for FunnyFlow Database Schema
-- This script creates indexes to optimize query performance across various tables in the FunnyFlow application.

--Improve query performance on key tables

-- USERS TABLE INDEXES
CREATE INDEX idx_users_email ON users (email);

CREATE UNIQUE INDEX idx_users_username ON users (username);

CREATE INDEX idx_users_created_at ON users (created_at);

-- POSTS TABLE INDEXES
CREATE INDEX idx_posts_user_id ON posts (user_id);

CREATE INDEX idx_posts_created_at ON posts (created_at);

CREATE INDEX idx_posts_status ON posts (status);

-- COMMENTS TABLE INDEXES
CREATE INDEX idx_comments_post_id ON comments (post_id);

CREATE INDEX idx_comments_user_id ON comments (user_id);

CREATE INDEX idx_comments_created_at ON comments (created_at);

-- LIKES TABLE INDEXES
CREATE INDEX idx_likes_post_id ON likes (post_id);

CREATE INDEX idx_likes_user_id ON likes (user_id);

-- TAGS TABLE INDEXES
CREATE UNIQUE INDEX idx_tags_name ON tags (name);

-- POST_TAGS (JOIN TABLE) INDEXES
CREATE INDEX idx_post_tags_post_id ON post_tags (post_id);

CREATE INDEX idx_post_tags_tag_id ON post_tags (tag_id);

-- MESSAGES TABLE INDEXES
CREATE INDEX idx_messages_sender_id ON messages (sender_id);

CREATE INDEX idx_messages_receiver_id ON messages (receiver_id);

CREATE INDEX idx_messages_sent_at ON messages (sent_at);

-- NOTIFICATIONS TABLE INDEXES
CREATE INDEX idx_notifications_user_id ON notifications (user_id);

CREATE INDEX idx_notifications_created_at ON notifications (created_at);

-- FRIENDSHIPS TABLE INDEXES
CREATE INDEX idx_friendships_user_id ON friendships (user_id);

CREATE INDEX idx_friendships_friend_id ON friendships (friend_id);

CREATE UNIQUE INDEX idx_friendships_pair ON friendships (user_id, friend_id);

-- AUDIT_LOG TABLE INDEXES
CREATE INDEX idx_audit_log_user_id ON audit_log (user_id);

CREATE INDEX idx_audit_log_action ON audit_log (action);

CREATE INDEX idx_audit_log_created_at ON audit_log (created_at);

-- SESSIONS TABLE INDEXES
CREATE UNIQUE INDEX idx_sessions_token ON sessions (token);

CREATE INDEX idx_sessions_user_id ON sessions (user_id);

CREATE INDEX idx_sessions_expires_at ON sessions (expires_at);

-- ATTACHMENTS TABLE INDEXES
CREATE INDEX idx_attachments_post_id ON attachments (post_id);

CREATE INDEX idx_attachments_user_id ON attachments (user_id);

-- REACTIONS TABLE INDEXES
CREATE INDEX idx_reactions_post_id ON reactions (post_id);

CREATE INDEX idx_reactions_user_id ON reactions (user_id);

CREATE INDEX idx_reactions_type ON reactions(type);

-- GROUPS TABLE INDEXES
CREATE UNIQUE INDEX idx_groups_name ON groups (name);

-- GROUP_MEMBERS TABLE INDEXES
CREATE INDEX idx_group_members_group_id ON group_members (group_id);

CREATE INDEX idx_group_members_user_id ON group_members (user_id);

-- EVENTS TABLE INDEXES
CREATE INDEX idx_events_creator_id ON events (creator_id);

CREATE INDEX idx_events_start_time ON events (start_time);

-- EVENT_ATTENDEES TABLE INDEXES
CREATE INDEX idx_event_attendees_event_id ON event_attendees (event_id);

CREATE INDEX idx_event_attendees_user_id ON event_attendees (user_id);

-- TASKS TABLE INDEXES
CREATE INDEX idx_tasks_assigned_to ON tasks (assigned_to);

CREATE INDEX idx_tasks_due_date ON tasks (due_date);

-- TASK_COMMENTS TABLE INDEXES
CREATE INDEX idx_task_comments_task_id ON task_comments (task_id);

CREATE INDEX idx_task_comments_user_id ON task_comments (user_id);

-- SETTINGS TABLE INDEXES
CREATE UNIQUE INDEX idx_settings_user_id ON settings (user_id);

--END OF THE CODE NOW FUCK OFF