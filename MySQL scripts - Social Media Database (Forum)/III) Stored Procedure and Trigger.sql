CREATE DEFINER=`Orlin`@`%` PROCEDURE `news_feed`(user_ID INT)
BEGIN

SET user_ID = (SELECT ID FROM users WHERE ID = user_ID);

SELECT title, content, date_of_post FROM posts
WHERE date_of_post >= NOW() - INTERVAL 1 WEEK
ORDER BY date_of_post ASC
LIMIT 20;

SELECT post_ID, title, posts.content, determinate_post_rating(posted_by) FROM posts
ORDER BY determinate_post_rating(posted_by) DESC
LIMIT 20;

SELECT posts.post_ID, posts.title, posts.posted_by, comment_ID, comments.comment_by, comments.content, date_of_comment FROM comments
JOIN posts
ON comments.comment_on = posts.post_ID
JOIN subscriptions
ON posts.post_ID = subscriptions.subscription_on
WHERE date_of_comment >= NOW() - INTERVAL 20 DAY AND subscription_by = user_ID
ORDER BY determinate_post_rating(posted_by);

END


call forum.news_feed(1);
call forum.news_feed(2);
call forum.news_feed(18);
call forum.news_feed(35);
call forum.news_feed(24);
call forum.news_feed(43);
call forum.news_feed(57);
call forum.news_feed(61);
call forum.news_feed(100);

-----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_activity_log (
user_ID INT AUTO_INCREMENT,
date DATETIME DEFAULT NOW(),
activity TEXT NOT NULL,
PRIMARY KEY (user_ID)
);

DROP TRIGGER IF EXISTS new_post_published;
DROP TRIGGER IF EXISTS new_comment_published;
DROP TRIGGER IF EXISTS post_reported;

CREATE TRIGGER new_post_published
AFTER INSERT ON posts
FOR EACH ROW
INSERT INTO user_activity_log
SET activity = CONCAT('Published new post ', NEW.post_ID, ' with title ', NEW.title);

INSERT INTO posts (title, content, posted_by, category) VALUES ('Experiment Post', 'This post aims to see if the TRIGGER named new_post_published is working', 1, 12);

CREATE TRIGGER new_comment_published
AFTER INSERT ON comments
FOR EACH ROW
INSERT INTO user_activity_log
SET activity = CONCAT('Published a new comment ', NEW.comment_ID, ' on post ', NEW.comment_on);

INSERT INTO comments (content, comment_by, comment_on) VALUES ('This comment aims to check if the TRIGGER named new_comment_published is working', 2, 302);

CREATE TRIGGER post_reported
AFTER INSERT ON reports
FOR EACH ROW
INSERT INTO user_activity_log
SET activity = CONCAT('Reported post ', NEW.reported_post_ID, ' with title ', (SELECT posts.title FROM posts WHERE NEW.reported_post_ID = posts.post_ID));

INSERT INTO reports (content, author_ID, reported_post_ID) VALUES ('Report TEST for the TRIGGER named post_reported', 3, 302);

SELECT * FROM user_activity_log;

-----------------------------------------------------------------------------------------------------------------------------------------

-- HERE




