// To parse this JSON data, do
//
//     final answerModel = answerModelFromJson(jsonString);

import 'dart:convert';

AnswerModel answerModelFromJson(String str) => AnswerModel.fromJson(json.decode(str));

String answerModelToJson(AnswerModel data) => json.encode(data.toJson());

class AnswerModel {
  AnswerModel({
    this.message,
    this.player,
  });

  String message;
  Player player;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    message: json["message"],
    player: Player.fromJson(json["player"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "player": player.toJson(),
  };
}

class Player {
  Player({
    this.id,
    this.score,
    this.userStatus,
    this.user,
    this.gameId,
  });

  int id;
  int score;
  String userStatus;
  int user;
  int gameId;

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json["id"],
    score: json["score"],
    userStatus: json["user_status"],
    user: json["user"],
    gameId: json["game_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "score": score,
    "user_status": userStatus,
    "user": user,
    "game_id": gameId,
  };
}
