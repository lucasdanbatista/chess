import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chess_piece.g.dart';

enum ChessPieceType { pawn, rook, knight, bishop, king, queen, promotion }

@JsonSerializable(explicitToJson: true, anyMap: true)
class ChessPiece {
  int id;
  ChessPieceType type;
  Player player;
  int moveCount = 0;
  int tile;

  int get value {
    int value = 0;
    switch (type) {
      case ChessPieceType.pawn:
        {
          value = 100;
        }
        break;
      case ChessPieceType.knight:
        {
          value = 320;
        }
        break;
      case ChessPieceType.bishop:
        {
          value = 330;
        }
        break;
      case ChessPieceType.rook:
        {
          value = 500;
        }
        break;
      case ChessPieceType.queen:
        {
          value = 900;
        }
        break;
      case ChessPieceType.king:
        {
          value = 20000;
        }
        break;
      default:
        {
          value = 0;
        }
    }
    return (player == Player.player1) ? value : -value;
  }

  ChessPiece(this.id, this.type, this.player, this.tile);

  factory ChessPiece.fromJson(Map<String, dynamic> json) =>
      _$ChessPieceFromJson(json);

  Map<String, dynamic> toJson() => _$ChessPieceToJson(this);
}
