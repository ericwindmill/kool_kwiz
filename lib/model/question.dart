import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  Question({
    required this.id,
    required this.category,
    required this.possibleAnswers,
    required this.correctAnswer,
    this.results = const {'A': 0, 'B': 0, 'C': 0, 'D': 0},
  });

  String id;
  String category;
  Map<String, String> possibleAnswers;
  String correctAnswer;
  Map<String, int> results;

  factory Question.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Question(
      id: snapshot.id,
      category: data['category'],
      possibleAnswers: {
        'A': data['possibleAnswers']['A'],
        'B': data['possibleAnswers']['B'],
        'C': data['possibleAnswers']['C'],
        'D': data['possibleAnswers']['D'],
      },
      correctAnswer: data['correctAnswer'],
      results: {
        'A': data['results']['A'],
        'B': data['results']['B'],
        'C': data['results']['C'],
        'D': data['results']['D'],
      },
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'category': category,
      'possibleAnswers': possibleAnswers,
      'correctAnswer': correctAnswer,
      'results': results,
    };
  }
}

class TextQuestion extends Question {
  TextQuestion({
    required this.questionBody,
    required super.id,
    required super.category,
    required super.possibleAnswers,
    required super.correctAnswer,
    required super.results,
  });

  final String questionBody;

  factory TextQuestion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return TextQuestion(
      id: snapshot.id,
      questionBody: data['questionBody'],
      category: data['category'],
      possibleAnswers: {
        'A': data['possibleAnswers']['A'],
        'B': data['possibleAnswers']['B'],
        'C': data['possibleAnswers']['C'],
        'D': data['possibleAnswers']['D'],
      },
      correctAnswer: data['correctAnswer'],
      results: {
        'A': data['results']['A'],
        'B': data['results']['B'],
        'C': data['results']['C'],
        'D': data['results']['D'],
      },
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'questionBody': questionBody,
      'category': category,
      'possibleAnswers': possibleAnswers,
      'correctAnswer': correctAnswer,
      'results': results,
    };
  }
}

class ImageQuestion extends Question {
  ImageQuestion({
    required this.imagePath,
    required super.id,
    required super.category,
    required super.possibleAnswers,
    required super.correctAnswer,
    required super.results,
  });

  String imagePath;

  factory ImageQuestion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return ImageQuestion(
      id: snapshot.id,
      imagePath: data['imagePath'],
      category: data['category'],
      possibleAnswers: {
        'A': data['possibleAnswers']['A'],
        'B': data['possibleAnswers']['B'],
        'C': data['possibleAnswers']['C'],
        'D': data['possibleAnswers']['D'],
      },
      correctAnswer: data['correctAnswer'],
      results: {
        'A': data['results']['A'],
        'B': data['results']['B'],
        'C': data['results']['C'],
        'D': data['results']['D'],
      },
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'imagePath': imagePath,
      'category': category,
      'possibleAnswers': possibleAnswers,
      'correctAnswer': correctAnswer,
      'results': results,
    };
  }
}
