from flask_restful import Resource

class Player(Resource):
    def get(self):
        return ('hello')
    