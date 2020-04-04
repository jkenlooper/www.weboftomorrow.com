select description, stylesheet as document_stylesheet, name, document, format, title as pagetitle from Document where name = :document_name;
