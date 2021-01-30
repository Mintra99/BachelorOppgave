from resource.user import User


class Multiplayer:
    def __init__(self, max_players=5, countdown=1, question_count=5):
        self.lobby = []
        # gamestate tracks which state the game is in
        # Values:
        # 0 => Game is in the lobby; has not started yet
        # 1 => Game has started, and is displaying statements to users
        # 2 => Game has ended, this will display the leaderboard for the just finished game
        self.gamestate = 0
        # MAX Players for multiplayer
        self.max_players = max_players
        # Time before the game starts
        self.countdown = countdown
        # Amount of questions until the game ends
        self.question_count = question_count
        # Current round number
        self.roundnumber = 1
        # Statements/Questions for this game
        self.statements = []
        # Time to answer each statement
        self.round_timer = 60

        # Tracks current time left of round
        self.time_left = self.round_timer

        # Proposer type game?
        self.include_proposer = False

    def add_user(self, user):
        """Adds user object to the lobby list, returns status of the request\n
        CODE: F => Lobby is full\n
        CODE: S => Successfully added user\n
        CODE: A => User already in lobby
        """
        user_object = self.get_User_from_lobby(user.username)

        # if user is already in the lobby
        if user_object is not None:
            # Update the SID in case of refreshes etc
            if user.sid != user_object.sid:
                user_object.sid = user.sid
            print("User already in lobby....")
            return "A"
        # Else we will add the user object to the lobby
        elif len(self.lobby) < int(self.max_players):
            if len(self.lobby) == 0:
                print(f"Giving {user.username} admin privileges.")
                user.admin = True
            self.lobby.append(user)
            print(f"{user.username} has been added to the lobby!")
            return "S"
        else:
            print(f"{user.username} could not join, the lobby is full")
            return "F"

    def get_User_from_lobby(self, username):
        """Returns the user object if the given username is in the lobby, or else it will return None"""
        for user in self.lobby:
            if username == user.username:
                return user
        return None

    def is_round_finished(self):
        # Check if every player has anwered
        for user in self.lobby:
            if not user.proposer:
                if not user.answered:
                    return False
        return True

    def remove_user(self, user):
        """Removes the given user object, with username, returns true if successful, false if not"""
        user_object = self.get_User_from_lobby(user.username)
        if user is user_object:
            print(f"Removed {user.username} from the lobby!")
            self.lobby.remove(user)
            if len(self.lobby) < 1:
                self.reset()
            return True
        else:
            print(f"Tried to remove {user}, but failed")
            return False

    def get_lobby_sorted(self):
        return sorted(self.lobby, key=lambda user: user.points, reverse=True)

    def reset(self):
        """Resets the game to the initial state."""
        self.lobby = []
        self.gamestate = 0
        self.roundnumber = 1
        self.statements = []
        self.include_proposer = False

    def get_settings(self):
        """Returns the game settings for this lobby"""
        return {
            "max_players": self.max_players,
            "round_timer": self.round_timer,
            "question_count": self.question_count,
            "proposer": self.include_proposer,
        }

    def get_data(self):
        """Get all relevant information about the game at this moment."""
        return {
            "lobby": self.lobby,
            "gamestate": self.gamestate,
            "roundnumber": self.roundnumber,
            "statements": self.statements,
        }

    def proposer_chosen(self):
        """Returns true if a proposer has been chosen, false if not"""
        for user in self.lobby:
            if user.proposer:
                return True
        return False

    def get_proposer(self):
        """Returns proposer user, returns None if no proposer"""
        for user in self.lobby:
            if user.proposer:
                return user
        return None