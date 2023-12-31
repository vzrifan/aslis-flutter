// To parse this JSON data, do
//
//     final problemNoteModel = problemNoteModelFromJson(jsonString);

import 'dart:convert';

ProblemNoteModel problemNoteModelFromJson(String str) =>
    ProblemNoteModel.fromJson(json.decode(str));

String problemNoteModelToJson(ProblemNoteModel data) =>
    json.encode(data.toJson());

class ProblemNoteModel {
  ProblemNoteModel({
    required this.id,
    required this.problem,
  });

  String id;
  String problem;

  factory ProblemNoteModel.fromJson(Map<String, dynamic> json) =>
      ProblemNoteModel(
        id: json["id"] ?? "",
        problem: json["problem"] ?? "",
      );

  static List<ProblemNoteModel> fromJsonList(List list) {
    if (list.length == 0) return List<ProblemNoteModel>.empty();
    return list.map((item) => ProblemNoteModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "problem": problem,
      };
}
