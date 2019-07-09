/*
select n.value as document, n.name, d.stylesheet as document_stylesheet, d.description, d.format, d.title from Node as n
join Document as d on d.node_id = n.id
 where n.name = :document;
 */

select description, stylesheet as document_stylesheet, name as document, format, title from Document where name = :document;
