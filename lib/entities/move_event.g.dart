// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveEvent _$MoveEventFromJson(Map json) => MoveEvent(
      player: $enumDecode(_$PlayerEnumMap, json['player']),
      from: (json['from'] as num).toInt(),
      to: (json['to'] as num).toInt(),
    );

Map<String, dynamic> _$MoveEventToJson(MoveEvent instance) => <String, dynamic>{
      'player': _$PlayerEnumMap[instance.player]!,
      'from': instance.from,
      'to': instance.to,
    };

const _$PlayerEnumMap = {
  Player.player1: 'player1',
  Player.player2: 'player2',
  Player.random: 'random',
};
