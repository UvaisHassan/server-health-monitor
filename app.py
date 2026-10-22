from flask import Flask, jsonify, render_template
import json
import subprocess

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/api/metrics")
def metrics():
    try:
        result = subprocess.run(
            ["bash", "metrics.sh"],
            capture_output=True,
            text=True,
            check=True,
            timeout=5,
        )
        return jsonify(json.loads(result.stdout))
    except (subprocess.SubprocessError, json.JSONDecodeError) as exc:
        app.logger.exception("Failed to collect metrics")
        return jsonify({"error": "Unable to collect metrics"}), 500


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)