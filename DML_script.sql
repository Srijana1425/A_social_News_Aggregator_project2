--Populate`users`table with existing data 
INSERT INTO users ("username")
    SELECT DISTINCT username 
    FROM bad_posts
UNION
    SELECT DISTINCT username 
    FROM bad_comments
UNION
    SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(upvotes, ',')
    FROM bad_posts UNION
    SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(downvotes, ',')
    FROM bad_posts;

--Populate`topics`table with existing data 
INSERT INTO topics ("name")
    SELECT DISTINCT topic
    FROM bad_posts;


-- Populate `posts` table with existing data
INSERT INTO posts("id","title","url","text_content","topic_id", "user_id")
    SELECT
        bp.id,
        LEFT(bp.title,100),
        bp.url,
        bp.text_content, 
        t.id,
        u.id
FROM bad_posts AS bp 
INNER JOIN users AS u
ON bp.username=u.username 
INNER JOIN topics AS t
ON bp.topic = t.name;

-- Populate `comments` table with existing data
INSERT INTO comments("text_content","post_id","user_id") 
SELECT
    bc.text_content, 
    bc.post_id,
    u.id
FROM bad_comments AS bc 
INNER JOIN users AS u
ON bc.username = u.username;


-- Populate `votes` table with converted upvotes data 
INSERT INTO votes("post_id","user_id","vote_value")
    SELECT
        bp.id,
        u.id,
        1 AS upvote FROM 
        (SELECT "id", REGEXP_SPLIT_TO_TABLE("upvotes",',')AS upvote 
         FROM bad_posts) bp
JOIN users AS u
ON bp.upvote = u.username;

--Populate`votes`table with converted down votes data 
INSERT INTO votes ("post_id", "user_id", "vote_value")
    SELECT
    bp.id,
    u.id,
    -1ASdownvote FROM 
    (SELECT "id", REGEXP_SPLIT_TO_TABLE("downvotes",',')AS downvote 
    FROM bad_posts) bp
JOIN users AS u
ON bp.downvote = u.username;


