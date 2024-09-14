import 'package:en_passant/game/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:en_passant/views/components/chess_view/game_info_and_controls/moves_undo_redo_row.dart';
import 'package:en_passant/views/components/chess_view/game_info_and_controls/restart_exit_buttons.dart';
import 'package:en_passant/views/components/chess_view/game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height > 700 ? 204 : 134,
      ),
      child: ListView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Timers(appModel),
          MovesUndoRedoRow(appModel),
          RestartExitButtons(appModel),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
