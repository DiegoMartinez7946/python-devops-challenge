CREATE TABLE IF NOT EXISTS pokemons (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL
);

INSERT INTO pokemons (id, name, type) VALUES
    (1, 'Pikachu', 'Electric'),
    (2, 'Charmander', 'Fire');