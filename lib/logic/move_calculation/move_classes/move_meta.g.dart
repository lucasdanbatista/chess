// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveMeta _$MoveMetaFromJson(Map json) => MoveMeta(
      json['move'] == null
          ? null
          : Move.fromJson(Map<String, dynamic>.from(json['move'] as Map)),
      $enumDecodeNullable(_$PlayerEnumMap, json['player']),
      $enumDecodeNullable(_$ChessPieceTypeEnumMap, json['type']),
    )
      ..took = json['took'] as bool
      ..kingCastle = json['kingCastle'] as bool
      ..queenCastle = json['queenCastle'] as bool
      ..promotion = json['promotion'] as bool
      ..promotionType =
          $enumDecodeNullable(_$ChessPieceTypeEnumMap, json['promotionType'])
      ..isCheck = json['isCheck'] as bool
      ..isCheckmate = json['isCheckmate'] as bool
      ..isStalemate = json['isStalemate'] as bool
      ..rowIsAmbiguous = json['rowIsAmbiguous'] as bool
      ..colIsAmbiguous = json['colIsAmbiguous'] as bool;

Map<String, dynamic> _$MoveMetaToJson(MoveMeta instance) => <String, dynamic>{
      'move': instance.move?.toJson(),
      'player': _$PlayerEnumMap[instance.player],
      'type': _$ChessPieceTypeEnumMap[instance.type],
      'took': instance.took,
      'kingCastle': instance.kingCastle,
      'queenCastle': instance.queenCastle,
      'promotion': instance.promotion,
      'promotionType': _$ChessPieceTypeEnumMap[instance.promotionType],
      'isCheck': instance.isCheck,
      'isCheckmate': instance.isCheckmate,
      'isStalemate': instance.isStalemate,
      'rowIsAmbiguous': instance.rowIsAmbiguous,
      'colIsAmbiguous': instance.colIsAmbiguous,
    };

const _$PlayerEnumMap = {
  Player.player1: 'player1',
  Player.player2: 'player2',
  Player.random: 'random',
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
