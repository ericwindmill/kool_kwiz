import 'package:koolkwiz/firebase_service.dart';

class Player {
  final String id;
  final String? name;
  int currentScore;
  final bool isAdmin;

  void incrementScore() {
    currentScore += 1;
  }

  Player({
    required this.id,
    required this.name,
    this.currentScore = 0,
    this.isAdmin = false,
  });

  static Player fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'id': String id,
          'name': String name,
          'currentScore': int currentScore,
          'isAdmin': bool isAdmin,
        }) {
      return Player(
        id: id,
        name: name,
        currentScore: currentScore,
        isAdmin: isAdmin,
      );
    } else {
      throw FormatException('Something aint right in Player.fromJson');
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'currentScore': currentScore,
      'isAdmin': isAdmin,
    };
  }
}
