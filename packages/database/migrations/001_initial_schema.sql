-- PostgreSQL + PostGIS Schema Migration & Seed Script

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table

CREATE TABLE users (

    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    full_name VARCHAR(100) NOT NULL,

    phone_number VARCHAR(15) UNIQUE NOT NULL,

    role VARCHAR(20) CHECK (role IN ('FARMER', 'BUYER', 'ADMIN')),

    preferred_language VARCHAR(10) DEFAULT 'hi',

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

);

-- 2. Farmer Profiles

CREATE TABLE farmer_profiles (

    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,

    upi_id VARCHAR(50) NOT NULL,

    address TEXT,

    location GEOGRAPHY(POINT, 4326)

);

CREATE INDEX idx_farmer_location ON farmer_profiles USING GIST(location);

-- 3. Crop Listings

CREATE TABLE crop_listings (

    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    farmer_id UUID REFERENCES users(id) ON DELETE CASCADE,

    crop_name VARCHAR(100) NOT NULL,

    category VARCHAR(50) NOT NULL,

    quantity_kg NUMERIC(10, 2) NOT NULL,

    price_per_kg NUMERIC(10, 2) NOT NULL,

    status VARCHAR(20) DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE', 'BIDDING', 'SOLD', 'CANCELLED')),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

);

-- 4. Orders

CREATE TABLE orders (

    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    listing_id UUID REFERENCES crop_listings(id),

    buyer_id UUID REFERENCES users(id),

    agreed_price NUMERIC(10, 2) NOT NULL,

    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'DISPATCHED', 'DELIVERED', 'CANCELLED')),

    payment_status VARCHAR(20) DEFAULT 'ESCROW_HELD' CHECK (payment_status IN ('PENDING', 'ESCROW_HELD', 'RELEASED')),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

);

-- Dummy Seed Data

INSERT INTO users (id, full_name, phone_number, role, preferred_language) VALUES

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Ramesh Kumar', '+919876543210', 'FARMER', 'hi'),

('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Anil Sharma', '+919123456789', 'BUYER', 'en');

INSERT INTO farmer_profiles (user_id, upi_id, address, location) VALUES

('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'ramesh@upi', 'Village Koderma, Jharkhand', ST_SetSRID(ST_MakePoint(85.5991, 24.4674), 4326));

INSERT INTO crop_listings (id, farmer_id, crop_name, category, quantity_kg, price_per_kg, status) VALUES

('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Fresh Tomatoes (Tamatar)', 'Vegetables', 500.00, 22.50, 'AVAILABLE');
