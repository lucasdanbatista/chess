import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/chess_view/promotion_option.dart';
import 'package:flutter/cupertino.dart';

const promotions = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight,
];

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;

  const PromotionDialog(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        SizedBox(
          height: 66,
          child: Row(
            children: promotions
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
