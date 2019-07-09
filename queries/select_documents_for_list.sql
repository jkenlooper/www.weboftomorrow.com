SELECT d.title, d.description, dl.weight, d.name as slug
FROM Document AS d
JOIN Document_List AS dl ON (d.id = dl.document)
JOIN List AS l ON (l.id = dl.list)
WHERE l.slug = :list_slug
order by weight desc;
