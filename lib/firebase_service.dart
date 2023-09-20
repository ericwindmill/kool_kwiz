import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koolkwiz/util/name_generator.dart';

import 'model/model.dart';

class FirebaseService {
  ///
  /// Region: Player
  ///
  static Stream<Player> playerStream({
    required Player player,
    required String quizId,
  }) {
    return FirebaseFirestore.instance
        .doc('quizzes/$quizId/users/${player.id}')
        .snapshots()
        .map((snapshot) => Player.fromJson(snapshot.data()!));
  }

  static Future<Player> createPlayerAndJoinQuiz(
    UserCredential userCredential,
    String quizId,
  ) async {
    final player = await FirebaseService.getPlayerFromFirestore(
      userCredential,
      quizId,
    );
    if (player != null) {
      return player;
    } else {
      Player player;

      // TODO. determine if I made this quiz
      player = Player(
        id: userCredential.user!.uid,
        name: generateRandomPlayerName(),
        currentScore: 0,
        isAdmin: true,
      );

      await FirebaseFirestore.instance
          .doc('quizzes/$quizId/players/${userCredential.user!.uid}')
          .set(player.toJson());
      return player;
    }
  }

  static Future<bool> playerExists(
      UserCredential userCredential, String quizId) async {
    final existingPlayerDoc = await FirebaseFirestore.instance
        .doc('quizzes/$quizId/users/${userCredential.user!.uid}')
        .get();

    return existingPlayerDoc.exists;
  }

  static Future<Player?> getPlayerFromFirestore(
    UserCredential userCredential,
    String quizId,
  ) async {
    final playerDoesExist = await playerExists(userCredential, quizId);

    // If user exists, this isn't their first time opening the app
    if (playerDoesExist) {
      final docSnapshot = await FirebaseFirestore.instance
          .doc('quizzes/$quizId/users/${userCredential.user!.uid}')
          .get();
      final data = docSnapshot.data()!;
      return Player(
        id: docSnapshot.id,
        name: data['name'] as String,
        currentScore: data['currentScore'] as int,
        isAdmin: data['isAdmin'] as bool,
      );
    } else {
      return null;
    }
  }

  static Future<void> updatePlayer(Player player, String quizId) async {
    await FirebaseFirestore.instance
        .doc('quizzes/$quizId/users/${player.id}')
        .set({
      'name': player.name,
      'id': player.id,
      'currentScore': player.currentScore,
      'isAdmin': player.isAdmin,
    });
  }

  ///
  /// Region: Questions
  ///

  static Stream<Quiz> quizStream({required String quizId}) {
    return FirebaseFirestore.instance
        .doc('quizzes/$quizId')
        .snapshots()
        .map((snapshot) => Quiz.fromFirestore(snapshot.data()!));
  }

  // static Stream<Question> currentQuestion({required String quizId}) {
  //   return FirebaseFirestore.instance
  //       .doc('quizzes/$quizId')
  //       .snapshots()
  //       .map((quizSnapshot) {
  //     final quiz = Quiz.fromFirestore(quizSnapshot.data()!);
  //     return quiz.currentQuestion;
  //   });
  // }

  // static Stream<Answer> currentAnswer({required String quizId}) {
  //   return FirebaseFirestore.instance
  //       .doc('quizzes/$quizId')
  //       .snapshots()
  //       .map((quizSnapshot) {
  //     final quiz = Quiz.fromFirestore(quizSnapshot.data()!);
  //     return quiz.currentAnswer;
  //   });
  // }

  // static Stream<QuizStatus> quizStatus({required String quizId}) {
  //   return FirebaseFirestore.instance
  //       .doc('quizzes/$quizId')
  //       .snapshots()
  //       .map((quizSnapshot) {
  //     final quiz = Quiz.fromFirestore(quizSnapshot.data()!);
  //     return quiz.status;
  //   });
  // }

  static Future<QuerySnapshot> _getQuestionsForQuiz({required int length}) =>
      FirebaseFirestore.instance.collection('questions').limit(length).get();

  static Future<Quiz> createQuiz() async {
    const len = 10;

    final List<Question> questions =
        await FirebaseService._getQuestionsForQuiz(length: len)
            .then((QuerySnapshot value) {
      return value.docs.map((doc) {
        try {
          return Question.fromFirestore(doc);
        } catch (e) {
          throw FormatException(
            'Incoming Firestore Question data is malformed! \n $e',
          );
        }
      }).toList();
    });

    // The firstQuestion in the quiz is hardcoded
    // It's just for goofs in the talk, don't worry about it
    final firstQuestionDoc =
        await FirebaseFirestore.instance.doc("bootstrap/starterQuestion").get();
    final data = firstQuestionDoc.data()!;
    final firstQuestion = TextQuestion(
      questionBody: data['questionBody'] as String,
      category: data['category'] as String,
      answer: Answer.fromJson(data['answer'] as Map<String, dynamic>),
      id: firstQuestionDoc.id,
    );

    questions.shuffle();
    questions.insert(0, firstQuestion);

    final quizDoc = FirebaseFirestore.instance.collection('quizzes').doc();
    final quiz = Quiz(
      id: quizDoc.id,
      questions: questions,
      status: QuizStatus.ready,
      length: len,
      currentQuestionIdx: 0,
    );

    await quizDoc.set(quiz.toFirestore());
    return quiz;
  }

  static Future<void> updateQuizStatus({
    required String quizId,
    required QuizStatus status,
  }) async {
    await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .update({"status": status.name});
  }

  // static Future<void> resetCurrentScore(Player player) async {
  //   player.currentScore = 0;
  //   final json = player.toJson();
  //   FirebaseFirestore.instance.doc('users/${player.id}').update(json);
  // }

  // static Future<void> updateUserLeaderboardStats(Player player) async {
  //   FirebaseFirestore.instance
  //       .doc('users/${player.id}')
  //       .update(player.toJson());
  // }

// // All users that have completed at least one quiz
// static Stream<List<Player>> leaderboardStream() {
//   return FirebaseFirestore.instance
//       .collection('users')
//       .where('leaderboardStats.cumulativeScore', isNotEqualTo: 0)
//       .limit(30)
//       .snapshots()
//       .map((event) {
//     var players = event.docs
//         .map((snapshot) => Player.fromJson(snapshot.data()))
//         .toList();
//     players.sort((a, b) => b.leaderboardStats.cumulativeScore
//         .compareTo(a.leaderboardStats.cumulativeScore));
//
//     return players;
//   });
// }
}
