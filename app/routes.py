from flask import request, jsonify, abort
from app import app, db
from app.models import Pokemons

@app.route('/pokemons', methods=['GET'])
def get_pokemons():
    pokemons = Pokemons.query.all()
    pokemon_list = [{'id': pokemon.id, 'name': pokemon.name, 'type': pokemon.type} for pokemon in pokemons]
    return jsonify(pokemon_list)

@app.route('/pokemons', methods=['POST'])
def create_pokemon():
    data = request.get_json()

    if 'name' not in data or 'type' not in data:
        abort(400, description="Missing 'name' or 'type' in request body")

    new_pokemon = Pokemons(name=data['name'], type=data['type'])

    try:
        db.session.add(new_pokemon)
        db.session.commit()
        return jsonify({"message": "New Pokémon created successfully"}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": "An error occurred while creating the Pokémon"}), 500