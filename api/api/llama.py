from flask import json, request, abort
from flask.views import MethodView

from api.app import db
from api.database import fetch_query_string, rowify


class LlamaView(MethodView):
    """
    Handle llama queries
    """

    def post(self):
        args = {}
        xhr_data = request.get_json()
        if xhr_data:
            args.update(xhr_data)
        args.update(request.form.to_dict(flat=True))
        args.update(request.args.to_dict(flat=True))

        if len(args.keys()) == 0:
            abort(400)

        # Start db operations
        cur = db.cursor()

        llamas = 0
        result = cur.execute(fetch_query_string("get-llama-count.sql")).fetchall()
        if result:
            (result, col_names) = rowify(result, cur.description)
            llamas = result[0]["llamas"]

        # TODO: Process args for llamaness
        processed = {"llama-check": True, "count": llamas}

        db.commit()
        cur.close()

        return json.jsonify(processed)
