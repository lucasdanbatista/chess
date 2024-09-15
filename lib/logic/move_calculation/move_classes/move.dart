import 'package:en_passant/logic/chess_piece.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Move {
  int from;
  int to;
  ChessPieceType promotionType;

  Move(this.from, this.to, {this.promotionType = ChessPieceType.promotion});

  @override
  bool operator ==(move) =>
      this.from == (move as Move).from && (this as Move).to == move.to;

  @override
  int get hashCode => super.hashCode;

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);

  Map<String, dynamic> toJson() => _$MoveToJson(this);
}
