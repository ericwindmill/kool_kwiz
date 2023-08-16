import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koolkwiz/util/name_generator.dart';

import 'model/model.dart';

class FirebaseService {
  static Stream<Player> playerStream(Player player) {
    return FirebaseFirestore.instance
        .doc('users/${player.id}')
        .snapshots()
        .map((event) {
      final playerData = event.data()!;
      return Player.fromJson(playerData);
    });
  }

  // All users that have completed at least one quiz
  static Stream<List<Player>> leaderboardStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('leaderboardStats.cumulativeScore', isNotEqualTo: 0)
        .limit(30)
        .snapshots()
        .map((event) {
      var players = event.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
        return Player.fromJson(snapshot.data());
      }).toList();
      players.sort((a, b) => b.leaderboardStats.cumulativeScore
          .compareTo(a.leaderboardStats.cumulativeScore));

      return players;
    });
  }

  static Future<Player> createUser(UserCredential userCredential) async {
    final existingPlayerDoc = await FirebaseFirestore.instance
        .doc('users/${userCredential.user!.uid}')
        .get();

    // Variable mask for initialization
    Player player;

    // If user exists, this isn't their first time opening the app,
    // return early so we don't overwrite the score
    if (existingPlayerDoc.exists) {
      final data = existingPlayerDoc.data()!;
      player = Player(
        id: existingPlayerDoc.id,
        name: data['name'],
        currentScore: 0,
        leaderboardStats: LeaderboardStats(
          highestScore: data['leaderboardStats']['highestScore'],
          date: (data['leaderboardStats']['date'] as Timestamp).toDate(),
          cumulativeScore: data['leaderboardStats']['cumulativeScore'],
        ),
      );
    } else {
      // The document doesn't exist, so this is the first time they're opening the app
      // Create a username and add them to Firestore
      player = Player(
        id: userCredential.user!.uid,
        name: generateRandomPlayerName(),
        leaderboardStats: LeaderboardStats(
          date: DateTime.now(),
        ),
      );

      // Create user in Firestore, in order to track score
      await FirebaseFirestore.instance.doc('users/${player.id}').set({
        'name': player.name,
        'id': player.id,
        'score': player.currentScore,
        'leaderboardStats': {
          'highestScore': player.leaderboardStats.highestScore,
          'date': player.leaderboardStats.date,
          'cumulativeScore': player.leaderboardStats.cumulativeScore,
        },
      });
    }

    return player;
  }

  static Future<Quiz> createQuiz() async {
    final questions = <(Question, Answer)>[];
    return FirebaseFirestore.instance
        .collection('questions')
        .get()
        .then((QuerySnapshot value) {
      for (var doc in value.docs) {
        final data = doc.data();
        if (data is Map<String, Object?> &&
            data.containsKey('type') &&
            data.containsKey('category') &&
            data['answer'] is Map<String, Object?>) {
          late Question question;
          final questionType = data['type'];

          // Validate that the question type is correct
          if (data['type'] != 'textQuestion' &&
              data['type'] != 'imageQuestion') {
            throw FormatException(
                'Question type must be imageQuestion or textQuestion. Got ${data['type']}');
          }

          // Validate that the question types have the correct properties
          if (data['type'] == 'textQuestion' &&
              !data.containsKey('questionBody')) {
            throw FormatException(
                'Questions of type textQuestion must contain questionBody');
          } else if (data['type'] == 'imageQuestion' &&
              !data.containsKey('imagePath')) {
            throw FormatException(
                'Question of type imageQuestion must contain an imagePath');
          }

          // Build Question
          if (questionType == 'textQuestion') {
            question = TextQuestion(
              id: doc.reference.id,
              questionBody: data['questionBody'] as String,
              category: doc['category'],
            );
          } else if (questionType == 'imageQuestion') {
            if (data['imagePath'] is! String) {
              throw FormatException(
                  'imagePath must be exist and must be a String!');
            }

            question = ImageQuestion(
              id: doc.reference.id,
              imagePath: data['imagePath'] as String,
              category: doc['category'],
            );
          }

          // Validate that answer data exists
          final answerJson = data['answer'];
          if (answerJson is! Map<String, dynamic>) {
            throw FormatException(
                'Answer data must exist, and must be a Map. Got $answerJson');
          }

          // Build Answer
          final answerData = data['answer'] as Map<String, Object?>;
          final answerType = answerData['type'];
          late Answer answer;
          if (answerType != 'openTextAnswer' &&
              answerType != 'multipleChoiceAnswer' &&
              answerType != 'booleanAnswer') {
            throw FormatException(
                'Answer type must be one of: openTextAnswer, multipleChoiceAnswer, booleanAnswer');
          }

          if (!answerData.containsKey('correctAnswer')) {
            throw FormatException('Answer.correctAnswer must exist.');
          }

          // create OpenTextAnswer
          if (answerType == 'openTextAnswer') {
            if (answerData['correctAnswer'] is! String) {
              throw FormatException(
                  'For openTextAnswers, the answerData must be a String. Got ${answerData['correctAnswer']}');
            }
            answer = OpenTextAnswer(
                correctAnswer: answerData['correctAnswer'] as String);

            // Create multipleChoiceAnswer
          } else if (answerType == 'multipleChoiceAnswer') {
            if (!answerData.containsKey('answerOptions') ||
                answerData['answerOptions'] is! List) {
              throw FormatException(
                  'answerOptions must exist in a multipleChoiceAnswer, and it must be a List of Strings. Got ${answerData['answerOptions']}, type: ${answerData['answerOptions'].runtimeType}');
            }
            if (answerData['correctAnswer'] is! String) {
              throw FormatException(
                  'For multipleChoiceAnswers, the answerData must be a String. Got ${answerData['correctAnswer']}');
            }
            final answerOptionsData =
                (answerData['answerOptions'] as List).cast<String>();

            answer = MultipleChoiceAnswer(
              correctAnswer: answerData['correctAnswer'] as String,
              answerOptions: answerOptionsData,
            );
          } else if (answerType == 'booleanAnswer') {
            if (answerData['correctAnswer'] is! bool) {
              throw FormatException(
                  'For booleanAnswers, the answerData must be a boolean. Got ${answerData['correctAnswer']}');
            }
            answer = BooleanAnswer(
                correctAnswer: answerData['correctAnswer'] as String);
          }
          questions.add((question, answer));
        }
      }

      final quiz = Quiz(questionList: []);
      // Make sure every quiz contains a random assortment of 10 questions.
      questions.shuffle();
      final questionsForQuizLength = questions.take(quiz.length).toList();
      quiz.addQuestions(questionsForQuizLength);
      return quiz;
    });
  }

  static void incrementScore(Player player) async {
    player.currentScore++;
    final json = player.toJson();
    FirebaseFirestore.instance.doc('users/${player.id}').update(json);
  }

  static Future<void> resetCurrentScore(Player player) async {
    player.currentScore = 0;
    final json = player.toJson();
    FirebaseFirestore.instance.doc('users/${player.id}').update(json);
  }

  static Future<void> completeQuiz(Player player) async {
    player.updateLeaderboardStats();
    FirebaseFirestore.instance
        .doc('users/${player.id}')
        .update(player.toJson());
  }
}
