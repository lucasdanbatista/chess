import 'package:flutter/cupertino.dart';

import 'package:en_passant/views/components/main_menu_view/game_options/picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final Map<Player, Text> colorOptions = const <Player, Text>{
    Player.player1: Text('White'),
    Player.player2: Text('Black'),
    Player.random: Text('Random'),
  };

  final Player playerSide;
  final Function(Player?) setFunc;

  const SidePicker(this.playerSide, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
