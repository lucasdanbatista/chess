import 'package:en_passant/entities/board.dart';
import 'package:en_passant/entities/chess_piece.dart';
import 'package:en_passant/entities/move_meta.dart';
import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';

class MoveList extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0x20000000),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Center(child: TextRegular(_allMoves())),
      ),
    );
  }

  void _scrollToBottom() {
    if (appModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.moveListUpdated = false;
    }
  }

  String _allMoves() {
    var moveString = '';
    appModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameOver) {
      if (appModel.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.turn == Player.player2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = 'O-O';
    } else if (meta.queenCastle) {
      move = 'O-O-O';
    } else {
      String ambiguity = meta.rowIsAmbiguous
          ? _colToChar(Board.tileToCol(meta.move?.from ?? 0))
          : '';
      ambiguity += meta.colIsAmbiguous
          ? '${8 - Board.tileToRow(meta.move?.from ?? 0)}'
          : '';
      String takeString = meta.took ? 'x' : '';
      String promotion = meta.promotion
          ? '=${_pieceToChar(meta.promotionType ?? ChessPieceType.promotion)}'
          : '';
      String row = '${8 - Board.tileToRow(meta.move?.to ?? 0)}';
      String col = _colToChar(Board.tileToCol(meta.move?.to ?? 0));
      move =
          '${_pieceToChar(meta.type ?? ChessPieceType.promotion)}$ambiguity$takeString'
          '$col$row$promotion';
    }
    String check = meta.isCheck ? '+' : '';
    String checkmate = meta.isCheckmate && !meta.isStalemate ? '#' : '';
    return '$move$check$checkmate';
  }

  String _pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          return 'K';
        }
      case ChessPieceType.queen:
        {
          return 'Q';
        }
      case ChessPieceType.rook:
        {
          return 'R';
        }
      case ChessPieceType.bishop:
        {
          return 'B';
        }
      case ChessPieceType.knight:
        {
          return 'N';
        }
      case ChessPieceType.pawn:
        {
          return '';
        }
      default:
        {
          return '?';
        }
    }
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
