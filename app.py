from flask import Flask, request, jsonify
from threading import Timer, Lock

app = Flask(__name__)

locks = {}
mutex = Lock()

TIMEOUT = 40

def release(user_id):
    with mutex:
        if user_id in locks:
            del locks[user_id]

@app.post("/start")
def start():
    data = request.get_json(force=True)
    user_id = str(data.get("telegramId"))

    if not user_id:
        return jsonify({"error": "telegramId obrigatório"}), 400

    with mutex:
        if user_id in locks:
            return jsonify({"status": "busy"}), 200

        timer = Timer(TIMEOUT, release, args=[user_id])
        timer.start()

        locks[user_id] = timer

    return jsonify({"status": "ok"}), 200


@app.post("/finish")
def finish():
    data = request.get_json(force=True)
    user_id = str(data.get("telegramId"))

    with mutex:
        timer = locks.pop(user_id, None)

    if timer:
        timer.cancel()

    return jsonify({"status": "released"}), 200


@app.get("/")
def home():
    return {
        "service": "Telegram Lock Service",
        "active_locks": len(locks)
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
