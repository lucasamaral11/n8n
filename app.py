from flask import Flask, request, jsonify
from threading import Lock
import time

app = Flask(__name__)

TIMEOUT = 40  # segundos

locks = {}
mutex = Lock()


def clean_expired():
    now = time.time()
    expired = [user for user, expires in locks.items() if expires <= now]
    for user in expired:
        del locks[user]


@app.post("/start")
def start():
    data = request.get_json(force=True)
    telegram_id = str(data.get("telegramId", "")).strip()

    if not telegram_id:
        return jsonify({"error": "telegramId obrigatório"}), 400

    with mutex:
        clean_expired()

        if telegram_id in locks:
            return jsonify({
                "status": "busy",
                "remaining": max(0, int(locks[telegram_id] - time.time()))
            }), 200

        locks[telegram_id] = time.time() + TIMEOUT

    return jsonify({"status": "ok"}), 200


@app.post("/finish")
def finish():
    data = request.get_json(force=True)
    telegram_id = str(data.get("telegramId", "")).strip()

    with mutex:
        clean_expired()
        locks.pop(telegram_id, None)

    return jsonify({"status": "released"}), 200


@app.get("/")
def home():
    with mutex:
        clean_expired()

        now = time.time()

        status = {
            user: max(0, round(expires - now, 1))
            for user, expires in locks.items()
        }

    return jsonify({
        "service": "Telegram Lock Service",
        "timeout": TIMEOUT,
        "active_locks": len(locks),
        "locks": status
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4321)
