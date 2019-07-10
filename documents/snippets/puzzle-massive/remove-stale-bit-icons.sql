-- Currently, this is executed each time the app starts

UPDATE User SET icon = '' WHERE icon != '' AND (
    (score = 0 AND m_date < date('now', '-1 hour')) OR
    (score <= 5 AND m_date < date('now', '-10 hour')) OR
    (score <= 15 AND m_date < date('now', '-2 days')) OR
    (score <= 25 AND m_date < date('now', '-3 days')) OR
    (score <= 35 AND m_date < date('now', '-4 days')) OR
    (score <= 55 AND m_date < date('now', '-8 days')) OR
    (score <= 65 AND m_date < date('now', '-16 days')) OR
    (score <= 165 AND m_date < date('now', '-1 months')) OR
    (score <= 265 AND m_date < date('now', '-2 months')) OR
    (score <= 365 AND m_date < date('now', '-3 months')) OR
    (score <= 453 AND m_date < date('now', '-4 months')) OR
    (score <= (SELECT score FROM User WHERE icon != '' LIMIT 1 OFFSET 15)
        AND m_date < date('now', '-5 months'))
);
