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
  (QuestionWidget, AnswerWidget) questionAndAnswerView({
    required Question question,
    required Answer answer,
    required AppState appState,
  }) {
    return switch ((question, answer)) {
      (TextQuestion question, MultipleChoiceAnswer answer) => (
          TextQuestionWidget(question: question),
          MultipleChoiceWidget(answer: answer),
        ),
      (TextQuestion textQuestion, OpenTextAnswer textAnswer) => (
          TextQuestionWidget(question: textQuestion),
          TextAnswerWidget(answer: textAnswer),
        ),
      (TextQuestion textQuestion, BooleanAnswer boolAnswer) => (
          TextQuestionWidget(question: textQuestion),
          BooleanAnswerWidget(answer: boolAnswer),
        ),
      (ImageQuestion imageQuestion, MultipleChoiceAnswer multChoiceAnswer) => (
          ImageQuestionWidget(question: imageQuestion),
          MultipleChoiceWidget(answer: multChoiceAnswer),
        ),
      (ImageQuestion imageQuestion, OpenTextAnswer textAnswer) => (
          ImageQuestionWidget(question: imageQuestion),
          TextAnswerWidget(answer: textAnswer)
        ),
      (ImageQuestion imageCollection, BooleanAnswer boolAnswer) => (
          ImageQuestionWidget(question: imageCollection),
          BooleanAnswerWidget(answer: boolAnswer),
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
