PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Node_Node (
    node_id integer,
    target_node_id integer,
    foreign key ( node_id ) references Node ( id ) on delete set null,
    foreign key ( target_node_id ) references Node ( id ) on delete set null
);
INSERT INTO "Node_Node" VALUES(6,8);
INSERT INTO "Node_Node" VALUES(5,6);
INSERT INTO "Node_Node" VALUES(6,10);
INSERT INTO "Node_Node" VALUES(6,11);
INSERT INTO "Node_Node" VALUES(5,12);
INSERT INTO "Node_Node" VALUES(5,14);
INSERT INTO "Node_Node" VALUES(6,17);
INSERT INTO "Node_Node" VALUES(NULL,19);
INSERT INTO "Node_Node" VALUES(19,20);
INSERT INTO "Node_Node" VALUES(19,21);
INSERT INTO "Node_Node" VALUES(NULL,22);
INSERT INTO "Node_Node" VALUES(22,23);
INSERT INTO "Node_Node" VALUES(22,24);
INSERT INTO "Node_Node" VALUES(NULL,25);
INSERT INTO "Node_Node" VALUES(25,26);
INSERT INTO "Node_Node" VALUES(25,27);
INSERT INTO "Node_Node" VALUES(17,NULL);
INSERT INTO "Node_Node" VALUES(5,28);
INSERT INTO "Node_Node" VALUES(29,30);
INSERT INTO "Node_Node" VALUES(30,31);
INSERT INTO "Node_Node" VALUES(30,32);
INSERT INTO "Node_Node" VALUES(29,33);
INSERT INTO "Node_Node" VALUES(33,34);
INSERT INTO "Node_Node" VALUES(33,35);
INSERT INTO "Node_Node" VALUES(29,36);
INSERT INTO "Node_Node" VALUES(36,37);
INSERT INTO "Node_Node" VALUES(36,38);
INSERT INTO "Node_Node" VALUES(5,29);
INSERT INTO "Node_Node" VALUES(42,43);
INSERT INTO "Node_Node" VALUES(42,6);
CREATE TABLE Node (
    id integer primary key autoincrement,
    name varchar(255),
    value text
    , template integer references Template (id) on delete set null, query integer references Query (id) on delete set null);
INSERT INTO "Node" VALUES(5,'homepage',NULL,1,1);
INSERT INTO "Node" VALUES(6,'site',NULL,NULL,1);
INSERT INTO "Node" VALUES(7,'footer_copy',NULL,NULL,NULL);
INSERT INTO "Node" VALUES(8,'footer_copy','footer_copy.md',NULL,NULL);
INSERT INTO "Node" VALUES(10,'location','Salt Llama City',NULL,NULL);
INSERT INTO "Node" VALUES(11,'contact','bob',NULL,NULL);
INSERT INTO "Node" VALUES(12,'description','homepage-description.txt',NULL,NULL);
INSERT INTO "Node" VALUES(14,'logo_large',NULL,3,11);
INSERT INTO "Node" VALUES(17,'bottom_nav',NULL,NULL,1);
INSERT INTO "Node" VALUES(28,'foreword','foreword.md',NULL,NULL);
INSERT INTO "Node" VALUES(29,'toc',NULL,5,1);
INSERT INTO "Node" VALUES(30,'toc_item',NULL,NULL,1);
INSERT INTO "Node" VALUES(31,'slug','cama',NULL,NULL);
INSERT INTO "Node" VALUES(32,'title','Cama, a crossbreed between a llama and a camel',NULL,NULL);
INSERT INTO "Node" VALUES(33,'toc_item',NULL,NULL,1);
INSERT INTO "Node" VALUES(34,'slug','alpaca',NULL,NULL);
INSERT INTO "Node" VALUES(35,'title','An alpaca (Vicugna pacos) is a domesticated species of South American camelid',NULL,NULL);
INSERT INTO "Node" VALUES(36,'toc_item',NULL,NULL,1);
INSERT INTO "Node" VALUES(37,'slug','guard-llama',NULL,NULL);
INSERT INTO "Node" VALUES(38,'title','Guard llama, llamas used as livestock guardians',NULL,NULL);
INSERT INTO "Node" VALUES(39,'alpaca','alpaca.md',NULL,NULL);
INSERT INTO "Node" VALUES(40,'cama','cama.html',NULL,NULL);
INSERT INTO "Node" VALUES(41,'guard-llama','guard-llama.md',NULL,NULL);
INSERT INTO "Node" VALUES(42,'documentpage',NULL,6,1);
INSERT INTO "Node" VALUES(43,'content',NULL,NULL,15);
CREATE TABLE Route (
    id integer primary key autoincrement,
    path text not null,
    node_id integer,
    weight integer default 0,
    method varchar(10) default 'GET',
    foreign key ( node_id ) references Node ( id ) on delete set null
);
INSERT INTO "Route" VALUES(2,'/',5,'','GET');
INSERT INTO "Route" VALUES(4,'/<document>/',42,'','GET');
CREATE TABLE "Query" (
    id integer primary key autoincrement,
    name varchar(255) not null
);
INSERT INTO "Query" VALUES(1,'select_link_node_from_node.sql');
INSERT INTO "Query" VALUES(11,'select_picture_for_node.sql');
INSERT INTO "Query" VALUES(15,'select_document_for_name.sql');
CREATE TABLE Template (
    id integer primary key autoincrement,
    name varchar(255) unique not null
);
INSERT INTO "Template" VALUES(1,'homepage.html');
INSERT INTO "Template" VALUES(3,'logo_large.html');
INSERT INTO "Template" VALUES(5,'toc.html');
INSERT INTO "Template" VALUES(6,'documentpage.html');
CREATE TABLE Picture (
  id integer primary key autoincrement,
  picturename varchar(64) unique not null,
  /* picturename:
    For user use only, or for listing in
    a management interface, could also be used for
    the shown filename.
    */
  artdirected boolean default false,
    -- Hint for the template to use <picture> or <img[srcset]>.
  title text,
  description text,
  author integer references Node (id),
  created text,
    /* TODO: remove 'image' here and use a Picture_Image table instead so there
     * can be multiple images linked to a picture. */
  image integer references Image (id) not null,
  /*
   * image is not null as its used as the src attribute in img tag. <picture>
   * requires having an img.
   */
  original integer references Image (id)
);
INSERT INTO "Picture" VALUES(2,'logo','false','logo','','','',2,NULL);
CREATE TABLE Image (
  id integer primary key autoincrement,
  width integer not null,
  height integer not null,
  srcset integer references Srcset (id),
  staticfile integer references StaticFile (id) not null
);
INSERT INTO "Image" VALUES(2,213,213,NULL,2);
CREATE TABLE Srcset (
  id integer primary key autoincrement,
  picture integer references Picture (id)
);
CREATE TABLE StaticFile (
  id integer primary key autoincrement,
  path varchar(255) not null,
  contenttype varchar(64)
);
INSERT INTO "StaticFile" VALUES(2,'box.svg',NULL);
CREATE TABLE Node_Picture (
    node_id integer references Node (id) not null,
    picture integer references Picture (id) not null
);
INSERT INTO "Node_Picture" VALUES(14,2);
CREATE TABLE Chill (version integer);
INSERT INTO "Chill" VALUES(1);
CREATE TABLE Document (
  id integer PRIMARY KEY AUTOINCREMENT,
  description text,
  stylesheet varchar (255),
  node_id INTEGER REFERENCES Node (id) ON DELETE CASCADE,
  format VARCHAR (50) DEFAULT html
);
INSERT INTO "Document" VALUES(1,'Description for alpaca',NULL,39,'md');
INSERT INTO "Document" VALUES(2,'a Cama',NULL,40,'html');
INSERT INTO "Document" VALUES(3,'A guard llama',NULL,41,'md');
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('Node',43);
INSERT INTO "sqlite_sequence" VALUES('Route',4);
INSERT INTO "sqlite_sequence" VALUES('Query',15);
INSERT INTO "sqlite_sequence" VALUES('Template',6);
INSERT INTO "sqlite_sequence" VALUES('StaticFile',2);
INSERT INTO "sqlite_sequence" VALUES('Image',2);
INSERT INTO "sqlite_sequence" VALUES('Picture',2);
INSERT INTO "sqlite_sequence" VALUES('Document',3);
COMMIT;
