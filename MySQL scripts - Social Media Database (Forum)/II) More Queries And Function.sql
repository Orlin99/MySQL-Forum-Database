CREATE DEFINER=`Orlin`@`%` FUNCTION `determinate_post_rating`(ID_of_post INT) RETURNS INT
    DETERMINISTIC
BEGIN
DECLARE date_of_the_post DATETIME;
DECLARE coefficient DOUBLE;
DECLARE score INT;

SET date_of_the_post = (SELECT date_of_post FROM posts WHERE post_ID = ID_of_post);

IF date_of_the_post > (CURDATE() - INTERVAL 1 DAY) THEN
   SET coefficient = 100.0;

ELSE IF date_of_the_post > (CURDATE() - INTERVAL 3 DAY) THEN
   SET coefficient = 50.0;

ELSE IF date_of_the_post > (CURDATE() - INTERVAL 7 DAY) THEN
   SET coefficient = 10.0;

ELSE IF date_of_the_post > (CURDATE() - INTERVAL 14 DAY) THEN
   SET coefficient = 5.0;

ELSE 
   SET coefficient = 1.0;

END IF;
END IF;
END IF;
END IF;

SET score = coefficient * (SELECT votes FROM posts WHERE post_ID = ID_of_post);
RETURN (score);
END

-----------------------------------------------------------------------------------------------------------------------------------------

SELECT title, content, users.username, determinate_post_rating(users.ID) FROM posts
JOIN users
ON posts.posted_by = users.ID
ORDER BY determinate_post_rating(users.ID) DESC
LIMIT 20;

SELECT post_ID, title, posts.content FROM posts
JOIN reports
ON posts.post_ID = reports.reported_post_ID;

SELECT post_ID, title, posts.content FROM posts
JOIN users
ON posts.posted_by = users.ID
JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 3;

SELECT post_ID, title, posts.content FROM posts
JOIN users
ON posts.posted_by = users.ID
JOIN reports
ON posts.post_ID = reports.reported_post_ID
JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 3
ORDER BY post_ID;

SELECT post_ID, title, posts.content FROM posts
JOIN users
ON posts.posted_by = users.ID
JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 3;

SELECT post_ID, title, posts.content FROM posts
JOIN reports
ON posts.post_ID = reports.reported_post_ID
WHERE author_ID = 2 AND 3; 