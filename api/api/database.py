from builtins import zip
import os

from flask import current_app


def rowify(l, description):
    d = []
    col_names = []
    if l != None and description != None:
        col_names = [x[0] for x in description]
        for row in l:
            d.append(dict(list(zip(col_names, row))))
    return (d, col_names)


def fetch_query_string(file_name):
    content = current_app.queries.get(file_name, None)

    if content == None:
        current_app.logger.info(
            "queries file: '%s' not available. Checking file system..." % file_name
        )
        file_path = os.path.join("queries", file_name)
        if os.path.isfile(file_path):
            with open(file_path, "r") as f:
                content = r.read()
                current_app.queries[file_name] = content
        else:
            raise Exception("File not found: {}".format(file_name))

    return content


def read_query_file(file_name):
    """
    Read the sql file content without requiring app context.  Useful for simple
    scripts to load the same query files from the root.
    """
    file_path = os.path.join("queries", file_name)
    if os.path.isfile(file_path):
        with open(file_path, "r") as f:
            return f.read()
    else:
        raise Exception("File not found: {}".format(file_path))
