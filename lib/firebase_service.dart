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

        // TODO: This doesn't seem to validate the Map values types. Is there a way to do that?
        final question = switch (data) {
          {
            'type': 'textQuestion',
            'category': _,
            'answer': _,
            'questionBody': _
          } =>
            TextQuestion(
              id: doc.reference.id,
              questionBody: data['questionBody'] as String,
              category: doc['category'],
            ),
          {
            'type': 'imageQuestion',
            'category': _,
            'answer': _,
            'imagePath': _,
          } =>
            ImageQuestion(
              id: doc.reference.id,
              imagePath: data['imagePath'] as String,
              category: doc['category'],
            ),
          _ => throw FormatException('Question didn\'t match any patterns'),
        };

        final answerJson = data['answer'];
        final answer = switch (answerJson) {
          {
            'type': 'openTextAnswer',
            'correctAnswer': _,
          } =>
            OpenTextAnswer(
                correctAnswer: answerJson['correctAnswer'] as String),
          {
            'type': 'multipleChoiceAnswer',
            'correctAnswer': _,
            'answerOptions': _,
          } =>
            MultipleChoiceAnswer(
              correctAnswer: answerJson['correctAnswer'] as String,
              answerOptions:
                  (answerJson['answerOptions'] as List).cast<String>(),
            ),
          {
            'type': 'booleanAnswer',
            'correctAnswer': _,
          } =>
            BooleanAnswer(correctAnswer: answerJson['correctAnswer'] as String),
          _ => throw FormatException('Answer didn\'t match any patters'),
        };

        questions.add((question, answer));
      }

      final quiz = Quiz(questionList: []);
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
