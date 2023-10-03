import unittest
from app import app, db
from app.models import Pokemons

class AppTestCase(unittest.TestCase):

    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
        self.app = app.test_client()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_create_pokemon(self):
        data = {
            "name": "Bulbasaur",
            "type": "Grass"
        }
        response = self.app.post('/pokemons', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json['message'], "New Pokémon created successfully")

        pokemon = Pokemons.query.first()
        self.assertEqual(pokemon.name, "Bulbasaur")
        self.assertEqual(pokemon.type, "Grass")

if __name__ == '__main__':
    unittest.main()
