import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String? name;
  int currentScore;
  LeaderboardStats leaderboardStats;

  void updateLeaderboardStats() {
    leaderboardStats.cumulativeScore += currentScore;
    if (currentScore > leaderboardStats.highestScore) {
      leaderboardStats.highestScore = currentScore;
      leaderboardStats.date = DateTime.now();
    }
  }

  Player({
    required this.id,
    required this.name,
    this.currentScore = 0,
    required this.leaderboardStats,
  });

  static Player fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': String _,
          'name': String _,
          'score': int _,
          'leaderboardStats': {
            'highestScore': int _,
            'date': Timestamp _,
            'cumulativeScore': int _,
          }
        }) {
      return Player(
        id: json['id'] as String,
        name: json['name'] as String,
        currentScore: json['score'] as int,
        leaderboardStats: LeaderboardStats(
          highestScore: json['leaderboardStats']['highestScore'] as int,
          date: (json['leaderboardStats']['date'] as Timestamp).toDate(),
          cumulativeScore: json['leaderboardStats']['cumulativeScore'] as int,
        ),
      );
    } else {
      throw FormatException('Something aint right');
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'score': currentScore,
      'leaderboardStats': {
        'highestScore': leaderboardStats.highestScore,
        'date': leaderboardStats.date,
        'cumulativeScore': leaderboardStats.cumulativeScore,
      },
    };
  }
}

class LeaderboardStats {
  LeaderboardStats({
    this.highestScore = 0,
    required this.date,
    this.cumulativeScore = 0,
  });

  int highestScore;
  DateTime date;
  int cumulativeScore;
}
