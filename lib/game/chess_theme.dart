import 'package:en_passant/entities/chess_piece.dart';

enum PieceTheme {
  classic('Classic'),
  angular('Angular'),
  eightBit('8-Bit'),
  letters('Letters'),
  videoChess('Video Chess'),
  lewisChessmen('Lewis Chessmen'),
  mexicoCity('Mexico City'),
  neoWood('Neo Wood');

  final String name;

  const PieceTheme(this.name);
}

class ChessTheme {
  ChessTheme._();

  static String formatPieceTheme(String themeString) {
    return themeString.toLowerCase().replaceAll(' ', '');
  }

  static String pieceTypeToString(ChessPieceType type) {
    return type.toString().substring(type.toString().indexOf('.') + 1);
  }
}
