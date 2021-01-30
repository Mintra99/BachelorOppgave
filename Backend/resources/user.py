class User:
    def __init__(self, username, sid):
        """Create a new user with a username"""
        self.username = username
        self.points = 0

        # USED ONLY FOR MULTIPLAYER
        self.admin = False
        self.proposer = False
        self.sid = sid

        # Used for checking if all players have answered in multiplayer
        # and are ready to move on to the next round
        self.answered = False

    def __str__(self):
        return "Username: {}\nPoints: {}\nAdmin: {}".format(
            self.username, self.points, self.admin
        )

    def __repr__(self):
        if self.admin:
            return "ADMIN: " + self.username
        else:
            return self.username

    def getInfo(self):
        info = {
            "username": self.username,
            "points": self.points,
            "admin": self.admin,
            "proposer": self.proposer,
            "sid": self.sid,
        }
        return info