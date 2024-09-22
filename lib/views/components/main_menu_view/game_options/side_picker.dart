import 'package:en_passant/views/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/cupertino.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final bool showRandom;
  final Player playerSide;
  final Function(Player?) setFunc;

  const SidePicker(
    this.playerSide,
    this.setFunc, {
    super.key,
    required this.showRandom,
  });

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: 'Side',
      options: {
        Player.player1: const Text('White'),
        Player.player2: const Text('Black'),
        if (showRandom) Player.random: const Text('Random'),
      },
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
