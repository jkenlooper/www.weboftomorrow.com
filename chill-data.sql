DROP TABLE if exists Chill;
DROP TABLE if exists Document;
DROP TABLE if exists List;
DROP TABLE if exists Document_List;
CREATE TABLE Node(
  id integer primary key autoincrement,
  name varchar(255),
  value text
  ,
  template integer references Template(id) on delete set null,
  query integer references Query(id) on delete set null
);
CREATE TABLE Node_Node(
  node_id integer,
  target_node_id integer,
  foreign key(node_id) references Node(id) on delete set null,
  foreign key(target_node_id) references Node(id) on delete set null
);
CREATE TABLE IF NOT EXISTS "Query"(
  id integer primary key autoincrement,
  name varchar(255) not null
);
CREATE TABLE Route(
  id integer primary key autoincrement,
  path text not null,
  node_id integer,
  weight integer default 0,
  method varchar(10) default 'GET',
  foreign key(node_id) references Node(id) on delete set null
);
CREATE TABLE Template(
  id integer primary key autoincrement,
  name varchar(255) unique not null
);
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Chill (version integer);
INSERT INTO Chill VALUES(1);
COMMIT;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Document (
  id integer PRIMARY KEY AUTOINCREMENT,
  description text,
  stylesheet varchar (255),
  name varchar (255) unique not null,
  document varchar (255) not null,
  format VARCHAR (50) DEFAULT html,
  title TEXT
);
INSERT INTO Document VALUES(2,'Opinions about some stuff in regard to web development','','opinions','opinions.md','md','An Opinionated Guide on Web Development');
INSERT INTO Document VALUES(5,'My experience with the Pomodoro technique',NULL,'pomo-projects','pomo-projects.md','md','Managing project time');
INSERT INTO Document VALUES(6,'Development of a Massively Multiplayer Online Jigsaw Puzzles website.','','puzzle-massive','puzzle-massive.html','html','Puzzle Massive - Massively Multiplayer Online Jigsaw Puzzles');
INSERT INTO Document VALUES(7,'Around 2007 I wrote a sample.css for CSS Zen Garden and never published it.','','old-css','old-css.md','md','Old CSS Zen Garden example');
INSERT INTO Document VALUES(8,'Examples of including code snippets into an article','chill-way-of-adding-code-snippets.css','chill-way-of-adding-code-snippets','chill-way-of-adding-code-snippets.md','md','The Chill way of adding code snippets');
INSERT INTO Document VALUES(9,'Developing a custom static site generator with Flask','','chill','chill.md','md','Chill - Database Driven Web Application Framework in Flask');
INSERT INTO Document VALUES(10,'Thinking out loud about data structure for Puzzle Massive Bit Icon Database Table','','puzzle-bit-icon-data-structure','puzzle-bit-icon-data-structure.md','md','Changing data structure for bit icons on Puzzle Massive');
INSERT INTO Document VALUES(11,'Card game that can be played on a plane or a train.',NULL,'cards-on-a-plane','cards-on-a-plane.md','md','Cards on a Plane - Simulating a deck of cards');
INSERT INTO Document VALUES(12,'Website for a pottery studio that I built and highlight some clever bits that I developed along the way.','','clever-bits-of-awesome-mud-works','clever-bits-of-awesome-mud-works.md','md','Awesome Mud Works - some clever bits');
COMMIT;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE List (title TEXT, id INTEGER PRIMARY KEY, description TEXT NOT NULL, summary TEXT, slug TEXT UNIQUE);
INSERT INTO List VALUES('Writings',1,'Collection of writings related to web development','','text');
INSERT INTO List VALUES('Side Projects',3,'Some side projects that I''ve done with some free time','','projects');
COMMIT;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Document_List (document INTEGER REFERENCES Document (id) ON DELETE CASCADE NOT NULL, list INTEGER REFERENCES List (id) ON DELETE CASCADE NOT NULL, weight INTEGER NOT NULL DEFAULT (0));
INSERT INTO Document_List VALUES(2,1,1);
INSERT INTO Document_List VALUES(5,1,0);
INSERT INTO Document_List VALUES(6,3,3);
INSERT INTO Document_List VALUES(7,1,2);
INSERT INTO Document_List VALUES(8,1,3);
INSERT INTO Document_List VALUES(9,3,2);
INSERT INTO Document_List VALUES(10,1,5);
INSERT INTO Document_List VALUES(11,3,4);
INSERT INTO Document_List VALUES(12,3,5);
COMMIT;
