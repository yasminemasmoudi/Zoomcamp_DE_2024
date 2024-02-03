CREATE SCHEMA IF NOT EXISTS de_zoom_camp;
CREATE TABLE de_zoom_camp.ny_yellow_taxi (
  ID  SERIAL PRIMARY KEY,
  vendor_id INT,
  pickup_datetime DATE,
  dropoff_datetime DATE,
  passenger_count INT,
  trip_distance FLOAT,
  pickup_location INT,
  dropoff_location INT,
  rate_code INT,
  payment_type INT,
  fare_amount FLOAT,
  tip_amount FLOAT,
  tolls_amount FLOAT,
  total_amount FLOAT
);