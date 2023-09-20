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
  Widget getQuestionAndAnswerWidgetsDeprecated(Question question) {
    final answer = question.answer;
    if (question is TextQuestion && answer is BooleanAnswer) {
      return Column(
        children: [
          TextQuestionWidget(question: question),
          BooleanAnswerWidget(answer: answer)
        ],
      );
    } else if (question is TextQuestion && answer is MultipleChoiceAnswer) {
      return Column(
        children: [
          TextQuestionWidget(question: question),
          MultipleChoiceWidget(answer: answer)
        ],
      );
    } else {
      return Container();
    }
  }

  (QuestionWidget, AnswerWidget) getQuestionAndAnswerWidgets({
    required Question question,
  }) {
    return switch (question) {
      TextQuestion(answer: MultipleChoiceAnswer answer) => (
          TextQuestionWidget(question: question),
          MultipleChoiceWidget(answer: answer),
        ),
      TextQuestion(:OpenTextAnswer answer) => (
          TextQuestionWidget(question: question),
          TextAnswerWidget(answer: answer),
        ),
      TextQuestion(:BooleanAnswer answer) => (
          TextQuestionWidget(question: question),
          BooleanAnswerWidget(answer: answer),
        ),
      ImageQuestion(:MultipleChoiceAnswer answer) => (
          ImageQuestionWidget(question: question),
          MultipleChoiceWidget(answer: answer),
        ),
      ImageQuestion(:OpenTextAnswer answer) => (
          ImageQuestionWidget(question: question),
          TextAnswerWidget(answer: answer)
        ),
      ImageQuestion(:BooleanAnswer answer) => (
          ImageQuestionWidget(question: question),
          BooleanAnswerWidget(answer: answer),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppBloc>();
    final quiz = context.watch<Quiz>();
    final (question, answer) =
        getQuestionAndAnswerWidgets(question: quiz.currentQuestion);
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
              key: Key(quiz.currentQuestion.id),
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
  }
}
