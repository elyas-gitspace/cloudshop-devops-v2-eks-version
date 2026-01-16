from flask import Flask, jsonify

app = Flask(__name__)

products = [
    {"id": 1, "name": "Laptop Pro 15", "category": "Computers", "price": 1499, "description": "High-performance laptop for professionals"},
    {"id": 2, "name": "Laptop Air 13", "category": "Computers", "price": 999, "description": "Lightweight laptop for everyday use"},
    {"id": 3, "name": "Gaming Laptop X", "category": "Computers", "price": 1799, "description": "Powerful gaming laptop with dedicated GPU"},
    {"id": 4, "name": "Smartphone X", "category": "Phones", "price": 899, "description": "Latest generation smartphone"},
    {"id": 5, "name": "Smartphone Mini", "category": "Phones", "price": 599, "description": "Compact smartphone with great performance"},
    {"id": 6, "name": "Smartphone Max", "category": "Phones", "price": 1099, "description": "Large screen smartphone for multimedia"},
    {"id": 7, "name": "Wireless Headphones", "category": "Audio", "price": 199, "description": "Noise cancelling wireless headphones"},
    {"id": 8, "name": "Bluetooth Speaker", "category": "Audio", "price": 149, "description": "Portable speaker with deep bass"},
    {"id": 9, "name": "Wired Earphones", "category": "Audio", "price": 29, "description": "Affordable wired earphones"},
    {"id": 10, "name": "Smart Watch", "category": "Wearables", "price": 299, "description": "Smartwatch with fitness tracking"},
    {"id": 11, "name": "Fitness Band", "category": "Wearables", "price": 99, "description": "Fitness band with heart rate monitor"},
    {"id": 12, "name": "4K Monitor", "category": "Monitors", "price": 399, "description": "Ultra HD monitor for professionals"},
    {"id": 13, "name": "Full HD Monitor", "category": "Monitors", "price": 199, "description": "Affordable full HD monitor"},
    {"id": 14, "name": "Mechanical Keyboard", "category": "Accessories", "price": 129, "description": "Mechanical keyboard with RGB lighting"},
    {"id": 15, "name": "Wireless Mouse", "category": "Accessories", "price": 59, "description": "Ergonomic wireless mouse"},
    {"id": 16, "name": "USB-C Hub", "category": "Accessories", "price": 79, "description": "Multiport USB-C hub"},
    {"id": 17, "name": "External SSD 1TB", "category": "Storage", "price": 159, "description": "Fast external solid-state drive"},
    {"id": 18, "name": "External HDD 2TB", "category": "Storage", "price": 99, "description": "High-capacity external hard drive"},
    {"id": 19, "name": "Webcam HD", "category": "Accessories", "price": 89, "description": "HD webcam for video calls"},
    {"id": 20, "name": "Gaming Chair", "category": "Furniture", "price": 249, "description": "Comfortable gaming chair"},
    {"id": 21, "name": "Office Chair", "category": "Furniture", "price": 199, "description": "Ergonomic office chair"},
    {"id": 22, "name": "Desk Lamp", "category": "Furniture", "price": 49, "description": "LED desk lamp with adjustable brightness"},
    {"id": 23, "name": "Router Wi-Fi 6", "category": "Networking", "price": 179, "description": "High-speed Wi-Fi 6 router"},
    {"id": 24, "name": "Ethernet Switch", "category": "Networking", "price": 89, "description": "8-port gigabit ethernet switch"},
    {"id": 25, "name": "Power Bank 20000mAh", "category": "Accessories", "price": 59, "description": "High-capacity power bank"},
    {"id": 26, "name": "Tablet 10\"", "category": "Tablets", "price": 399, "description": "10-inch tablet for entertainment"},
    {"id": 27, "name": "Tablet Mini", "category": "Tablets", "price": 299, "description": "Compact tablet for mobility"},
    {"id": 28, "name": "E-reader", "category": "Tablets", "price": 129, "description": "E-ink reader for book lovers"},
    {"id": 29, "name": "Smart TV 55\"", "category": "TV", "price": 699, "description": "55-inch 4K smart TV"},
    {"id": 30, "name": "Streaming Stick", "category": "TV", "price": 49, "description": "Streaming device for TV"}
]

@app.route("/health")
def health():
    return jsonify({"status": "product api ok"})

@app.route("/products")
def get_products():
    return jsonify(products)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
