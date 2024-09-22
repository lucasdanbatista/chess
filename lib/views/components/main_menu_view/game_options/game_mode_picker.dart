import 'package:en_passant/views/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/cupertino.dart';

class GameModePicker extends StatelessWidget {
  final Map<int, Text> playerCountOptions = const <int, Text>{
    1: Text('One Player'),
    2: Text('Two Player'),
    3: Text('Online'),
  };

  final int playerCount;
  final Function(int?) setFunc;

  const GameModePicker(this.playerCount, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Game Mode',
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
