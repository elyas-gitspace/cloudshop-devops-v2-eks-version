from flask import Flask, jsonify, request

app = Flask(__name__)

orders = []

@app.route("/health")
def health():
    return jsonify({"status": "order api ok"})

@app.route("/orders", methods=["POST"])
def create_order():
    order = request.json
    orders.append(order)
    return jsonify({"message": "order created", "order": order}), 201

@app.route("/orders")
def list_orders():
    return jsonify(orders)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
