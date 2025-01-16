-- Creating the users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    last_login TIMESTAMP,
    CONSTRAINT chk_username_not_empty CHECK (LENGTH(TRIM(username)) > 0)
);

-- Creating the topics table
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(500),
    CONSTRAINT chk_topic_name_not_empty CHECK (LENGTH(TRIM(name)) > 0)
);

-- Creating the posts table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    url VARCHAR(500) DEFAULT NULL,
    text_content TEXT DEFAULT NULL,
    topic_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_url_or_text CHECK (
        (url IS NOT NULL AND text_content IS NULL) OR 
        (url IS NULL AND text_content IS NOT NULL)
    ),
    CONSTRAINT chk_post_title_not_empty CHECK (LENGTH(TRIM(title)) > 0),
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Adding indexes to posts table
CREATE INDEX idx_posts_url ON posts(url);
CREATE INDEX idx_posts_topic_id ON posts(topic_id);
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Creating the comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    text_content TEXT NOT NULL,
    post_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    parent_comment_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_comment_text_not_empty CHECK (LENGTH(TRIM(text_content)) > 0),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- Adding indexes to comments table
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_parent_comment_id ON comments(parent_comment_id);

-- Creating the votes table
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    vote_value INT NOT NULL,
    CONSTRAINT chk_vote_value_valid CHECK (vote_value IN (-1, 1)),
    CONSTRAINT unique_vote_per_post_per_user UNIQUE (post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Adding indexes to votes table
CREATE INDEX idx_votes_post_id ON votes(post_id);
CREATE INDEX idx_votes_user_id ON votes(user_id);
