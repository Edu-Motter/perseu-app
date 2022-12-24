import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/style.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'checkin_viewmodel.dart';

class CheckInDialog extends StatelessWidget {
  const CheckInDialog({
    Key? key,
    required this.trainingId,
  }) : super(key: key);

  final int trainingId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<CheckInDialogViewModel>(),
      child: Consumer<CheckInDialogViewModel>(
        builder: (context, model, child) {
          final style = locator<Style>();

          return AlertDialog(
            title: Column(
              children: [
                const Text(
                  'Como você se sentiu no treino?',
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EmojiButton(
                      emoji: '😣',
                      selected: model.selectedIndex == 1,
                      onPressed: () => _handleEmojiPressed(context, 1),
                    ),
                    EmojiButton(
                      emoji: '🙁',
                      selected: model.selectedIndex == 2,
                      onPressed: () => _handleEmojiPressed(context, 2),
                    ),
                    EmojiButton(
                      emoji: '😐',
                      selected: model.selectedIndex == 3,
                      onPressed: () => _handleEmojiPressed(context, 3),
                    ),
                    EmojiButton(
                      emoji: '🙂',
                      selected: model.selectedIndex == 4,
                      onPressed: () => _handleEmojiPressed(context, 4),
                    ),
                    EmojiButton(
                      emoji: '😃',
                      selected: model.selectedIndex == 5,
                      onPressed: () => _handleEmojiPressed(context, 5),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: style.buttonAlertSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              ElevatedButton(
                style: style.buttonAlertPrimary,
                onPressed: model.enabled
                    ? () async {
                        final navigator = Navigator.of(context);
                        final Result result = await model.checkIn(trainingId);
                        navigator.pop();
                        if (result.success) {
                          UIHelper.showSuccess(context, result);
                        } else {
                          UIHelper.showError(context, result);
                        }
                      }
                    : null,
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      ),
    );
  }

  _handleEmojiPressed(BuildContext context, int index) {
    final model = Provider.of<CheckInDialogViewModel>(context, listen: false);
    model.setEnabled(value: true);
    model.selectedIndex = index;
  }
}

class EmojiButton extends StatelessWidget {
  const EmojiButton({
    Key? key,
    required this.emoji,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final String emoji;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: selected,
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
                color: Palette.accent,
                borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
        ),
        IconButton(
          onPressed: onPressed,
          constraints: const BoxConstraints(maxWidth: 48),
          padding: const EdgeInsets.all(2),
          icon: Text(
            emoji,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
