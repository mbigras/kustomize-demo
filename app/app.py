import os

import flask

app = flask.Flask("app")

app.config["env"] = os.environ["ENV"]
app.config["color"] = os.environ["COLOR"]
app.config["password"] = os.environ["PASSWORD"]
app.config["features"] = []
if os.environ.get("FEATURE1", "") == "on":
    app.config["features"].append("feature1")
if os.environ.get("FEATURE2", "") == "on":
    app.config["features"].append("feature2")
app.json_provider_class.compact = False  # see https://stackoverflow.com/questions/76134147/how-do-you-work-around-deprecated-prettyprint-regular-flask-setting/76134552/76134552 answer.
app.json.sort_keys = False


@app.route("/")
def hello():
    return flask.jsonify(
        {
            "app": app.name,
            "env": app.config["env"],
            "color": app.config["color"],
            "password": app.config["password"],
            "features": app.config["features"],
        }
    )
