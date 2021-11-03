DROP table if exists question_likes;
DROP table if exists replies;
DROP table if exists question_follows;
DROP table if exists questions;
DROP table if exists users;
PRAGMA foreign_keys = ON; 

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL 
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY (associated_author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_reply_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    liker_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (liker_id) REFERENCES users(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Susan', 'Zea'),
    ('Andy', 'Yu');

INSERT INTO 
    questions (title, body, associated_author_id)
VALUES  
    ('Help', 'How do I do my HW', (SELECT id FROM users WHERE fname = 'Susan')),
    ('How do I plunge a toilet', 'Please, I really need to', (SELECT id FROM users WHERE fname = 'Andy'));

INSERT INTO 
    question_follows (user_id, question_id)
VALUES  
    ((SELECT id FROM users WHERE fname = 'Susan'), 1 );


INSERT INTO 
    replies (question_id, author_id, body, parent_reply_id)
VALUES  
    ((SELECT id FROM questions WHERE title = 'Help'), (SELECT id FROM users WHERE fname = 'Andy'), 'look at the solution jk');

INSERT INTO
    question_likes (question_id, liker_id)
VALUES 
    ((SELECT id FROM questions WHERE title = 'Help'), (SELECT id FROM users WHERE fname = 'Andy'));
