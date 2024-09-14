import 'package:en_passant/entities/board_impl.dart';
import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/move.dart';
import 'package:en_passant/entities/move_evaluator.dart';
import 'package:en_passant/entities/move_meta.dart';
import 'package:en_passant/entities/move_stack_object.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

abstract interface class Board {
  factory Board() => BoardImpl();

  List<ChessPiece?> get tiles;

  List<MoveStackObject> get moveStack;

  List<MoveStackObject> get redoStack;

  List<ChessPiece> get player1Pieces;

  List<ChessPiece> get player2Pieces;

  ChessPiece? get enPassantPiece;

  List<List<Move>> get possibleOpenings;

  int get moveCount;

  ChessPiece? kingForPlayer(Player player);

  List<ChessPiece> piecesForPlayer(Player player);

  List<ChessPiece> rooksForPlayer(Player player);

  MoveMeta push(
    Move move,
    MoveEvaluator evaluator, {
    bool getMeta = false,
    ChessPieceType promotionType = ChessPieceType.promotion,
  });

  MoveMeta pushMSO(
    MoveStackObject mso,
    MoveEvaluator evaluator,
  );

  MoveStackObject pop();

  void addPromotedPiece(MoveStackObject mso);

  int get boardValue;

  static int tileToRow(int tile) => (tile / 8).floor();

  static int tileToCol(int tile) => tile % 8;

  static Player oppositePlayer(Player player) =>
      player == Player.player1 ? Player.player2 : Player.player1;
}
