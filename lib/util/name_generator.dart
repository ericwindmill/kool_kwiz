import 'dart:math';

import 'package:english_words/english_words.dart';

var rand = Random();

String generateRandomPlayerName() {
  final first = adjectives.take(100).elementAt(rand.nextInt(99));
  final second = adjectives.take(100).elementAt(rand.nextInt(99));
  final noun = nouns.take(100).elementAt(rand.nextInt(99));
  final name = '${first}_${second}_$noun';

  // 20 chars will fit across older iphone
  return name.split('').length > 20 ? generateRandomPlayerName() : name;
}
