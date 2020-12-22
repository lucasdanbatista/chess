import 'package:en_passant/logic/tile.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chess_piece.dart';

const KING_ROW_PIECES = [
  ChessPieceType.rook,
  ChessPieceType.knight,
  ChessPieceType.bishop,
  ChessPieceType.queen,
  ChessPieceType.king,
  ChessPieceType.bishop,
  ChessPieceType.knight,
  ChessPieceType.rook
];

class ChessBoard {
  List<List<ChessPiece>> board;
  List<ChessPiece> player1Pieces = [];
  List<ChessPiece> player2Pieces = [];
  ChessPiece player1King;
  ChessPiece player2King;
  List<ChessPiece> player1Rooks = [];
  List<ChessPiece> player2Rooks = [];
  ChessPiece enPassantPiece;

  ChessBoard({bool initPieces = true}) {
    this.board = List.generate(8, (index) => List.generate(8, (index) => null));
    if (initPieces) {
      addPiecesFor(player: PlayerID.player1);
      addPiecesFor(player: PlayerID.player2);
    }
  }

  ChessBoard copy() {
    var boardCopy = ChessBoard(initPieces: false);
    for (var piece in player1Pieces + player2Pieces) {
      var pieceCopy = ChessPiece.fromPiece(existingPiece: piece);
      boardCopy.addPiece(piece: pieceCopy, tile: pieceCopy.tile);
      if (pieceCopy.type == ChessPieceType.king) {
        pieceCopy.player == PlayerID.player1 ?
          boardCopy.player1King = pieceCopy : boardCopy.player2King = pieceCopy;
      } else if (pieceCopy.type == ChessPieceType.rook) {
        pieceCopy.player == PlayerID.player1 ?
          boardCopy.player1Rooks.add(pieceCopy) : boardCopy.player2Rooks.add(pieceCopy);
      }
      if (enPassantPiece != null && enPassantPiece == pieceCopy) {
        boardCopy.enPassantPiece = enPassantPiece;
      }
    }
    return boardCopy;
  }

  void addPiecesFor({@required PlayerID player}) {
    for (var index = 0; index < 8; index++) {
      var pawn = ChessPiece(
        type: ChessPieceType.pawn,
        belongsTo: player,
        tile: Tile(row: player == PlayerID.player1 ? 1 : 6, col: index)
      );
      var piece = ChessPiece(
        type: KING_ROW_PIECES[index],
        belongsTo: player,
        tile: Tile(row: player == PlayerID.player1 ? 0 : 7, col: index)
      );
      addPiece(piece: pawn, tile: pawn.tile);
      addPiece(piece: piece, tile: piece.tile);
      if (piece.type == ChessPieceType.king) {
        piece.player == PlayerID.player1 ?
          player1King = piece : player2King = piece;
      }
    }
  }

  void addPiece({@required ChessPiece piece, @required Tile tile}) {
    board[tile.row][tile.col] = piece;
    piece.player == PlayerID.player1 ?
      player1Pieces.add(piece) : player2Pieces.add(piece);
    if (piece.type == ChessPieceType.rook) {
      piece.player == PlayerID.player1 ?
        player1Rooks.add(piece) : player2Rooks.add(piece);
    }
  }

  void removePiece({@required Tile tile}) {
    var possiblePiece = pieceAtTile(tile);
    if (possiblePiece != null) {
      piecesForPlayer(possiblePiece.player).remove(possiblePiece);
      if (possiblePiece.type == ChessPieceType.rook) {
        rooksForPlayer(possiblePiece.player).remove(possiblePiece);
      }
    }
  }

  void movePiece({@required Tile from, @required Tile to}) {
    var movedPiece = board[from.row][from.col];
    var takenPiece = board[to.row][to.col];
    movedPiece.moveCount++;
    if (takenPiece != null && takenPiece.player == movedPiece.player) {
      takenPiece.moveCount++;
      movedPiece.type == ChessPieceType.king ?
          castling(king: movedPiece, rook: takenPiece) :
          castling(king: takenPiece, rook: movedPiece);
    } else {
      board[from.row][from.col] = null;
      removePiece(tile: to);
      board[to.row][to.col] = movedPiece;
      movedPiece.tile = to;
      if (movedPiece.type == ChessPieceType.pawn) {
        if (to.row == 7 || to.row == 0) {
          pawnToQueen(pawn: movedPiece);
        }
        checkEnPassant(pawn: movedPiece);
        if ((from.row - to.row).abs() == 2) {
          enPassantPiece = movedPiece;
        }
      }
    }
  }

  void castling({@required ChessPiece king, @required ChessPiece rook}) {
    board[king.tile.row][king.tile.col] = null;
    board[rook.tile.row][rook.tile.col] = null;
    var rookCol = rook.tile.col == 0 ? 3 : 5;
    var kingCol = rook.tile.col == 0 ? 2 : 6;
    board[rook.tile.row][rook.tile.col == 0 ? 3 : 5] = rook;
    board[rook.tile.row][rook.tile.col == 0 ? 2 : 6] = king;
    rook.tile = Tile(row: rook.tile.row, col: rookCol);
    king.tile = Tile(row: rook.tile.row, col: kingCol);
  }

  void pawnToQueen({@required ChessPiece pawn}) {
    removePiece(tile: pawn.tile);
    var queen = ChessPiece(
      belongsTo: pawn.player,
      type: ChessPieceType.queen,
      tile: pawn.tile
    );
    addPiece(piece: queen, tile: pawn.tile);
    queen.spriteX = pawn.spriteX;
    queen.spriteY = pawn.spriteY;
  }

  void checkEnPassant({@required ChessPiece pawn}) {
    var offset = pawn.player == PlayerID.player1 ? -1 : 1;
    var tile = Tile(row: pawn.tile.row + offset, col: pawn.tile.col);
    var takenPiece = pieceAtTile(tile);
    if (takenPiece != null && takenPiece == enPassantPiece) {
      removePiece(tile: tile);
    }
    enPassantPiece = null;
  }

  ChessPiece pieceAtTile(Tile tile) {
    return board[tile.row][tile.col];
  }

  List<ChessPiece> piecesForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Pieces : player2Pieces;
  }

  ChessPiece kingForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1King : player2King;
  }

  List<ChessPiece> rooksForPlayer(PlayerID player) {
    return player == PlayerID.player1 ? player1Rooks : player2Rooks;
  }
}