import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koolkwiz/util/name_generator.dart';

import 'model/model.dart';

class FirebaseService {
  static Stream<Player> playerStream(Player player) {
    return FirebaseFirestore.instance
        .doc('users/${player.id}')
        .snapshots()
        .map((event) => Player.fromJson(event.data()!));
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
          .map((snapshot) => Player.fromJson(snapshot.data()))
          .toList();
      players.sort((a, b) => b.leaderboardStats.cumulativeScore
          .compareTo(a.leaderboardStats.cumulativeScore));

      return players;
    });
  }

  static Future<Player> createUser(UserCredential userCredential) async {
    final existingPlayerDoc = await FirebaseFirestore.instance
        .doc('users/${userCredential.user!.uid}')
        .get();

    Player player;

    // If user exists, this isn't their first time opening the app, return early so we don't overwrite the score
    if (existingPlayerDoc.exists) {
      final data = existingPlayerDoc.data()!;
      player = Player(
        id: existingPlayerDoc.id,
        name: data['name'] as String,
        currentScore: 0,
        leaderboardStats: LeaderboardStats(
          highestScore: data['leaderboardStats']['highestScore'] as int,
          date: (data['leaderboardStats']['date'] as Timestamp).toDate(),
          cumulativeScore: data['leaderboardStats']['cumulativeScore'] as int,
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

  static Future<QuerySnapshot> getAllQuestions() =>
      FirebaseFirestore.instance.collection('questions').get();

  static Future<Quiz> createQuiz() async {
    return await FirebaseService.getAllQuestions().then((QuerySnapshot value) {
      final questions = value.docs.map((doc) {
        final data = doc.data();
        if (data
            case <String, dynamic>{
              'type': String _,
              'category': String _,
              'answer': _,
            }) {
          return Question.fromFirestore(doc);
        } else {
          throw FormatException(
            'Incoming Firestore Question data is malformed',
          );
        }
      }).toList();

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

  static Future<void> updateUserLeaderboardStats(Player player) async {
    FirebaseFirestore.instance
        .doc('users/${player.id}')
        .update(player.toJson());
  }
}
