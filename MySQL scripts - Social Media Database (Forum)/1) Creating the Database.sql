DROP DATABASE IF EXISTS forum;
CREATE DATABASE IF NOT EXISTS forum;

DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS commentsOnOtherComments;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS tag_content;
DROP TABLE IF EXISTS tags;

CREATE TABLE IF NOT EXISTS roles (
    roles_ID INT AUTO_INCREMENT,
    role ENUM('STANDARD', 'BANNED', 'MODERATOR', 'ADMIN'),
    PRIMARY KEY (roles_ID)
);
INSERT INTO roles (role) VALUES('STANDARD');
INSERT INTO roles (role) VALUES('BANNED');
INSERT INTO roles (role) VALUES('MODERATOR');
INSERT INTO roles (role) VALUES('ADMIN');

CREATE TABLE IF NOT EXISTS users (
    ID INT AUTO_INCREMENT,
    username VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(20) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(10) UNIQUE NOT NULL,
    registration_date DATETIME DEFAULT NOW(),
    PRIMARY KEY (ID),
    CHECK (LENGTH(username) >= 6 AND email REGEXP "^[a-zA-Z0-9][a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*?[a-zA-Z0-9._-]?@[a-zA-Z0-9][a-zA-Z0-9._-]*?[a-zA-Z0-9]?\\.[a-zA-Z]{2,63}$" AND LENGTH(phone_number) = 10)
);

CREATE TABLE IF NOT EXISTS user_role (
    role_ID INT,
    user_ID INT,
    PRIMARY KEY (role_ID , user_ID),
    CONSTRAINT FKey_user_role_roles FOREIGN KEY (role_ID) REFERENCES roles (roles_ID),
    CONSTRAINT FKey_user_role_users FOREIGN KEY (user_ID) REFERENCES users (ID)
);

CREATE TABLE IF NOT EXISTS categories (
    category_ID INT AUTO_INCREMENT,
    category_title VARCHAR(30) UNIQUE NOT NULL,
    PRIMARY KEY (category_ID)
);

CREATE TABLE IF NOT EXISTS posts (
    post_ID INT AUTO_INCREMENT,
    title VARCHAR(40) NOT NULL,
    content TEXT NOT NULL,
    date_of_post DATETIME DEFAULT NOW(),
    views INT DEFAULT 0,
    votes INT DEFAULT 0,
    posted_by INT,
    category INT NOT NULL,
    PRIMARY KEY (post_ID),
    CONSTRAINT FKey_posts_users FOREIGN KEY (posted_by) REFERENCES users (ID),
    CONSTRAINT FKey_posts_categories FOREIGN KEY (category) REFERENCES categories (category_ID),
    CHECK (views >= 0),
    CHECK (votes >= 0)
);

CREATE TABLE IF NOT EXISTS comments (
    comment_ID INT AUTO_INCREMENT,
    content TEXT NOT NULL,
    date_of_comment DATETIME DEFAULT NOW(),
    views INT DEFAULT 0,
    votes INT DEFAULT 0,
    comment_by INT,
    comment_on INT,
    PRIMARY KEY (comment_ID),
    CONSTRAINT FKey_comments_users FOREIGN KEY (comment_by) REFERENCES users (ID),
    CONSTRAINT FKey_comments_posts FOREIGN KEY (comment_on) REFERENCES posts (post_ID),
    CHECK (views >= 0),
    CHECK (votes >= 0)
);

CREATE TABLE IF NOT EXISTS comments_on_other_comments (
    comments_on_other_comments_ID INT AUTO_INCREMENT,
    content VARCHAR(255) NOT NULL,
    date_of_comment_on_other_comment DATETIME DEFAULT NOW(),
    views INT DEFAULT 0,
    votes INT DEFAULT 0,
    comment_by INT,
    comment_on INT,
    PRIMARY KEY (comments_on_other_comments_ID),
    CONSTRAINT FKey_cooc_users FOREIGN KEY (comment_by) REFERENCES users (ID),
    CONSTRAINT FKey_cooc_comments FOREIGN KEY (comment_on) REFERENCES comments (comment_ID),
    CHECK (views >= 0),
    CHECK (votes >= 0)
);

CREATE TABLE IF NOT EXISTS reports (
    report_ID INT AUTO_INCREMENT,
    content TEXT NOT NULL,
    author_ID INT NOT NULL,
    reported_post_ID INT,
    reported_comment_ID INT,
    reported_comment_on_other_comment_ID INT,
    PRIMARY KEY (report_ID),
    CHECK (reported_post_ID IS NOT NULL XOR reported_comment_ID IS NOT NULL XOR reported_comment_on_other_comment_ID IS NOT NULL),
    CONSTRAINT FKey_reports_users FOREIGN KEY (author_ID) REFERENCES users (ID),
    CONSTRAINT FKey_reports_posts FOREIGN KEY (reported_post_ID) REFERENCES posts (post_ID),
    CONSTRAINT FKey_reports_comments FOREIGN KEY (reported_comment_ID) REFERENCES comments (comment_ID),
    CONSTRAINT FKey_reports_cooc FOREIGN KEY (reported_comment_on_other_comment_ID) REFERENCES comments_on_other_comments (comments_on_other_comments_ID)
);

CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_ID INT AUTO_INCREMENT,
    subscription_by INT NOT NULL,
    subscription_on INT NOT NULL,
    PRIMARY KEY (subscription_ID),
    CONSTRAINT FKey_subscriptions_users FOREIGN KEY (subscription_by) REFERENCES users (ID),
    CONSTRAINT FKey_subscriptions_posts FOREIGN KEY (subscription_on) REFERENCES posts (post_ID)
);

CREATE TABLE IF NOT EXISTS tag_content (
    tag_content_ID INT AUTO_INCREMENT,
    the_tag_content varchar(255),
    PRIMARY KEY (tag_content_ID)
);

CREATE TABLE IF NOT EXISTS tags (
    tag_to_tag_content INT,
    tag_to_post INT,
    CONSTRAINT FKey_tags_tag_content FOREIGN KEY (tag_to_tag_content) REFERENCES tag_content (tag_content_ID),
    CONSTRAINT FKey_tags_posts FOREIGN KEY (tag_to_post) REFERENCES posts (post_ID)
);

SELECT * FROM users;
SELECT * FROM roles;
SELECT * FROM user_role;
SELECT * FROM categories;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM comments_on_other_comments;
SELECT * FROM reports;
SELECT * FROM subscriptions;
SELECT * FROM tag_content;
SELECT * FROM tags;

SELECT username AS ADMIN FROM users
RIGHT JOIN  user_role
ON users.ID = user_role.user_ID
WHERE user_role.role_ID = 4;

SELECT username AS MODERATOR FROM users
RIGHT JOIN user_role 
ON users.ID = user_role.user_ID
WHERE user_role.role_ID = 3;

SELECT username AS BANNED FROM users
RIGHT JOIN  user_role
ON users.ID = user_role.user_ID
WHERE user_role.role_ID = 2;
