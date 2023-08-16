import 'package:flutter/material.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:koolkwiz/views/widgets/multiple_choice_answer_button.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../model/model.dart';

typedef SelectionMadeCallback = void Function(String);

class MultipleChoiceAnswerView extends StatefulWidget {
  const MultipleChoiceAnswerView({
    super.key,
    required this.answer,
  });

  final MultipleChoiceAnswer answer;

  @override
  State<MultipleChoiceAnswerView> createState() =>
      _MultipleChoiceAnswerViewState();
}

const List<String> multipleChoiceAnswerKey = ['A', 'B', 'C', 'D'];

class _MultipleChoiceAnswerViewState extends State<MultipleChoiceAnswerView> {
  int _selectedButtonIdx = -1;

  // button state before an answer is selected
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();

    return Padding(
      padding: EdgeInsets.all(Marketplace.spacing2),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.answer.answerOptions.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, idx) {
          final answerOption = widget.answer.answerOptions.elementAt(idx);
          final bool isCorrectAnswer =
              widget.answer.correctAnswer == answerOption;
          final bool isSelected = idx == _selectedButtonIdx;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: Marketplace.spacing7),
            child: MultipleChoiceAnswerButton(
              isActive: _isActive,
              isCorrectAnswer: isCorrectAnswer,
              isSelected: isSelected,
              text: '${multipleChoiceAnswerKey[idx]}. $answerOption',
              onPressed: () {
                setState(() {
                  _selectedButtonIdx = idx;
                });
                state.validateAnswer(answerOption);
              },
            ),
          );
        },
      ),
    );
  }
}

class OpenTextAnswerView extends StatefulWidget {
  const OpenTextAnswerView({
    super.key,
    required this.answer,
  });

  final OpenTextAnswer answer;

  @override
  State<OpenTextAnswerView> createState() => _OpenTextAnswerViewState();
}

class _OpenTextAnswerViewState extends State<OpenTextAnswerView> {
  String? textValue;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Padding(
      padding: EdgeInsets.all(Marketplace.spacing2),
      child: Column(
        children: [
          MarketTextField(
            onChange: (value) {
              textValue = textValue;
            },
          ),
          MarketButton(
            text: 'Submit Answer',
            onPressed: () {
              state.validateAnswer(textValue ?? '');
            },
          ),
        ],
      ),
    );
  }
}

class BooleanAnswerView extends StatefulWidget {
  const BooleanAnswerView({
    super.key,
    required this.answer,
  });

  final BooleanAnswer answer;

  @override
  State<BooleanAnswerView> createState() => _BooleanAnswerViewState();
}

class _BooleanAnswerViewState extends State<BooleanAnswerView> {
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
