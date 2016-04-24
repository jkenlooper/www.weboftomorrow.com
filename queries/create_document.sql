/* The Document table represents a file in `documents/` that can be rendered as
 * a web page.
 */

/* The stylesheet should be the name of a stylesheet file in `media/`. */

/* For format, set it to either 'md' or 'html'. */

/* node_id references the node that will have the filename of the document as
 * the value. This is commonly added with `chill operate` and the 'add document
 * for node'.
 */

CREATE TABLE Document (
  id integer PRIMARY KEY AUTOINCREMENT,
  description text,
  stylesheet varchar (255),
  node_id INTEGER REFERENCES Node (id) ON DELETE CASCADE,
  format VARCHAR (50) DEFAULT html
);
