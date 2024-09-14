import 'package:en_passant/entities/alpha_beta_pruning_move_evaluator.dart';
import 'package:en_passant/entities/board.dart';
import 'package:en_passant/entities/move_evaluator.dart';
import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/move.dart';
import 'package:en_passant/entities/move_meta.dart';
import 'package:en_passant/entities/move_stack_object.dart';
import 'package:en_passant/entities/openings.dart';
import 'package:en_passant/entities/piece_square_tables.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';

class BoardImpl implements Board {
  final kingRowPieces = [
    ChessPieceType.rook,
    ChessPieceType.knight,
    ChessPieceType.bishop,
    ChessPieceType.queen,
    ChessPieceType.king,
    ChessPieceType.bishop,
    ChessPieceType.knight,
    ChessPieceType.rook,
  ];

  @override
  List<ChessPiece?> tiles = List.filled(64, null);

  @override
  List<MoveStackObject> moveStack = [];

  @override
  List<MoveStackObject> redoStack = [];

  @override
  List<ChessPiece> player1Pieces = [];

  @override
  List<ChessPiece> player2Pieces = [];

  List<ChessPiece> player1Rooks = [];

  List<ChessPiece> player2Rooks = [];

  List<ChessPiece> player1Queens = [];

  List<ChessPiece> player2Queens = [];

  ChessPiece? player1King;

  ChessPiece? player2King;

  @override
  ChessPiece? enPassantPiece;

  bool player1KingInCheck = false;

  bool player2KingInCheck = false;

  @override
  List<List<Move>> possibleOpenings = List.from(openings);

  @override
  int moveCount = 0;

  late final MoveEvaluator moveEvaluator = AlphaBetaPruningMoveEvaluator(
    board: this,
  );

  BoardImpl() {
    _addPiecesForPlayer(Player.player1);
    _addPiecesForPlayer(Player.player2);
  }

  void _addPiecesForPlayer(Player player) {
    var kingRowOffset = player == Player.player1 ? 56 : 0;
    var pawnRowOffset = player == Player.player1 ? -8 : 8;
    var index = 0;
    for (var pieceType in kingRowPieces) {
      var id = player == Player.player1 ? index * 2 : index * 2 + 16;
      var piece = ChessPiece(id, pieceType, player, kingRowOffset + index);
      var pawn = ChessPiece(
        id + 1,
        ChessPieceType.pawn,
        player,
        kingRowOffset + pawnRowOffset + index,
      );
      _setTile(piece.tile, piece);
      _setTile(pawn.tile, pawn);
      piecesForPlayer(player).addAll([piece, pawn]);
      if (piece.type == ChessPieceType.king) {
        player == Player.player1 ? player1King = piece : player2King = piece;
      } else if (piece.type == ChessPieceType.queen) {
        _queensForPlayer(player).add(piece);
      } else if (piece.type == ChessPieceType.rook) {
        rooksForPlayer(player).add(piece);
      }
      index++;
    }
  }

  @override
  int get boardValue {
    int value = 0;
    for (var piece in player1Pieces + player2Pieces) {
      value += piece.value + squareValue(piece, _inEndGame());
    }
    return value;
  }

  @override
  MoveMeta push(
    Move move,
    MoveEvaluator evaluator, {
    bool getMeta = false,
    ChessPieceType promotionType = ChessPieceType.promotion,
  }) {
    var mso = MoveStackObject(
      move,
      tiles[move.from],
      tiles[move.to],
      enPassantPiece,
      List.from(possibleOpenings),
    );
    var meta = MoveMeta(move, mso.movedPiece?.player, mso.movedPiece?.type);
    if (possibleOpenings.isNotEmpty) {
      _filterPossibleOpenings(move);
    }
    if (getMeta) {
      _checkMoveAmbiguity(move, meta, evaluator);
    }
    if (_castled(mso.movedPiece, mso.takenPiece)) {
      _castle(mso, meta);
    } else {
      _standardMove(mso, meta);
      if (mso.movedPiece?.type == ChessPieceType.pawn) {
        if (_promotion(mso.movedPiece)) {
          mso.promotionType = promotionType;
          meta.promotionType = promotionType;
          _promote(mso, meta);
        }
        _checkEnPassant(mso, meta);
      }
    }
    if (_canTakeEnPassant(mso.movedPiece)) {
      enPassantPiece = mso.movedPiece;
    } else {
      enPassantPiece = null;
    }
    if (meta.type == ChessPieceType.pawn && meta.took) {
      meta.rowIsAmbiguous = true;
    }
    moveStack.add(mso);
    moveCount++;
    return meta;
  }

  @override
  MoveMeta pushMSO(
    MoveStackObject mso,
    MoveEvaluator evaluator,
  ) {
    return push(
      mso.move,
      evaluator,
      promotionType: mso.promotionType ?? ChessPieceType.promotion,
    );
  }

  @override
  MoveStackObject pop() {
    var mso = moveStack.removeLast();
    enPassantPiece = mso.enPassantPiece;
    possibleOpenings = mso.possibleOpenings ?? [];
    if (mso.castled) {
      _undoCastle(mso);
    } else {
      _undoStandardMove(mso);
      if (mso.promotion) {
        _undoPromote(mso);
      }
      if (mso.enPassant) {
        _addPiece(mso.enPassantPiece);
        _setTile(mso.enPassantPiece?.tile, mso.enPassantPiece);
      }
    }
    moveCount--;
    return mso;
  }

  void _standardMove(MoveStackObject mso, MoveMeta meta) {
    _setTile(mso.move.to, mso.movedPiece);
    _setTile(mso.move.from, null);
    mso.movedPiece?.moveCount++;
    if (mso.takenPiece != null) {
      _removePiece(mso.takenPiece);
      meta.took = true;
    }
  }

  void _undoStandardMove(MoveStackObject mso) {
    _setTile(mso.move.from, mso.movedPiece);
    _setTile(mso.move.to, null);
    if (mso.takenPiece != null) {
      _addPiece(mso.takenPiece);
      _setTile(mso.move.to, mso.takenPiece);
    }
    mso.movedPiece?.moveCount--;
  }

  void _castle(MoveStackObject mso, MoveMeta meta) {
    var king = mso.movedPiece?.type == ChessPieceType.king
        ? mso.movedPiece
        : mso.takenPiece;
    var rook = mso.movedPiece?.type == ChessPieceType.rook
        ? mso.movedPiece
        : mso.takenPiece;
    _setTile(king?.tile, null);
    _setTile(rook?.tile, null);
    var kingCol = Board.tileToCol(rook?.tile ?? 0) == 0 ? 2 : 6;
    var rookCol = Board.tileToCol(rook?.tile ?? 0) == 0 ? 3 : 5;
    _setTile(Board.tileToRow(king?.tile ?? 0) * 8 + kingCol, king);
    _setTile(Board.tileToRow(rook?.tile ?? 0) * 8 + rookCol, rook);
    Board.tileToCol(rook?.tile ?? 0) == 3
        ? meta.queenCastle = true
        : meta.kingCastle = true;
    king?.moveCount++;
    rook?.moveCount++;
    mso.castled = true;
  }

  void _undoCastle(MoveStackObject mso) {
    var king = mso.movedPiece?.type == ChessPieceType.king
        ? mso.movedPiece
        : mso.takenPiece;
    var rook = mso.movedPiece?.type == ChessPieceType.rook
        ? mso.movedPiece
        : mso.takenPiece;
    _setTile(king?.tile, null);
    _setTile(rook?.tile, null);
    var rookCol = Board.tileToCol(rook?.tile ?? 0) == 3 ? 0 : 7;
    _setTile(Board.tileToRow(king?.tile ?? 0) * 8 + 4, king);
    _setTile(Board.tileToRow(rook?.tile ?? 0) * 8 + rookCol, rook);
    king?.moveCount--;
    rook?.moveCount--;
  }

  void _promote(MoveStackObject mso, MoveMeta meta) {
    mso.movedPiece?.type = mso.promotionType ?? ChessPieceType.promotion;
    if (mso.promotionType != ChessPieceType.promotion) {
      addPromotedPiece(mso);
    }
    meta.promotion = true;
    mso.promotion = true;
  }

  @override
  void addPromotedPiece(MoveStackObject mso) {
    switch (mso.promotionType) {
      case ChessPieceType.queen:
        {
          if (mso.movedPiece != null) {
            _queensForPlayer(mso.movedPiece?.player ?? Player.player1)
                .add(mso.movedPiece!);
          }
        }
        break;
      case ChessPieceType.rook:
        {
          if (mso.movedPiece != null) {
            rooksForPlayer(mso.movedPiece?.player ?? Player.player1)
                .add(mso.movedPiece!);
          }
        }
        break;
      default:
        {}
    }
  }

  void _undoPromote(MoveStackObject mso) {
    mso.movedPiece?.type = ChessPieceType.pawn;
    switch (mso.promotionType) {
      case ChessPieceType.queen:
        {
          _queensForPlayer(mso.movedPiece?.player ?? Player.player1)
              .remove(mso.movedPiece);
        }
        break;
      case ChessPieceType.rook:
        {
          rooksForPlayer(mso.movedPiece?.player ?? Player.player1)
              .remove(mso.movedPiece);
        }
        break;
      default:
        {}
    }
  }

  void _checkEnPassant(MoveStackObject mso, MoveMeta meta) {
    var offset = mso.movedPiece?.player == Player.player1 ? 8 : -8;
    var tile = (mso.movedPiece?.tile ?? 0) + offset;
    var takenPiece = tiles[tile];
    if (takenPiece != null && takenPiece == enPassantPiece) {
      _removePiece(takenPiece);
      _setTile(takenPiece.tile, null);
      mso.enPassant = true;
    }
  }

  void _checkMoveAmbiguity(
    Move move,
    MoveMeta moveMeta,
    MoveEvaluator evaluator,
  ) {
    var piece = tiles[move.from];
    for (var otherPiece in _piecesOfTypeForPlayer(piece?.type, piece?.player)) {
      if (piece != otherPiece) {
        if (evaluator.getAvailableMoves(otherPiece).contains(move.to)) {
          if (Board.tileToCol(otherPiece.tile) ==
              Board.tileToCol(piece?.tile ?? 0)) {
            moveMeta.colIsAmbiguous = true;
          } else {
            moveMeta.rowIsAmbiguous = true;
          }
        }
      }
    }
  }

  void _filterPossibleOpenings(Move move) {
    possibleOpenings = possibleOpenings
        .where(
          (opening) =>
              opening[moveCount] == move && opening.length > moveCount + 1,
        )
        .toList();
  }

  void _setTile(int? tile, ChessPiece? piece) {
    if (tile != null) {
      tiles[tile] = piece;
    }
    if (piece != null) {
      piece.tile = tile ?? 0;
    }
  }

  void _addPiece(ChessPiece? piece) {
    if (piece != null) {
      piecesForPlayer(piece.player).add(piece);
      if (piece.type == ChessPieceType.rook) {
        rooksForPlayer(piece.player).add(piece);
      }
      if (piece.type == ChessPieceType.queen) {
        _queensForPlayer(piece.player).add(piece);
      }
    }
  }

  void _removePiece(ChessPiece? piece) {
    if (piece != null) {
      piecesForPlayer(piece.player).remove(piece);
      if (piece.type == ChessPieceType.rook) {
        rooksForPlayer(piece.player).remove(piece);
      }
      if (piece.type == ChessPieceType.queen) {
        _queensForPlayer(piece.player).remove(piece);
      }
    }
  }

  @override
  List<ChessPiece> piecesForPlayer(Player player) {
    return player == Player.player1 ? player1Pieces : player2Pieces;
  }

  @override
  ChessPiece? kingForPlayer(Player player) {
    return player == Player.player1 ? player1King : player2King;
  }

  @override
  List<ChessPiece> rooksForPlayer(Player player) {
    return player == Player.player1 ? player1Rooks : player2Rooks;
  }

  List<ChessPiece> _queensForPlayer(Player player) {
    return player == Player.player1 ? player1Queens : player2Queens;
  }

  List<ChessPiece> _piecesOfTypeForPlayer(
    ChessPieceType? type,
    Player? player,
  ) {
    List<ChessPiece> pieces = [];
    if (type != null && player != null) {
      for (var piece in piecesForPlayer(player)) {
        if (piece.type == type) {
          pieces.add(piece);
        }
      }
    }
    return pieces;
  }

  bool _castled(ChessPiece? movedPiece, ChessPiece? takenPiece) {
    return takenPiece != null && takenPiece.player == movedPiece?.player;
  }

  bool _promotion(ChessPiece? movedPiece) {
    return movedPiece?.type == ChessPieceType.pawn &&
        (Board.tileToRow(movedPiece?.tile ?? 0) == 7 ||
            Board.tileToRow(movedPiece?.tile ?? 0) == 0);
  }

  bool _canTakeEnPassant(ChessPiece? movedPiece) {
    return movedPiece?.moveCount == 1 &&
        movedPiece?.type == ChessPieceType.pawn &&
        (Board.tileToRow(movedPiece?.tile ?? 0) == 3 ||
            Board.tileToRow(movedPiece?.tile ?? 0) == 4);
  }

  bool _inEndGame() {
    return (_queensForPlayer(Player.player1).isEmpty &&
            _queensForPlayer(Player.player2).isEmpty) ||
        piecesForPlayer(Player.player1).length <= 3 ||
        piecesForPlayer(Player.player2).length <= 3;
  }
}
