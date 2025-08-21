-- SQL Schema for Content Tagging System
-- This schema defines the structure for tagging content in the FunnyFlow application

-- Table: content_tag
CREATE TABLE content_tag
(
    id INT PRIMARY KEY IDENTITY (1, 1),
    content_id INT NOT NULL,
    -- tag_id: Foreign key to tag table
    tag_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE (),
    CONSTRAINT fk_content FOREIGN KEY (content_id) REFERENCES content (id),
    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES tag (id)
);

-- Index for faster lookups
CREATE INDEX idx_content_tag_content_id ON content_tag (content_id);

CREATE INDEX idx_content_tag_tag_id ON content_tag (tag_id);