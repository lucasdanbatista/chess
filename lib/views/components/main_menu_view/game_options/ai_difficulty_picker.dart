import 'package:flutter/cupertino.dart';

import 'package:en_passant/views/components/main_menu_view/game_options/picker.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Text> difficultyOptions = {
    1: const Text('1'),
    2: const Text('2'),
    3: const Text('3'),
    4: const Text('4'),
    5: const Text('5'),
    6: const Text('6'),
  };

  final int aiDifficulty;
  final Function(int?) setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'AI Difficulty',
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}
