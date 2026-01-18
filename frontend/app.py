from flask import Flask, request, redirect
import requests

app = Flask(__name__)

PRODUCT_API_URL = "http://product-api-service:5000/products"    
ORDER_API_URL = "http://order-api-service:5000/orders"     

@app.route("/")
def home():
    products = requests.get(PRODUCT_API_URL).json()

    html = "<h1>CloudShop</h1>"
    html += "<h2>Products</h2><ul>"

    for product in products:
        html += f"""
        <li>
            <b>{product['name']}</b> - {product['price']} €
            <form action="/order" method="post" style="display:inline;">
                <input type="hidden" name="product_name" value="{product['name']}">
                <input type="hidden" name="price" value="{product['price']}">
                <button type="submit">Order</button>
            </form>
        </li>
        """

    html += "</ul>"
    return html

@app.route("/order", methods=["POST"])
def order():
    product_name = request.form.get("product_name")
    price = request.form.get("price")

    order = {
        "product": product_name,
        "price": price
    }

    requests.post(ORDER_API_URL, json=order)

    return redirect("/")

@app.route("/health")
def health():
    return {"status": "frontend ok"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
