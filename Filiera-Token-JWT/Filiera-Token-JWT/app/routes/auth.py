from flask import request, jsonify
from app import app
from app.services.jwt_service import generate_token, validate_token


@app.route('/generate-jwt-token', methods=['POST'])
def generate_jwt_token():
    # Effettua i controlli sui parametri in ingresso
    data = request.json
    required_fields = ['email', 'password', 'wallet', 'user_type']

    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing one or more required fields'}), 400

    # Se tutti i campi richiesti sono presenti, procedi con la generazione del token
    user = {
        'email': data['email'],
        'wallet': data['wallet'],
        'user_type': data['user_type']
    }

    # Genera il token JWT
    token = generate_token(user)
    return jsonify({'token': token}), 200


@app.route('/protected', methods=['GET'])
def protected():
    # Controlla se il token è presente nell'header Authorization
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Token missing'}), 401

    # Validazione del token
    valid, decoded_token = validate_token(token)
    if not valid:
        return jsonify({'error': 'Invalid token'}), 401

    # Utilizzo dei dati decodificati dal token
    user_data = decoded_token.get('user')
    return jsonify({'message': 'Access granted', 'user': user_data}), 200
