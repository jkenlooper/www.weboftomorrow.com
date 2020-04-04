import os
import sqlite3


def get_db(config):
    db = sqlite3.connect(config.get("SQLITE_DATABASE_URI"))

    # Enable foreign key support so 'on update' and 'on delete' actions
    # will apply. This needs to be set for each db connection.
    cur = db.cursor()
    cur.execute("pragma foreign_keys = ON;")
    db.commit()

    # Check that journal_mode is set to wal
    result = cur.execute("pragma journal_mode;").fetchone()
    if result[0] != "wal":
        raise sqlite3.IntegrityError("The pragma journal_mode is not set to wal.")

    cur.close()

    return db


def files_loader(*args):
    """
    Loads all the files in each directory as values in a dict with the key
    being the relative file path of the directory.  Updates the value if
    subsequent file paths are the same.
    """
    d = dict()

    def load_files(folder):
        for (dirpath, dirnames, filenames) in os.walk(folder):
            for f in filenames:
                filepath = os.path.join(dirpath, f)
                with open(filepath, "r") as f:
                    key = filepath[len(os.path.commonprefix([root, filepath])) + 1 :]
                    d[key] = f.read()

    for root in args:
        load_files(root)
    return d
