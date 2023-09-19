import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/model.dart';

/// This isn't used. It probably doesn't even work.
// Future<Quiz> _createQuizOld() async {
//   final questions = <Question>[];
//   return FirebaseFirestore.instance.collection('questions').get().then((QuerySnapshot value) {
//     for (var doc in value.docs) {
//       try {
//         final data = doc.data() as Map<String, dynamic>;
//         if (data.containsKey('type') &&
//             data['type'] is String &&
//             (data['type'] == 'imageQuestion' || data['type'] == 'textQuestion') &&
//             data.containsKey('id') &&
//             data['id'] is String &&
//             data.containsKey('category') &&
//             data['category'] is String &&
//             data.containsKey('answer') &&
//             data['answer'] is Map<String, dynamic>) {
//           final answerData = data['answer'] as Map<String, dynamic>;
//           if (answerData.containsKey('type') &&
//               answerData['type'] is String &&
//               (answerData['type'] == 'textAnswer' ||
//                   answerData['type'] == 'multipleChoiceAnswer' ||
//                   answerData['type'] == 'booleanAnswer') &&
//               answerData.containsKey('correctAnswer') &&
//               answerData['correctAnswer'] is String) {
//             // Build the answer
//             Answer answer;
//             if (answerData['type'] == 'multipleChoiceAnswer' &&
//                 answerData.containsKey('answerOptions')) {
//               answer = MultipleChoiceAnswer.fromJson(answerData);
//             } else if (answerData['type'] == 'booleanAnswer') {
//               answer = BooleanAnswer.fromJson(answerData);
//             } else {
//               answer = OpenTextAnswer.fromJson(answerData);
//             }
//
//             Question question;
//             if (data['type'] == 'imageQuestion' &&
//                 data.containsKey('imagePath') &&
//                 data['imagePath'] is String) {
//               question = ImageQuestion.fromJson(data);
//             } else if (data['type'] == 'textQuestion' &&
//                 data.containsKey('questionBody') &&
//                 data['questionBody'] is String) {
//               question = TextQuestion.fromJson(data);
//             } else {
//               throw FormatException('Malformed answer data coming from Firestore');
//             }
//
//             questions.add(question);
//           } else {
//             throw FormatException('Malformed answer data coming from Firestore');
//           }
//         } else {
//           throw FormatException('Malformed question data coming from Firestore');
//         }
//       } on FormatException catch (e) {
//         print('Format Exception! Skipping this question.');
//         continue;
//       } catch (e) {
//         print('An unknown exception occurred!');
//       }
//     }
//
//     final quiz = Quiz(questionList: []);
//     // Make sure every quiz contains a random assortment of 10 questions.
//     questions.shuffle();
//     final questionsForQuizLength = questions.take(quiz.length).toList();
//     quiz.addQuestions(questionsForQuizLength);
//     return quiz;
//   });
// }

// Player fromJson(Map<String, dynamic> json) {
//   if (json.containsKey('id') &&
//       json['id'] is String &&
//       json.containsKey('name') &&
//       json['id'] is String &&
//       json.containsKey('score') &&
//       json['id'] is int &&
//       json.containsKey('leaderboardStats')) {
//     final leaderboardJson = json['leaderboardStats'] as Map<String, dynamic>;
//     if (leaderboardJson.containsKey('highestScore') &&
//         json['highestScore'] is int &&
//         leaderboardJson.containsKey('cumulativeScore') &&
//         json['cumulativeScore'] is int &&
//         leaderboardJson.containsKey('date') &&
//         json['date'] is Timestamp) {
//       return Player(
//         id: json['id'] as String,
//         name: json['name'] as String,
//         currentScore: json['score'] as int,
//         leaderboardStats: LeaderboardStats(
//           highestScore: json['leaderboardStats']['highestScore'] as int,
//           date: (json['leaderboardStats']['date'] as Timestamp).toDate(),
//           cumulativeScore: json['leaderboardStats']['cumulativeScore'] as int,
//         ),
//       );
//     }
//   } else {
//     throw FormatException('');
//   }
// }
