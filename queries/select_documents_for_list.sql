SELECT d.title, d.description, dl.weight, n.name as slug
FROM Document AS d
JOIN Document_List AS dl ON (d.id = dl.document)
JOIN List AS l ON (l.id = dl.list)
JOIN Node as n ON (n.id = d.node_id)
WHERE l.slug = :list_slug
order by weight desc;
