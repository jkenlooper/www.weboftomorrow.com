/* The Document table represents a file in `documents/` that can be rendered as
 * a web page.
 */

/* The stylesheet should be the name of a stylesheet file in `media/`. */

/* For format, set it to either 'md' or 'html'. */

/* The document references the filename of the document. */
/* The name is used in the route. */

CREATE TABLE Document (
  id integer PRIMARY KEY AUTOINCREMENT,
  description text,
  stylesheet varchar (255),
  name varchar (255) unique not null,
  document varchar (255) not null,
  format VARCHAR (50) DEFAULT html,
  title TEXT
);
