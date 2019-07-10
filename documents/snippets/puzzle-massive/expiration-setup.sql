CREATE TABLE BitExpiration (score INTEGER, id INTEGER PRIMARY KEY, extend TEXT);
CREATE TABLE BitAuthor (id INTEGER PRIMARY KEY, name TEXT, artist_document TEXT);
CREATE TABLE BitIcon (id INTEGER PRIMARY KEY, user INTEGER REFERENCES User (id), author INTEGER REFERENCES BitAuthor (id), name TEXT UNIQUE, last_viewed TEXT, expiration TEXT);

-- Set the BitExpiration table data
INSERT INTO BitExpiration (score, id, extend) VALUES (0, 1, '+1 hour');
INSERT INTO BitExpiration (score, id, extend) VALUES (5, 2, '+10 hours');
INSERT INTO BitExpiration (score, id, extend) VALUES (15, 3, '+2 days');
-- ... more inserts ...
INSERT INTO BitExpiration (score, id, extend) VALUES (265, 4, '+2 months');
INSERT INTO BitExpiration (score, id, extend) VALUES (365, 5, '+3 months');


-- Update this each time a player earns a point
UPDATE BitIcon SET
expiration = (
  SELECT datetime('now', (
    SELECT be.extend FROM BitExpiration AS be
      JOIN BitIcon AS b
      JOIN User AS u ON u.id = b.user
       WHERE u.score > be.score AND u.id = :user
       ORDER BY be.score DESC LIMIT 1
    )
  )
)
WHERE user = :user;

-- The icon name comes from the BitIcon table now and has an expiration date
SELECT u.id, b.name AS icon, u.score, u.m_date, b.expiration
  FROM BitIcon AS b
  JOIN User AS u ON u.id = b.user
WHERE u.id = :user;
