CREATE TABLE Document_List (
  document INTEGER REFERENCES Document (id) ON DELETE CASCADE NOT NULL,
  list INTEGER REFERENCES List (id) ON DELETE CASCADE NOT NULL,
  weight INTEGER NOT NULL DEFAULT (0)
);