// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess_piece.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChessPiece _$ChessPieceFromJson(Map json) => ChessPiece(
      (json['id'] as num).toInt(),
      $enumDecode(_$ChessPieceTypeEnumMap, json['type']),
      $enumDecode(_$PlayerEnumMap, json['player']),
      (json['tile'] as num).toInt(),
    )..moveCount = (json['moveCount'] as num).toInt();

Map<String, dynamic> _$ChessPieceToJson(ChessPiece instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ChessPieceTypeEnumMap[instance.type]!,
      'player': _$PlayerEnumMap[instance.player]!,
      'moveCount': instance.moveCount,
      'tile': instance.tile,
    };

const _$ChessPieceTypeEnumMap = {
  ChessPieceType.pawn: 'pawn',
  ChessPieceType.rook: 'rook',
  ChessPieceType.knight: 'knight',
  ChessPieceType.bishop: 'bishop',
  ChessPieceType.king: 'king',
  ChessPieceType.queen: 'queen',
  ChessPieceType.promotion: 'promotion',
};

const _$PlayerEnumMap = {
  Player.player1: 'player1',
  Player.player2: 'player2',
  Player.random: 'random',
};
