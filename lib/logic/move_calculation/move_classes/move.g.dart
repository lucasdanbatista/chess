// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Move _$MoveFromJson(Map json) => Move(
      (json['from'] as num).toInt(),
      (json['to'] as num).toInt(),
      promotionType:
          $enumDecodeNullable(_$ChessPieceTypeEnumMap, json['promotionType']) ??
              ChessPieceType.promotion,
    );

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'promotionType': _$ChessPieceTypeEnumMap[instance.promotionType]!,
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
