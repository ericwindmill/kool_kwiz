import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../marketplace/marketplace.dart';
import '../model/model.dart';

typedef SelectionMadeCallback = void Function(String);

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String currentSelection = '';

  Widget questionView(Question question) {
    if (question is TextQuestion) {
      return TextQuestionView(question: question.questionBody);
    } else if (question is ImageQuestion) {
      return ImageQuestionView(imagePath: question.imagePath);
    } else {
      return Center(child: Text('ERROR!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              PageTransitionSwitcher(
                duration: Duration(milliseconds: 600),
                transitionBuilder: (
                  child,
                  animation,
                  secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                // QUESTION AND ANSWER PORTION
                child: Padding(
                  key: Key(state.currentQuestion.id),
                  padding: EdgeInsets.symmetric(
                    vertical: Marketplace.spacing4,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Marketplace.spacing2,
                          ),
                          child: questionView(state.currentQuestion),
                        ),
                      ),
                      AnswerSelectionWidget(
                        currentQuestion: state.currentQuestion,
                        onAnswerSelected: (selection) {
                          currentSelection = selection;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              MarketButton(
                text: 'Submit Answer',
                onPressed: () {
                  state.submitAnswer(currentSelection);
                  state.nextQuestion();
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class ImageQuestionView extends StatelessWidget {
  const ImageQuestionView({super.key, required this.imagePath});

  final String imagePath;

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
            Image.asset(imagePath),
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

  final String question;

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
        child: Text('Question: $question'),
      ),
    );
  }
}

class AnswerSelectionWidget extends StatefulWidget {
  const AnswerSelectionWidget({
    super.key,
    required this.currentQuestion,
    required this.onAnswerSelected,
  });

  final Question currentQuestion;
  final SelectionMadeCallback onAnswerSelected;

  @override
  State<AnswerSelectionWidget> createState() => _AnswerSelectionWidgetState();
}

class _AnswerSelectionWidgetState extends State<AnswerSelectionWidget> {
  int _selectedButtonIdx = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Marketplace.spacing2),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.currentQuestion.possibleAnswers.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, idx) {
          final answerOptionEntry =
              widget.currentQuestion.possibleAnswers.entries.elementAt(idx);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Marketplace.spacing7),
            child: MarketButton(
                color: _selectedButtonIdx == idx
                    ? Marketplace.buttonHighlight
                    : null,
                text: '${answerOptionEntry.key}. ${answerOptionEntry.value}',
                onPressed: () {
                  setState(() {
                    _selectedButtonIdx = idx;
                  });
                  widget.onAnswerSelected(answerOptionEntry.key);
                }),
          );
        },
      ),
    );
  }
}
