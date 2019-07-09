CREATE TABLE List (
  title TEXT,
  id INTEGER PRIMARY KEY,
  description TEXT NOT NULL,
  summary TEXT,
  slug TEXT UNIQUE
);
