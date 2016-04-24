select n.value as document, n.name, d.stylesheet as document_stylesheet, d.description, d.format from Node as n
join Document as d on d.node_id = n.id
 where n.name = :document;
