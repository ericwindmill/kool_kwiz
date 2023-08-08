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

  // The logic for this shouldn't be in one long method. But, it might help
  // us approach a refactoring example holistically.
  // TODO: split logic depending on the refactoring examples for the talk
  static Future<Quiz> createQuiz() async {
    final questions = <Question>[];
    return FirebaseFirestore.instance
        .collection('questions')
        // Get ALL the questions
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      for (var doc in value.docs) {
        final data = doc.data();
        final questionType = data['type'];
        if (questionType == 'textQuestion') {
          final question = TextQuestion(
            id: doc.reference.id,
            questionBody: data['questionBody'],
            category: doc['category'],
            possibleAnswers: {
              'A': doc['possibleAnswers']['A'],
              'B': doc['possibleAnswers']['B'],
              'C': doc['possibleAnswers']['C'],
              'D': doc['possibleAnswers']['D'],
            },
            correctAnswer: data['correctAnswer'],
            results: {
              'A': doc['results']['A'],
              'B': doc['results']['B'],
              'C': doc['results']['C'],
              'D': doc['results']['D'],
            },
          );
          questions.add(question);
        } else if (questionType == 'imageQuestion') {
          final String id = doc.reference.id;
          final question = ImageQuestion(
            id: id,
            imagePath: data['imagePath'],
            category: doc['category'],
            possibleAnswers: {
              'A': doc['possibleAnswers']['A'],
              'B': doc['possibleAnswers']['B'],
              'C': doc['possibleAnswers']['C'],
              'D': doc['possibleAnswers']['D'],
            },
            correctAnswer: data['correctAnswer'],
            results: {
              'A': doc['results']['A'],
              'B': doc['results']['B'],
              'C': doc['results']['C'],
              'D': doc['results']['D'],
            },
          );
          questions.add(question);
        }
      }

      final quiz = Quiz(questions: []);

      // Filter the questions to get random questions
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
