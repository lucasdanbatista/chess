import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/chess_view/chess_board_widget.dart';
import 'package:en_passant/views/components/chess_view/game_info_and_controls.dart';
import 'package:en_passant/views/components/chess_view/promotion_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:en_passant/views/components/chess_view/game_info_and_controls/game_status.dart';
import 'package:en_passant/views/components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  const ChessView(this.appModel, {super.key});

  @override
  State<StatefulWidget> createState() => _ChessViewState();
}

class _ChessViewState extends State<ChessView> {
  @override
  Widget build(context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (_) {},
          child: Container(
            decoration: BoxDecoration(gradient: appModel.theme.background),
            child: Column(
              children: [
                const Spacer(),
                ChessBoardWidget(appModel),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: GameStatus(),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: GameInfoAndControls(appModel),
                ),
                const BottomPadding(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }
}
