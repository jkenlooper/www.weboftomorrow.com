import os
import sys

from werkzeug.local import LocalProxy
from flask import Flask, g, current_app
import sqlite3

from api.tools import get_db, files_loader


class API(Flask):
    "API App"


def set_db():
    db = getattr(g, "_database", None)
    if db is None:
        db = g._database = get_db(current_app.config)
    return db


db = LocalProxy(set_db)


def make_app(config=None, **kw):
    app = API("api")

    if config:
        config_file = (
            config if config[0] == os.sep else os.path.join(os.getcwd(), config)
        )
        app.config.from_pyfile(config_file)

    app.config.update(kw)

    app.queries = files_loader("queries")

    @app.teardown_appcontext
    def teardown_db(exception):
        db = getattr(g, "_database", None)
        if db is not None:
            db.close()

    # Import the views
    from llama import LlamaView

    # Register the views
    app.add_url_rule("/llama/", view_func=LlamaView.as_view("llama"))

    return app


def main():
    from gevent import pywsgi

    config_file = sys.argv[1]
    app = make_app(config=config_file)
    app.debug = app.config.get("DEBUG")

    if app.debug:
        app.run(
            host="127.0.0.1", port=app.config.get("PORTAPI"), use_reloader=True,
        )
    else:
        server = pywsgi.WSGIServer(("127.0.0.1", app.config.get("PORTAPI")), app)
        server.serve_forever(stop_timeout=10)


if __name__ == "__main__":
    main()
