CREATE DATABASE FoodStore;

CREATE TABLE Permissions (
    permission_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
	permission_id INT REFERENCES Permissions(permission_id) ON DELETE RESTRICT,
	description TEXT
);

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
	role_id INT REFERENCES Roles(role_id) ON DELETE RESTRICT,
	email VARCHAR(255) UNIQUE NOT NULL,
	password_hash TEXT NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
	category_id INT REFERENCES Product_Categories(category_id) ON DELETE SET NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    image_url VARCHAR(255),
    discount_id INT REFERENCES Discount(discount_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Discount (
    discount_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    discount_type VARCHAR(20) CHECK (discount_type IN ('percent', 'fixed_amount')),
    discount_value DECIMAL(10,2) CHECK (discount_value >= 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE Product_Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
	description TEXT
);

CREATE TABLE Carts (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Cart_Items (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES Carts(cart_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE SET NULL,
    quantity INT CHECK (quantity > 0),
    price_at_time DECIMAL(10,2) NOT NULL -- Цена на момент добавления
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES Carts(cart_id) ON DELETE CASCADE,
    status VARCHAR(50) CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'canceled')),
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    payment_status VARCHAR(50) CHECK (payment_status IN ('pending', 'completed', 'failed')),
    payment_method VARCHAR(50) CHECK (payment_method IN ('YandexPay', 'cash_on_delivery')),
    transaction_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Delivery (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    delivery_status VARCHAR(50) CHECK (delivery_status IN ('preparing', 'shipped', 'delivered')),
    tracking_number VARCHAR(255) UNIQUE,
    estimated_delivery_date DATE,
    actual_delivery_date DATE
);
