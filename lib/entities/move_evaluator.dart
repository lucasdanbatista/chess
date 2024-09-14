import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/move.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

abstract interface class MoveEvaluator {
  Move evaluate(Player player);

  List<int> getAvailableMoves(
    ChessPiece piece, {
    bool isLegal = true,
  });

  List<Move> getAllMoves({
    required Player player,
    required int difficulty,
  });

  bool isKingInCheck({required Player player});

  bool isKingInCheckmate({required Player player});
}
