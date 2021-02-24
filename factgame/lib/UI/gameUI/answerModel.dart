// To parse this JSON data, do
//
//     final answerModel = answerModelFromJson(jsonString);

import 'dart:convert';

AnswerModel answerModelFromJson(String str) => AnswerModel.fromJson(json.decode(str));

String answerModelToJson(AnswerModel data) => json.encode(data.toJson());

class AnswerModel {
  AnswerModel({
    this.answer,
    this.score,
  });

  Answer answer;
  int score;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    answer: Answer.fromJson(json["answer"]),
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "answer": answer.toJson(),
    "score": score,
  };
}

class Answer {
  Answer({
    this.id,
    this.answerText,
    this.isCorrect,
    this.questionid,
  });

  int id;
  String answerText;
  bool isCorrect;
  int questionid;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json["id"],
    answerText: json["answer_text"],
    isCorrect: json["is_correct"],
    questionid: json["questionid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "answer_text": answerText,
    "is_correct": isCorrect,
    "questionid": questionid,
  };
}
