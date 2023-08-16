import 'package:cloud_firestore/cloud_firestore.dart';

// multiple returns
// future.wait with records for Player and Quiz FutureBuilder
// separate serialization, so the code is more maintainable if you have multiple backends
// questions with multiple correct answers
// switch over a combination of answers?
// button highlight / selected exhaustiveness checking
// Question and Answer split out

sealed class Question {
  Question({
    required this.id,
    required this.category,
  });
  String id;
  String category;
}

class TextQuestion extends Question {
  TextQuestion({
    required this.questionBody,
    required super.id,
    required super.category,
  });

  final String questionBody;

  factory TextQuestion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return TextQuestion(
      id: snapshot.id,
      questionBody: data['questionBody'],
      category: data['category'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'questionBody': questionBody,
      'category': category,
    };
  }
}

class ImageQuestion extends Question {
  //super class
  ImageQuestion({
    required this.imagePath,
    required super.id,
    required super.category,
  });

  String imagePath;

  factory ImageQuestion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return ImageQuestion(
      id: snapshot.id,
      imagePath: data['imagePath'],
      category: data['category'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'imagePath': imagePath,
      'category': category,
    };
  }
}
