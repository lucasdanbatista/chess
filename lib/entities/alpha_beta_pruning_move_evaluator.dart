import 'dart:math';

import 'package:en_passant/entities/board.dart';
import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/direction.dart';
import 'package:en_passant/entities/move.dart';
import 'package:en_passant/entities/move_and_value.dart';
import 'package:en_passant/entities/move_evaluator.dart';
import 'package:en_passant/views/components/chess_view/promotion_dialog.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

class AlphaBetaPruningMoveEvaluator implements MoveEvaluator {
  static const initialAlpha = -40000;
  static const stalemateAlpha = -20000;
  static const initialBeta = 40000;
  static const stalemateBeta = 20000;
  static const pawnDiagonals1 = [Direction.downLeft, Direction.downRight];
  static const pawnDiagonals2 = [Direction.upLeft, Direction.upRight];
  static const knightMoves = [
    Direction.upTwoRight,
    Direction.upTwoLeft,
    Direction.downTwoRight,
    Direction.downTwoLeft,
    Direction.rightTwoUp,
    Direction.rightTwoDown,
    Direction.leftTwoUp,
    Direction.leftTwoDown,
  ];
  static const bishopMoves = [
    Direction.upRight,
    Direction.downRight,
    Direction.downLeft,
    Direction.upLeft,
  ];
  static const rookMoves = [
    Direction.up,
    Direction.right,
    Direction.down,
    Direction.left,
  ];
  static const kingQueenMoves = [
    Direction.up,
    Direction.upRight,
    Direction.right,
    Direction.downRight,
    Direction.down,
    Direction.downLeft,
    Direction.left,
    Direction.upLeft,
  ];
  final Board board;
  final Player? bot;
  final int? difficulty;

  AlphaBetaPruningMoveEvaluator({
    required this.board,
    this.bot,
    this.difficulty,
  });

  @override
  Move evaluate(Player player) {
    if (board.possibleOpenings.isNotEmpty) return _openingMove(board, player);
    return _alphaBeta(
      board,
      bot!,
      Move(0, 0),
      0,
      difficulty!,
      initialAlpha,
      initialBeta,
    ).move;
  }

  @override
  List<int> getAvailableMoves(
    ChessPiece piece, {
    bool isLegal = true,
  }) {
    List<int> moves;
    switch (piece.type) {
      case ChessPieceType.pawn:
        {
          moves = _pawnMoves(piece, board);
        }
        break;
      case ChessPieceType.knight:
        {
          moves = _knightMoves(piece);
        }
        break;
      case ChessPieceType.bishop:
        {
          moves = _bishopMoves(piece);
        }
        break;
      case ChessPieceType.rook:
        {
          moves = _rookMoves(piece, isLegal);
        }
        break;
      case ChessPieceType.queen:
        {
          moves = _queenMoves(piece);
        }
        break;
      case ChessPieceType.king:
        {
          moves = _kingMoves(piece, isLegal);
        }
        break;
      default:
        {
          moves = [];
        }
    }
    if (isLegal) {
      moves.removeWhere((move) => _movePutsKingInCheck(piece, move, board));
    }
    return moves;
  }

  @override
  List<Move> getAllMoves({
    required Player player,
    required int difficulty,
  }) {
    List<MoveAndValue> moves = [];
    var pieces = List.from(board.piecesForPlayer(player));
    for (var piece in pieces) {
      var tiles = getAvailableMoves(piece);
      for (var tile in tiles) {
        if (piece.type == ChessPieceType.pawn &&
            (Board.tileToRow(tile) == 0 || Board.tileToRow(tile) == 7)) {
          for (var promotion in promotions) {
            var move = MoveAndValue(
              Move(piece.tile, tile, promotionType: promotion),
              0,
            );
            board.push(move.move, this, promotionType: promotion);
            move.value = board.boardValue;
            board.pop();
            moves.add(move);
          }
        } else {
          var move = MoveAndValue(Move(piece.tile, tile), 0);
          board.push(move.move, this);
          move.value = board.boardValue;
          board.pop();
          moves.add(move);
        }
      }
    }
    moves.sort((a, b) => _compareMoves(a, b, player, board));
    return moves.map((move) => move.move).toList();
  }

  int _compareMoves(
    MoveAndValue a,
    MoveAndValue b,
    Player player,
    Board board,
  ) {
    return player == Player.player1
        ? b.value.compareTo(a.value)
        : a.value.compareTo(b.value);
  }

  List<int> _pawnMoves(ChessPiece pawn, Board board) {
    List<int> moves = [];
    var offset = pawn.player == Player.player1 ? -8 : 8;
    var firstTile = pawn.tile + offset;
    if (board.tiles[firstTile] == null) {
      moves.add(firstTile);
      if (pawn.moveCount == 0) {
        var secondTile = firstTile + offset;
        if (board.tiles[secondTile] == null) {
          moves.add(secondTile);
        }
      }
    }
    return moves + _pawnDiagonalAttacks(pawn, board);
  }

  List<int> _pawnDiagonalAttacks(ChessPiece pawn, Board board) {
    List<int> moves = [];
    var diagonals =
        pawn.player == Player.player1 ? pawnDiagonals1 : pawnDiagonals2;
    for (var diagonal in diagonals) {
      var row = Board.tileToRow(pawn.tile) + diagonal.row;
      var col = Board.tileToCol(pawn.tile) + diagonal.column;
      if (_inBounds(row, col)) {
        var takenPiece = board.tiles[_rowColToTile(row, col)];
        if ((takenPiece != null &&
                takenPiece.player == Board.oppositePlayer(pawn.player)) ||
            _canTakeEnPassant(pawn.player, _rowColToTile(row, col), board)) {
          moves.add(_rowColToTile(row, col));
        }
      }
    }
    return moves;
  }

  bool _canTakeEnPassant(Player pawnPlayer, int diagonal, Board board) {
    var offset = (pawnPlayer == Player.player1) ? 8 : -8;
    var takenPiece = board.tiles[diagonal + offset];
    return takenPiece != null &&
        takenPiece.player != pawnPlayer &&
        takenPiece == board.enPassantPiece;
  }

  List<int> _knightMoves(ChessPiece knight) {
    return _movesFromDirections(knight, knightMoves, false);
  }

  List<int> _bishopMoves(ChessPiece bishop) {
    return _movesFromDirections(bishop, bishopMoves, true);
  }

  List<int> _rookMoves(ChessPiece rook, bool isLegal) {
    return _movesFromDirections(rook, rookMoves, true) +
        _rookCastleMove(rook, isLegal);
  }

  List<int> _queenMoves(ChessPiece queen) {
    return _movesFromDirections(queen, kingQueenMoves, true);
  }

  List<int> _kingMoves(ChessPiece king, bool isLegal) {
    return _movesFromDirections(king, kingQueenMoves, false) +
        _kingCastleMoves(king, isLegal);
  }

  List<int> _rookCastleMove(ChessPiece rook, bool isLegal) {
    if (!isLegal || !isKingInCheck(player: rook.player)) {
      var king = board.kingForPlayer(rook.player);
      if (_canCastle(king, rook, isLegal)) {
        return [king?.tile ?? 0];
      }
    }
    return [];
  }

  List<int> _kingCastleMoves(ChessPiece king, bool isLegal) {
    List<int> moves = [];
    if (!isLegal || !isKingInCheck(player: king.player)) {
      for (var rook in board.rooksForPlayer(king.player)) {
        if (_canCastle(king, rook, isLegal)) {
          moves.add(rook.tile);
        }
      }
    }
    return moves;
  }

  bool _canCastle(
    ChessPiece? king,
    ChessPiece rook,
    bool isLegal,
  ) {
    if (rook.moveCount == 0 && king?.moveCount == 0) {
      var offset = (king?.tile ?? 0) - rook.tile > 0 ? 1 : -1;
      var tile = rook.tile;
      while (tile != king?.tile) {
        tile += offset;
        if ((board.tiles[tile] != null && tile != king?.tile) ||
            (isLegal &&
                _kingInCheckAtTile(
                  tile,
                  king?.player ?? Player.player1,
                  board,
                ))) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  List<int> _movesFromDirections(
    ChessPiece piece,
    List<Direction> directions,
    bool repeat,
  ) {
    List<int> moves = [];
    for (var direction in directions) {
      var row = Board.tileToRow(piece.tile);
      var col = Board.tileToCol(piece.tile);
      do {
        row += direction.row;
        col += direction.column;
        if (_inBounds(row, col)) {
          var possiblePiece = board.tiles[_rowColToTile(row, col)];
          if (possiblePiece != null) {
            if (possiblePiece.player != piece.player) {
              moves.add(_rowColToTile(row, col));
            }
            break;
          } else {
            moves.add(_rowColToTile(row, col));
          }
        }
        if (!repeat) {
          break;
        }
      } while (_inBounds(row, col));
    }
    return moves;
  }

  bool _movePutsKingInCheck(ChessPiece piece, int move, Board board) {
    board.push(Move(piece.tile, move), this);
    var check = isKingInCheck(player: piece.player);
    board.pop();
    return check;
  }

  bool _kingInCheckAtTile(int tile, Player player, Board board) {
    for (var piece in board.piecesForPlayer(Board.oppositePlayer(player))) {
      if (getAvailableMoves(piece, isLegal: false).contains(tile)) {
        return true;
      }
    }
    return false;
  }

  @override
  bool isKingInCheck({required Player player}) {
    for (var piece in board.piecesForPlayer(Board.oppositePlayer(player))) {
      if (getAvailableMoves(piece, isLegal: false)
          .contains(board.kingForPlayer(player)?.tile)) {
        return true;
      }
    }
    return false;
  }

  @override
  bool isKingInCheckmate({required Player player}) {
    for (var piece in board.piecesForPlayer(player)) {
      if (getAvailableMoves(piece).isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  bool _inBounds(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  int _rowColToTile(int row, int col) {
    return row * 8 + col;
  }

  MoveAndValue _alphaBeta(
    Board board,
    Player player,
    Move move,
    int depth,
    int maxDepth,
    int alpha,
    int beta,
  ) {
    if (depth == maxDepth) {
      return MoveAndValue(move, board.boardValue);
    }
    var bestMove = MoveAndValue(
      Move(0, 0),
      player == Player.player1 ? initialAlpha : initialBeta,
    );
    for (var move in getAllMoves(
      player: player,
      difficulty: maxDepth,
    )) {
      board.push(move, this, promotionType: move.promotionType);
      var result = _alphaBeta(
        board,
        Board.oppositePlayer(player),
        move,
        depth + 1,
        maxDepth,
        alpha,
        beta,
      );
      result.move = move;
      board.pop();
      if (player == Player.player1) {
        if (result.value > bestMove.value) {
          bestMove = result;
        }
        alpha = max(alpha, bestMove.value);
        if (alpha >= beta) {
          break;
        }
      } else {
        if (result.value < bestMove.value) {
          bestMove = result;
        }
        beta = min(beta, bestMove.value);
        if (beta <= alpha) {
          break;
        }
      }
    }
    if (bestMove.value.abs() == initialBeta && !isKingInCheck(player: player)) {
      if (board.piecesForPlayer(player).length == 1) {
        bestMove.value =
            player == Player.player1 ? stalemateBeta : stalemateAlpha;
      } else {
        bestMove.value =
            player == Player.player1 ? stalemateAlpha : stalemateBeta;
      }
    }
    return bestMove;
  }

  Move _openingMove(Board board, Player aiPlayer) {
    List<Move> possibleMoves = board.possibleOpenings
        .map((opening) => opening[board.moveCount])
        .toList();
    return possibleMoves[Random.secure().nextInt(possibleMoves.length)];
  }
}
