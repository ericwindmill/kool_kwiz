import 'package:flutter/material.dart';

import '../../marketplace/marketplace.dart';
import '../../model/model.dart';

class ImageQuestionView extends StatelessWidget {
  const ImageQuestionView({super.key, required this.question});

  final ImageQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Marketplace.spacing4),
      decoration: BoxDecoration(
        color: Marketplace.cardBackground,
        border: Border.all(width: Marketplace.lineWidth),
        borderRadius: BorderRadius.all(
          Radius.circular(
            Marketplace.cornerRadius,
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(question.imagePath),
            Text('Who is this?'),
          ],
        ),
      ),
    );
  }
}

class TextQuestionView extends StatelessWidget {
  const TextQuestionView({
    super.key,
    required this.question,
  });

  final TextQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Marketplace.spacing4),
      decoration: BoxDecoration(
        color: Marketplace.cardBackground,
        border: Border.all(width: Marketplace.lineWidth),
        borderRadius: BorderRadius.all(
          Radius.circular(
            Marketplace.cornerRadius,
          ),
        ),
      ),
      child: Center(
        child: Text('Question: ${question.questionBody}'),
      ),
    );
  }
}
