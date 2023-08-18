import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:provider/provider.dart';

import '../model/model.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
    required this.onReset,
  });

  final VoidCallback onReset;

  String dateToReadable(DateTime dt) {
    return '${dt.year}-${dt.month}-${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<Player>();
    final leaderboard = context.watch<List<Player>>();

    return Padding(
      padding: EdgeInsets.all(Marketplace.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kwiz Complete!',
                style: Marketplace.heading1,
              ),
              SeasonsDecoration(
                smallSize: true,
              ),
            ],
          ),
          SizedBox(height: Marketplace.spacing4),
          MarketCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your final score: ${player.currentScore}'),
                Text(
                    'Your highest score: ${player.leaderboardStats.highestScore} on ${dateToReadable(player.leaderboardStats.date)}'),
                Text(
                    'Your cumulative score: ${player.leaderboardStats.cumulativeScore}'),
              ],
            ),
          ),
          SizedBox(height: Marketplace.spacing4),
          Text('Leaderboard', style: Marketplace.heading1),
          Expanded(
            child: MarketCard(
              child: ListView.separated(
                itemCount: leaderboard.length,
                itemBuilder: (context, idx) {
                  final leaderBoardPlayer = leaderboard[idx];
                  return ListTile(
                    title: Text(
                      '${leaderBoardPlayer.name}: ${leaderBoardPlayer.leaderboardStats.highestScore}',
                    ),
                    subtitle: Text(
                        'on ${dateToReadable(leaderBoardPlayer.leaderboardStats.date)}'),
                  );
                },
                separatorBuilder: (context, idx) {
                  return Divider();
                },
              ),
            ),
          ),
          Center(child: MarketButton(onPressed: onReset, text: 'Try Again!')),
        ],
      ),
    );
  }
}
