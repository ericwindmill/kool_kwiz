import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:koolkwiz/views/widgets/multiple_choice_answer_button.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../model/model.dart';

typedef SelectionMadeCallback = void Function(String);

abstract class AnswerWidget extends StatefulWidget {
  const AnswerWidget({super.key});
}

class MultipleChoiceWidget extends AnswerWidget {
  const MultipleChoiceWidget({
    super.key,
    required this.answer,
  });

  final MultipleChoiceAnswer answer;

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceAnswerViewState();
}

const List<String> multipleChoiceAnswerKey = ['A', 'B', 'C', 'D'];

class _MultipleChoiceAnswerViewState extends State<MultipleChoiceWidget> {
  int _selectedButtonIdx = -1;

  // button state before an answer is selected
  bool _isActive = true;

  List<Widget> _buildButtons(AppState state) {
    final answers = widget.answer.answerOptions;
    return answers.map((String answerOption) {
      final bool isCorrectAnswer = widget.answer.correctAnswer == answerOption;
      final int idx = widget.answer.answerOptions.indexOf(answerOption);
      final bool isSelected = idx == _selectedButtonIdx;
      return Padding(
        padding: EdgeInsets.all(Marketplace.spacing8),
        child: MultipleChoiceAnswerButton(
          isActive: _isActive,
          isCorrectAnswer: isCorrectAnswer,
          isSelected: isSelected,
          text: '${multipleChoiceAnswerKey[idx]}. $answerOption',
          onPressed: () {
            setState(() {
              _selectedButtonIdx = idx;
              _isActive = false;
            });
            state.validateAnswer(answerOption);
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildButtons(state),
    );
  }
}

class TextAnswerWidget extends AnswerWidget {
  const TextAnswerWidget({
    super.key,
    required this.answer,
  });

  final OpenTextAnswer answer;

  @override
  State<TextAnswerWidget> createState() => _OpenTextAnswerViewState();
}

class _OpenTextAnswerViewState extends State<TextAnswerWidget> {
  String? textValue;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Column(
      children: [
        MarketTextField(
          onChange: (value) {
            textValue = value;
          },
        ),
        SizedBox(height: Marketplace.spacing4),
        MarketButton(
          text: 'Submit Answer',
          onPressed: () {
            state.validateAnswer(textValue ?? '');
          },
        ),
      ],
    );
  }
}

class BooleanAnswerWidget extends AnswerWidget {
  const BooleanAnswerWidget({
    super.key,
    required this.answer,
  });

  final BooleanAnswer answer;

  @override
  State<BooleanAnswerWidget> createState() => _BooleanAnswerViewState();
}

class _BooleanAnswerViewState extends State<BooleanAnswerWidget> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Padding(
      padding: EdgeInsets.all(Marketplace.spacing2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('False'),
              MarketSwitch(
                onTap: (value) {
                  _selected = value;
                },
              ),
              Text('True'),
            ],
          ),
          MarketButton(
            onPressed: () {
              state.validateAnswer(_selected.toString());
            },
            text: 'Submit',
          ),
        ],
      ),
    );
  }
}
