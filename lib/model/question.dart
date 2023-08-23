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
        'category': String _,
        'answer': Map<String, dynamic> _,
        'questionBody': String _,
        'id': String _,
      } =>
        TextQuestion(
          questionBody: json['questionBody'] as String,
          category: json['category'] as String,
          answer: Answer.fromJson(json['answer'] as Map<String, dynamic>),
          id: json['id'] as String,
        ),
      {
        'type': 'imageQuestion',
        'category': String _,
        'answer': _,
        'imagePath': String _,
        'id': String _,
      } =>
        ImageQuestion(
          imagePath: json['imagePath'] as String,
          category: json['category'] as String,
          answer: Answer.fromJson(json['answer'] as Map<String, dynamic>),
          id: json['id'] as String,
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
