import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

  static Player fromJson(Map<String, dynamic> json, {String? id}) {
    return Player(
      id: json['id'] ?? id,
      name: json['name'],
      currentScore: json['score'],
      leaderboardStats: LeaderboardStats(
        highestScore: json['leaderboardStats']['highestScore'],
        date: (json['leaderboardStats']['date'] as Timestamp).toDate(),
        cumulativeScore: json['leaderboardStats']['cumulativeScore'],
      ),
    );
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
