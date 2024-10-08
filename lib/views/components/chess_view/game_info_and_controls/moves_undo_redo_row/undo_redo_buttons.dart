import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/chess_view/game_info_and_controls/moves_undo_redo_row/rounded_icon_button.dart';
import 'package:flutter/cupertino.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;

  bool get undoEnabled {
    if (appModel.playingWithAI) {
      return (appModel.game?.board.moveStack.length ?? 0) > 1 &&
          !appModel.isAdversaryTurn;
    } else {
      return appModel.game?.board.moveStack.isNotEmpty ?? false;
    }
  }

  bool get redoEnabled {
    if (appModel.playingWithAI) {
      return (appModel.game?.board.redoStack.length ?? 0) > 1 &&
          !appModel.isAdversaryTurn;
    } else {
      return appModel.game?.board.redoStack.isNotEmpty ?? false;
    }
  }

  const UndoRedoButtons(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedIconButton(
            CupertinoIcons.arrow_counterclockwise,
            onPressed: undoEnabled ? () => undo() : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RoundedIconButton(
            CupertinoIcons.arrow_clockwise,
            onPressed: redoEnabled ? () => redo() : null,
          ),
        ),
      ],
    );
  }

  void undo() {
    if (appModel.playingWithAI) {
      appModel.game?.undoTwoMoves();
    } else {
      appModel.game?.undoMove();
    }
  }

  void redo() {
    if (appModel.playingWithAI) {
      appModel.game?.redoTwoMoves();
    } else {
      appModel.game?.redoMove();
    }
  }
}
