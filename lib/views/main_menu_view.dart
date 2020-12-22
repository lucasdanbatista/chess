import 'package:en_passant/settings/game_settings.dart';
import 'package:en_passant/views/components/main_menu/piece_color_picker.dart';
import 'package:en_passant/views/components/main_menu/player_count_picker.dart';
import 'package:en_passant/views/components/main_menu/ai_difficulty_picker.dart';
import 'package:en_passant/views/components/main_menu/time_limit_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'components/main_menu/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettings>(
      builder: (context, gameSettings, child) => Container(
        decoration: BoxDecoration(
          gradient: gameSettings.theme.background
        ),
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).padding.top, 10, 0
              ),
              child: Image(image: AssetImage('assets/images/logo.png')),
            ),
            SizedBox(height: 30),
            PlayerCountPicker(
              gameSettings.playerCount,
              gameSettings.setPlayerCount
            ),
            SizedBox(height: 30),
              gameSettings.playerCount == 1
                ? Column(children: [
                    AIDifficultyPicker(
                      gameSettings.aiDifficulty,
                      gameSettings.setAIDifficulty
                    ),
                    SizedBox(height: 30),
                    PieceColorPicker(
                      gameSettings.playerSide,
                      gameSettings.setPlayerSize
                    )
                  ])
                : TimeLimitPicker(setTime: gameSettings.setTimeLimit),
            Spacer(),
            MainMenuButtons(),
            SizedBox(
              height: Platform.isAndroid ?
                MediaQuery.of(context).viewInsets.bottom : 0
            )
          ],
        ),
      )
    );
  }
}
