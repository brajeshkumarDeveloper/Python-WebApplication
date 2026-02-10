from statistics import quantiles

from fastapi import FastAPI
from models import Product

app = FastAPI()


@app.get('/')
def greet():
    return 'Hello World'

products =[
    Product(id=1, name='phone', price=10.0, description='Description 1', quantity=100),
    Product(id=2, name='laptop', price=20.0, description='Description 2', quantity=200),
    Product(id=3, name='tablet', price=15.0, description='Description 3', quantity=150),
    Product(id=4, name='monitor', price=25.0, description='Description 4', quantity=250)
]


@app.get('/products')
def get_all_products(   ):
    return products

@app.get('/products/{product_id}')
def get_product_by_id(product_id: int):
    for product in products:
        if product.id == product_id:
            return product

    return "Product not found"
@app.post('/products')
def add_product(new_product: Product):
    products.append(new_product)
    return new_product

@app.put('/products/{product_id}')
def update_product(product_id: int, updated_product: Product):
    for index, product in enumerate(products):
        if product.id == product_id:
            products[index] = updated_product
            return updated_product
    return "Product not found"

@app.delete('/products/{product_id}')
def delete_product(product_id: int):
    for index, product in enumerate(products):
        if product.id == product_id:
            deleted_product = products.pop(index)
            return "Product Deleted Successfully"
    return "Product not found"
# greet()