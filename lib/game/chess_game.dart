import 'dart:async';

import 'package:async/async.dart';
import 'package:en_passant/entities/alpha_beta_pruning_move_evaluator.dart';
import 'package:en_passant/entities/board.dart';
import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/move.dart';
import 'package:en_passant/entities/move_evaluator.dart';
import 'package:en_passant/entities/move_event.dart';
import 'package:en_passant/entities/move_meta.dart';
import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/game/chess_piece_sprite.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ChessGame extends Game with TapDetector {
  final double screenWidth;
  AppModel appModel;
  Board board = Board();
  Map<ChessPiece, ChessPieceSprite> spriteMap = {};
  late final MoveEvaluator moveEvaluator = AlphaBetaPruningMoveEvaluator(
    board: board,
    bot: appModel.adversary,
    difficulty: appModel.aiDifficulty,
  );

  CancelableOperation? aiOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;

  ChessGame(this.appModel, this.screenWidth) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, appModel.pieceTheme);
    }
    _initSpritePositions();
    if (appModel.isAdversaryTurn) {
      _aiMove();
    }
    _listenServerEvents();
  }

  double get tileSize => screenWidth / 8;

  void _listenServerEvents() async {
    await FirebaseDatabase.instance.ref('1').remove();
    FirebaseDatabase.instance.ref('1').onValue.listen((db) {
      if (db.snapshot.value == null) return;
      final event = MoveEvent.fromJson(db.snapshot.value as Map);
      if (event.player != appModel.turn) return;
      final piece = board.tiles[event.from]!;
      appModel.turn = event.player;
      _selectPiece(piece);
      _movePiece(event.to);
    });
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (appModel.gameOver || !(appModel.isAdversaryTurn)) {
      var tile = _vector2ToTile(info.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];
        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == selectedPiece?.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (selectedPiece == null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawBoard(canvas);
    if (appModel.showHints) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawPieces(canvas);
    if (appModel.showHints) {
      _drawMoveHints(canvas);
    }
  }

  @override
  void update(double dt) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.update(tileSize, appModel, piece);
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.initSpritePosition(tileSize, appModel);
    }
  }

  void _selectPiece(ChessPiece? piece) {
    if (piece != null) {
      if (piece.player == appModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = moveEvaluator.getAvailableMoves(piece);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      var meta = board.push(
        Move(selectedPiece?.tile ?? 0, tile),
        moveEvaluator,
        getMeta: true,
      );
      if (meta.promotion) {
        appModel.requestPromotion();
      }
      _moveCompletion(meta, changeTurn: !meta.promotion);
    }
  }

  static Move _aiMoveComputation(Map<String, dynamic> args) {
    final evaluator = args['evaluator'] as MoveEvaluator;
    final player = args['player'] as Player;
    return evaluator.evaluate(player);
  }

  void _aiMove() async {
    if(appModel.isOnline) return;
    await Future.delayed(const Duration(milliseconds: 500));
    var args = <String, dynamic>{
      'player': appModel.adversary,
      'evaluator': moveEvaluator,
    };
    aiOperation = CancelableOperation.fromFuture(
      compute(_aiMoveComputation, args),
    );
    aiOperation?.value.then((move) {
      if (move == null || appModel.gameOver) {
        appModel.endGame();
      } else {
        validMoves = [];
        var meta = board.push(move, moveEvaluator, getMeta: true);
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType);
        }
      }
    });
  }

  void cancelAIMove() => aiOperation?.cancel();

  void undoMove() {
    board.redoStack.add(board.pop());
    if (appModel.moveMetaList.length > 1) {
      var meta = appModel.moveMetaList[appModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(board.pop());
    board.redoStack.add(board.pop());
    appModel.popMoveMeta();
    if (appModel.moveMetaList.length > 1) {
      _moveCompletion(
        appModel.moveMetaList[appModel.moveMetaList.length - 2],
        clearRedo: false,
        undoing: true,
        changeTurn: false,
      );
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.popMoveMeta();
  }

  void redoMove() {
    _moveCompletion(
      board.pushMSO(
        board.redoStack.removeLast(),
        moveEvaluator,
      ),
      clearRedo: false,
    );
  }

  void redoTwoMoves() {
    _moveCompletion(
      board.pushMSO(
        board.redoStack.removeLast(),
        moveEvaluator,
      ),
      clearRedo: false,
      updateMetaList: true,
    );
    _moveCompletion(
      board.pushMSO(
        board.redoStack.removeLast(),
        moveEvaluator,
      ),
      clearRedo: false,
      updateMetaList: true,
    );
  }

  void promote(ChessPieceType type) {
    board.moveStack.last.movedPiece?.type = type;
    board.moveStack.last.promotionType = type;
    board.addPromotedPiece(board.moveStack.last);
    appModel.moveMetaList.last.promotionType = type;
    _moveCompletion(appModel.moveMetaList.last, updateMetaList: false);
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack.clear();
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = Board.oppositePlayer(appModel.turn);
    if (moveEvaluator.isKingInCheck(player: oppositeTurn)) {
      meta.isCheck = true;
      checkHintTile = board.kingForPlayer(oppositeTurn)?.tile;
    }
    if (moveEvaluator.isKingInCheckmate(player: oppositeTurn)) {
      if (!meta.isCheck) {
        appModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }
    if (undoing) {
      appModel.popMoveMeta();
      appModel.undoEndGame();
    } else if (updateMetaList) {
      appModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      appModel.changeTurn();
    }
    selectedPiece = null;
    if (appModel.isAdversaryTurn && clearRedo && changeTurn) {
      _aiMove();
    }
    FirebaseDatabase.instance.ref('1').set(
          MoveEvent(
            player: Board.oppositePlayer(appModel.turn),
            from: meta.move!.from,
            to: meta.move!.to,
          ).toJson(),
        );
  }

  int _vector2ToTile(Vector2 vector2) {
    if (appModel.flip &&
        appModel.playingWithAI &&
        appModel.playerSide == Player.player2) {
      return (7 - (vector2.y / (tileSize)).floor()) * 8 +
          (7 - (vector2.x / (tileSize)).floor());
    } else {
      return (vector2.y / (tileSize)).floor() * 8 +
          (vector2.x / (tileSize)).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * (tileSize),
          (tileNo / 8).floor() * (tileSize),
          (tileSize),
          (tileSize),
        ),
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? appModel.theme.lightTile
              : appModel.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.sprite?.render(
            canvas,
            size: Vector2((tileSize) - 10, (tileSize) - 10),
            position: Vector2(
              (spriteMap[piece]?.spriteX ?? 0) + 5,
              (spriteMap[piece]?.spriteY ?? 0) + 5,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, (tileSize), appModel) + ((tileSize) / 2),
          getYFromTile(tile, (tileSize), appModel) + ((tileSize) / 2),
        ),
        (tileSize) / 5,
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.from, tileSize, appModel),
          getYFromTile(latestMove!.from, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.to, tileSize, appModel),
          getYFromTile(latestMove!.to, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile!, tileSize, appModel),
          getYFromTile(checkHintTile!, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.theme.checkHint,
      );
    }
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece!.tile, tileSize, appModel),
          getYFromTile(selectedPiece!.tile, tileSize, appModel),
          tileSize,
          tileSize,
        ),
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }

  static double getXFromTile(int tile, double tileSize, AppModel appModel) {
    return appModel.flip &&
            appModel.playingWithAI &&
            appModel.playerSide == Player.player2
        ? (7 - Board.tileToCol(tile)) * tileSize
        : Board.tileToCol(tile) * tileSize;
  }

  static double getYFromTile(int tile, double tileSize, AppModel appModel) {
    return appModel.flip &&
            appModel.playingWithAI &&
            appModel.playerSide == Player.player2
        ? (7 - Board.tileToRow(tile)) * tileSize
        : Board.tileToRow(tile) * tileSize;
  }
}
