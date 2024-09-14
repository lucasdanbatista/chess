import 'package:en_passant/entities/chess_piece.dart';

class Move {
  final int from;
  final int to;
  final ChessPieceType promotionType;

  Move(
    this.from,
    this.to, {
    this.promotionType = ChessPieceType.promotion,
  });

  @override
  bool operator ==(other) => from == (other as Move).from && to == other.to;

  @override
  int get hashCode => from.hashCode + to.hashCode;
}
