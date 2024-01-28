INSERT INTO cities_usa (city,state)
SELECT city,state FROM cities_world WHERE country='usa';