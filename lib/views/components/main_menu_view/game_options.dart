import 'package:en_passant/game/app_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:en_passant/views/components/main_menu_view/game_options/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/game_mode_picker.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:en_passant/views/components/main_menu_view/game_options/time_limit_picker.dart';

class GameOptions extends StatelessWidget {
  final AppModel appModel;

  const GameOptions(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: [
          GameModePicker(
            appModel.playerCount,
            appModel.setPlayerCount,
          ),
          const SizedBox(height: 20),
          appModel.playerCount == 1
              ? Column(
                  children: [
                    AIDifficultyPicker(
                      appModel.aiDifficulty,
                      appModel.setAIDifficulty,
                    ),
                    const SizedBox(height: 20),
                    SidePicker(
                      appModel.selectedSide,
                      appModel.setPlayerSide,
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              : Container(),
          TimeLimitPicker(
            selectedTime: appModel.timeLimit,
            setTime: appModel.setTimeLimit,
          ),
        ],
      ),
    );
  }
}
