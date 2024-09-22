import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_event.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class MoveEvent {
  final Player player;
  final int from;
  final int to;

  MoveEvent({
    required this.player,
    required this.from,
    required this.to,
  });

  factory MoveEvent.fromJson(Map json) => _$MoveEventFromJson(json);

  Map<String, dynamic> toJson() => _$MoveEventToJson(this);
}
