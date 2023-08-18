import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/components/expandable_column.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../marketplace/marketplace.dart';
import '../model/model.dart';
import 'widgets/answer_views.dart';
import 'widgets/question_views.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  (Widget, Widget) questionAndAnswerView({
    required Question question,
    required Answer answer,
    required AppState appState,
  }) {
    return switch ((question, answer)) {
      (TextQuestion textQuestion, MultipleChoiceAnswer multChoiceAnswer) => (
          TextQuestionView(question: textQuestion),
          MultipleChoiceAnswerView(answer: multChoiceAnswer),
        ),
      (TextQuestion textQuestion, OpenTextAnswer textAnswer) => (
          TextQuestionView(question: textQuestion),
          OpenTextAnswerView(answer: textAnswer),
        ),
      (TextQuestion textQuestion, BooleanAnswer boolAnswer) => (
          TextQuestionView(question: textQuestion),
          BooleanAnswerView(answer: boolAnswer),
        ),
      (ImageQuestion imageQuestion, MultipleChoiceAnswer multChoiceAnswer) => (
          ImageQuestionView(question: imageQuestion),
          MultipleChoiceAnswerView(answer: multChoiceAnswer),
        ),
      (ImageQuestion imageQuestion, OpenTextAnswer textAnswer) => (
          ImageQuestionView(question: imageQuestion),
          OpenTextAnswerView(answer: textAnswer)
        ),
      (ImageQuestion imageCollection, BooleanAnswer boolAnswer) => (
          ImageQuestionView(question: imageCollection),
          BooleanAnswerView(answer: boolAnswer),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final (question, answer) = questionAndAnswerView(
          question: state.currentQuestion,
          answer: state.currentAnswer,
          appState: state,
        );

        return Padding(
          padding: EdgeInsets.all(Marketplace.spacing4),
          child: ScrollColumnExpandable(
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
                child: Container(
                  key: Key(state.currentQuestion.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      question,
                      answer,
                    ],
                  ),
                ),
              ),
              SizedBox(height: Marketplace.spacing4),
              MarketButton(
                text: 'Next Question',
                onPressed: () => state.nextQuestion(),
              )
            ],
          ),
        );
      },
    );
  }
}
