import jwt

SECRET_KEY = 'filiera-token-blockchain'

from datetime import datetime, timedelta

def generate_token(user):
    payload = {
        'exp': datetime.utcnow() + timedelta(minutes=15),  # Token scade dopo 30 minuti
        'iat': datetime.utcnow(),
        'user': user
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')


def validate_token(token):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        return True, payload
    except jwt.ExpiredSignatureError:
        return False, None
    except jwt.InvalidTokenError:
        return False, None
