import 'package:cloud_firestore/cloud_firestore.dart';

import 'answer.dart';

sealed class Question {
  Question({
    required this.id,
    required this.category,
    required this.answer,
  });

  String id;
  String category;
  Answer answer;

  static Question fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'type': 'textQuestion',
        'category': String cat,
        'answer': Map<String, dynamic> answer,
        'questionBody': String body,
        'id': String id,
      } =>
        TextQuestion(
          questionBody: body,
          category: cat,
          answer: Answer.fromJson(answer),
          id: id,
        ),
      {
        'type': 'imageQuestion',
        'category': String category,
        'answer': Map<String, dynamic> answer,
        'imagePath': String imagePath,
        'id': String id,
      } =>
        ImageQuestion(
          imagePath: imagePath,
          category: category,
          answer: Answer.fromJson(answer),
          id: id,
        ),
      _ => throw FormatException('Question didn\'t match any patterns'),
    };
  }

  static Question fromFirestore(QueryDocumentSnapshot snapshot) {
    final id = snapshot.reference.id;
    final json = snapshot.data() as Map<String, dynamic>;
    json['id'] = id;
    return Question.fromJson(json);
  }

  static Map<String, dynamic> toJson(Question question) {
    return switch (question) {
      TextQuestion textQuestion => {
          'type': 'textQuestion',
          'category': textQuestion.category,
          'answer': Answer.toJson(textQuestion.answer),
          'questionBody': textQuestion.questionBody,
          'id': textQuestion.id,
        },
      ImageQuestion imageQuestion => {
          'type': 'imageQuestion',
          'category': imageQuestion.category,
          'answer': Answer.toJson(imageQuestion.answer),
          'imagePath': imageQuestion.imagePath,
          'id': imageQuestion.id,
        },
    };
  }
}

class TextQuestion extends Question {
  TextQuestion({
    required this.questionBody,
    required super.id,
    required super.category,
    required super.answer,
  });

  final String questionBody;
}

class ImageQuestion extends Question {
  ImageQuestion({
    required this.imagePath,
    required super.id,
    required super.category,
    required super.answer,
  });

  String imagePath;
}
