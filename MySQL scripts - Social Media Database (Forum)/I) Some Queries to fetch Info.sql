SELECT username FROM users
ORDER BY ID;

SELECT username AS USERNAME, email
FROM users ORDER BY id;

SELECT content FROM comments
WHERE date_of_comment BETWEEN '2022-05-30 12:40:00' AND '2022-05-31 12:40:00';

SELECT username AS ADMIN_OR_MODERATOR FROM users
LEFT JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 4 OR role_ID =3
ORDER BY role_ID DESC;

SELECT * FROM posts
ORDER BY views ASC;

SELECT * FROM users
WHERE email LIKE '%@gmail.com';

SELECT username AS BANNED FROM users
LEFT JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 2;

SELECT title, content, date_of_post,category FROM posts
ORDER BY date_of_post DESC
LIMIT 20;

SELECT users.username, COUNT(*) AS COUNT FROM posts
JOIN users
ON posts.posted_by = users.ID
GROUP BY posted_by
ORDER BY COUNT DESC;

SELECT post_ID, title, content FROM posts
JOIN users
ON users.ID = posts.posted_by 
JOIN user_role
ON users.ID = user_role.user_ID
WHERE role_ID = 3
ORDER BY post_ID;

SELECT posts.title, posts.content, COUNT(*) AS COUNT FROM reports
JOIN posts
ON reports.reported_post_ID = posts.post_ID
GROUP BY reported_post_ID
ORDER BY COUNT DESC;

SELECT comments.comment_ID, comments.content FROM comments
JOIN posts
ON comments.comment_on = posts.post_ID
JOIN subscriptions
ON posts.post_ID = subscriptions.subscription_on
WHERE date_of_comment BETWEEN '2022-05-29 16:10:00' AND '2022-05-31 16:10:00'
AND subscription_by = 1;

INSERT INTO users (username, password_hash, email, phone_number) VALUES ('Orlin99', 'NiMoA!', 'orlin111@bing.com', '0882123456');
INSERT INTO user_role (user_ID,role_ID) VALUES (61,1);

SELECT post_ID, title, posts.content, comments.comment_ID FROM posts
LEFT JOIN comments
ON posts.post_ID = comments.comment_on
WHERE comment_ID IS NULL;

SELECT username, email, posts.posted_by, comments.comment_by FROM users
LEFT JOIN posts
ON users.ID = posts.posted_by
LEFT JOIN comments
ON users.ID = comments.comment_by
WHERE posted_by IS NULL AND comment_by IS NULL;

SELECT ID, username, email FROM users
JOIN user_role
ON users.ID = user_role.user_ID
ORDER BY role_ID DESC, registration_date ASC;