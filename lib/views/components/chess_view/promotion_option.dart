import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/game/chess_theme.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flutter/cupertino.dart';

class PromotionOption extends StatelessWidget {
  final AppModel appModel;
  final ChessPieceType promotionType;

  const PromotionOption(this.appModel, this.promotionType, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image(
        image: AssetImage(
          'assets/images/pieces/${ChessTheme.formatPieceTheme(appModel.pieceTheme)}'
          '/${ChessTheme.pieceTypeToString(promotionType)}_${_playerColor()}.png',
        ),
      ),
      onPressed: () {
        appModel.game?.promote(promotionType);
        appModel.update();
        Navigator.pop(context);
      },
    );
  }

  String _playerColor() {
    return appModel.turn == Player.player1 ? 'white' : 'black';
  }
}
