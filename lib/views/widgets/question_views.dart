import 'package:flutter/material.dart';

import '../../marketplace/marketplace.dart';
import '../../model/model.dart';

// class QuestionWidgetTemp extends StatelessWidget {
//   const QuestionWidgetTemp({super.key, required this.question});
//   Question question;
//   @override
//   Widget build(BuildContext context) {
//     return MarketCard(
//       child: question is TextQuestion ?
//       TextField() :
//       Column(
//         children: [
//           Image.asset(''),
//           Text('Who is this?'),
//         ],
//       ),
//     );
//   }
// }

abstract class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key});
}

class ImageQuestionWidget extends QuestionWidget {
  const ImageQuestionWidget({super.key, required this.question});

  final ImageQuestion question;

  @override
  Widget build(BuildContext context) {
    return MarketCard(
      child: Column(
        children: [
          Image.asset(
            question.imagePath,
          ),
          Text('Who is this?'),
        ],
      ),
    );
  }
}

class TextQuestionWidget extends QuestionWidget {
  const TextQuestionWidget({super.key, required this.question});

  final TextQuestion question;

  @override
  Widget build(BuildContext context) {
    return MarketCardWithDecoration(
      child: Text('Question: ${question.questionBody}'),
    );
  }
}
