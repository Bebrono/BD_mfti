CREATE table IF NOT EXISTS Clients (
    client_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    passport_number VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Rooms (
    room_id INT PRIMARY KEY,
    number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50),
    capacity INT,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Tariffs (
    tariff_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Booking (
    booking_id INT PRIMARY KEY,
    client_id INT,
    room_id INT,
    service_id INT,
    tariff_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id),
    FOREIGN KEY (tariff_id) REFERENCES Tariffs(tariff_id)
);
