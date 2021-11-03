PRAGMA foreign_keys = ON; 

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL, 
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY associated_author_id REFERENCES users(id)
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
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,

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
    ('Andy', 'Yu')
    ('Susan', 'Zea');

INSERT INTO 
    questions (title, body, associated_author_id)
VALUES  
    ('Help', 'How do I do my HW', SELECT id FROM users WHERE fname = 'Susan')
    ('How do I plunge a toilet', 'Please, I really need to', SELECT id FROM users WHERE fname = 'Andy');

INSERT TO 
    question_follows (user_id, question_id)
VALUES  
    ((SELECT id FROM users WHERE fname = 'Susan'),  )