CREATE TABLE Person(
person_id DECIMAL(12) NOT NULL,
first_name VARCHAR(32) NOT NULL,
last_name VARCHAR(32) NOT NULL,
username VARCHAR(20) NOT NULL,
PRIMARY KEY (person_id));
CREATE TABLE Post(
post_id DECIMAL(12) NOT NULL,
person_id DECIMAL(12) NOT NULL,
content VARCHAR(255) NOT NULL,
created_on DATE NOT NULL,
summary VARCHAR(15) NOT NULL,
PRIMARY KEY (post_id),
FOREIGN KEY (person_id) REFERENCES Person(person_id));
CREATE TABLE Likes (
likes_id DECIMAL(12) NOT NULL,
person_id DECIMAL(12) NOT NULL,
post_id DECIMAL(12) NOT NULL,
liked_on DATE NOT NULL,
PRIMARY KEY (likes_id),
FOREIGN KEY (person_id) REFERENCES Person(person_id),
FOREIGN KEY (post_id) REFERENCES Post(post_id));

--Person
INSERT INTO Person VALUES(1,'John','Smith','jsmith');
INSERT INTO Person VALUES(2,'Mary','Berman','mber');
INSERT INTO Person VALUES(3,'Elizabeth','Johnson','ejohn');
INSERT INTO Person VALUES(4,'Peter','Quigley','pqui');
INSERT INTO Person VALUES(5,'Stanton','Hurley','stanley');
--Post
INSERT INTO Post VALUES(101,1,'Put some food in the Plate.','12-18-2005', 'Put some foo...');
INSERT INTO Post VALUES(102,1,'Soup in the Bowl is cold.','12-15-2005', 'Soup in the ...');
INSERT INTO Post VALUES(201,2,'Can you please pass me that Knife?','12-25-2005', 'Can you plea...');
INSERT INTO Post VALUES(202,2,'Can you please pass me that Fork?','12-27-2005', 'Can you plea...');
INSERT INTO Post VALUES(301,3,'Can you please pass me that Spoon?','12-13-2005', 'Can you plea...');
INSERT INTO Post VALUES(302,3,'Cup is used to drink tea not wine.','12-30-2005', 'Cup is used ...');
INSERT INTO Post VALUES(401,4,'Jyoti is a horrible person.','12-07-2005', 'Jyoti is a h...');
INSERT INTO Post VALUES(402,4,'Wang Yibo wins everything.','12-06-2005', 'Wang Yibo wi...');
INSERT INTO Post VALUES(501,5,'Elves are gonna take over the world.','12-25-2005', 'Elves are go...');
INSERT INTO Post VALUES(502,5,'The first snow is so beautiful.','12-08-2005', 'The first sn...');
--Likes
INSERT INTO Likes VALUES(1001,2,101,CAST('18-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(1002,3,101,CAST('27-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(1003,4,101,CAST('18-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(1004,5,101,CAST('18-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(2001,1,201,CAST('27-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(2002,3,201,CAST('29-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(3001,5,301,CAST('19-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(4001,1,401,CAST('20-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(5001,4,501,CAST('28-DEC-2005' AS DATE));

CREATE PROCEDURE add_zana_sage
AS
BEGIN
INSERT INTO Person VALUES(6,'Zana','Sage','zsage');
END;

EXECUTE add_zana_sage;

SELECT *
FROM Person;

EXECUTE add_zana_sage;

CREATE PROCEDURE add_person -- Create a new Person
@person_id_arg DECIMAL(12), -- The new Person's ID.
@first_name_arg VARCHAR(32), -- The new Person’s first name.
@last_name_arg VARCHAR(32), -- The new Person's last name.
@username_arg VARCHAR(20) -- The new Person's username.
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
-- Insert the new Person with a username.
INSERT INTO Person (person_id,first_name,last_name,username)
VALUES(@person_id_arg,@first_name_arg,@last_name_arg,@username_arg);
END;

EXECUTE add_person 7,'Mary','Smith','msmit'


SELECT *
FROM Person;

CREATE PROCEDURE add_post
@p_post_id DECIMAL(12), -- The new post ID, must be unused
@p_person_id DECIMAL(12), -- The associated person ID, must be of existing person
@p_content VARCHAR(255), -- The post's content
@p_created_on DATE -- The post's creation date
AS
BEGIN
DECLARE @v_summary VARCHAR(15); --Declare a variable to hold summary of post.
--Calculate the summary value and put it into the variable.
SET @v_summary = CONCAT(SUBSTRING(@p_content,1,12), '...');
--Insert a row with the combined values of the parameters and the variable.
INSERT INTO Post VALUES(@p_post_id, @p_person_id, @p_content, @p_created_on, @v_summary);
END;

EXECUTE add_post 103,1,'We need a 100 $ bill.','12-09-2005'

SELECT *
FROM Post;

CREATE PROCEDURE add_like
@p_likes_id DECIMAL(12), -- The id of the like.
@p_post_id DECIMAL(12), -- The ID of the post for the like.
@p_liked_on DATE, -- The date of the like.
@p_username VARCHAR(20) -- The username of the person.
AS
BEGIN
DECLARE @v_person_id DECIMAL(12); --Declare a variable to hold the ID of the username.
--Get the person_id based upon the username.
SELECT @v_person_id=person_id
FROM Person
WHERE username = @p_username;
--Insert the new like.
INSERT INTO Likes VALUES(@p_likes_id, @v_person_id, @p_post_id, @p_liked_on);
END;

EXECUTE add_like 3002,301,'12-15-2005','zsage'

SELECT *
FROM Likes;

CREATE PROCEDURE delete_person
@p_username VARCHAR(20)
AS
BEGIN
--Declare a variable to hold the ID of the username
DECLARE @v_person_id DECIMAL(12);
--Get the person_id based upon the username.
SELECT @v_person_id=person_id
FROM Person
WHERE username = @p_username;
--Delete all likes associated with posts associated with the person id.
DELETE FROM Likes
WHERE person_id = @v_person_id;
--Disable foreign key constraint so record can be deleted
ALTER TABLE [master].[dbo].[Likes] NOCHECK CONSTRAINT [FK__Likes__post_id__278EDA44]
--Delete all posts associated with the person.
DELETE FROM Post
WHERE person_id = @v_person_id;
--Delete the Person.
DELETE FROM Person
WHERE username = @p_username;
--Enable foreign key constraint
ALTER TABLE [master].[dbo].[Likes] CHECK CONSTRAINT FK__Likes__post_id__278EDA44
END;

EXECUTE delete_person 'pqui'

SELECT *
FROM Person;
SELECT *
FROM Post;
SELECT *
FROM Likes;

CREATE TRIGGER correct_summary_trg
ON Post AFTER INSERT
AS
BEGIN
DECLARE @content VARCHAR(255);
DECLARE @summary VARCHAR(15);
SET @content=(SELECT INSERTED.content FROM INSERTED);
SET @summary=(SELECT INSERTED.summary FROM INSERTED);
IF @summary != CONCAT(SUBSTRING(@content,1,12), '...')
BEGIN
ROLLBACK;
RAISERROR('Wrong summary entered',14,1);
END;
END;

INSERT INTO Post VALUES(203,2,'Elves are gonna take over the world.','12-25-2005', 'Elves are go...');
INSERT INTO Post VALUES(303,3,'The first snow is so beautiful.','12-08-2005', 'The first ...');

SELECT *
FROM Post;

CREATE TRIGGER like_trg
ON Likes AFTER INSERT,UPDATE
AS
BEGIN
DECLARE @v_like_date DATE;
DECLARE @v_post_create_date DATE;
SELECT @v_like_date=INSERTED.liked_on,
@v_post_create_date=created_on
FROM Post
JOIN INSERTED ON INSERTED.post_id = Post.post_id;
IF @v_like_date < @v_post_create_date
BEGIN
ROLLBACK;
RAISERROR('The liked date is less than post creation date',14,1);
END;
END;

INSERT INTO Likes VALUES(3003,1,301,CAST('20-DEC-2005' AS DATE));
INSERT INTO Likes VALUES(5001,3,501,CAST('20-DEC-2005' AS DATE));

SELECT *
FROM Likes;

CREATE TABLE post_content_history (
post_id DECIMAL(12) NOT NULL,
old_content VARCHAR(255) NOT NULL,
new_content VARCHAR(255) NOT NULL,
change_date DATE NOT NULL,
FOREIGN KEY (post_id) REFERENCES Post(post_id));

CREATE TRIGGER content_history_trg
ON Post AFTER UPDATE
AS
BEGIN
DECLARE @v_old_content VARCHAR(255) = (SELECT content FROM DELETED);
DECLARE @v_new_content VARCHAR(255) = (SELECT content FROM INSERTED);
DECLARE @v_post_id DECIMAL(12) = (SELECT post_id FROM INSERTED);
IF @v_old_content <> @v_new_content
BEGIN
INSERT INTO post_content_history VALUES(@v_post_id, @v_old_content, @v_new_content, GETDATE());
END;
END;

UPDATE Post
SET content = 'Can you please stop calling me?'
WHERE post_id = 203;

SELECT *
FROM post_content_history;