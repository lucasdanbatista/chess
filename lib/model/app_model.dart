import 'dart:math';

import 'package:en_passant/logic/move_calculation/move_classes/move_meta.dart';
import 'package:en_passant/logic/shared_functions.dart';
import 'package:en_passant/views/components/main_menu_view/side_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

class AppModel extends ChangeNotifier {
  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  Duration timeLimit = Duration.zero;
  String themeName = 'Green';
  AppTheme get theme { return AppThemes.themeList[themeIndex]; }
  bool showMoveHistory = true;
  bool soundEnabled = true;

  bool gameOver = false;
  Player turn = Player.player1;
  List<MoveMeta> moveMetaList = [];
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;

  int get themeIndex {
    var themeIndex = 0;
    AppThemes.themeList.asMap().forEach((index, theme) {
      if (theme.name == themeName) {
        themeIndex = index;
      }
    });
    return themeIndex;
  }

  Player get aiTurn { return oppositePlayer(playerSide); }

  bool get isAIsTurn { return playingWithAI && (turn == aiTurn); }

  bool get playingWithAI { return playerCount == 1; }

  AppModel() { loadSharedPrefs(); }

  void addMoveMeta(MoveMeta meta) {
    moveMetaList.add(meta);
    notifyListeners();
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void changeTurn() {
    turn = oppositePlayer(turn);
    notifyListeners();
  }

  void resetGame() {
    gameOver = false;
    turn = Player.player1;
    moveMetaList = [];
    player1TimeLeft = timeLimit;
    player2TimeLeft = timeLimit;
    if (selectedSide == Player.random) {
      playerSide = Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
  }

  void setPlayerCount(int count) {
    playerCount = count;
    notifyListeners();
  }

  void setAIDifficulty(int difficulty) {
    aiDifficulty = difficulty;
    notifyListeners();
  }

  void setPlayerSide(Player side) {
    selectedSide = side;
    if (side != Player.random) {
      playerSide = side;
    }
    notifyListeners();
  }

  void setTimeLimit(Duration duration) {
    timeLimit = duration;
    player1TimeLeft = duration;
    player2TimeLeft = duration;
    notifyListeners();
  }

  void decrementPlayer1Timer() async {
    if (player1TimeLeft.inSeconds > 0 && !gameOver) {
      player1TimeLeft = Duration(milliseconds: player1TimeLeft.inMilliseconds - 50);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() async {
    if (player2TimeLeft.inSeconds > 0 && !gameOver) {
      player2TimeLeft = Duration(milliseconds: player2TimeLeft.inMilliseconds - 50);
      notifyListeners();
    }
  }

  void setTheme(int index) async {
    themeName = AppThemes.themeList[index].name;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeName', themeName);
    notifyListeners();
  }

  void setShowMoveHistory(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    showMoveHistory = show;
    prefs.setBool('showMoveHistory', show);
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled = enabled;
    prefs.setBool('soundEnabled', enabled);
    notifyListeners();
  }

  void loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString('themeName') ?? 'Green';
    showMoveHistory = prefs.getBool('showMoveHistory') ?? true;
    soundEnabled = prefs.getBool('soundEnabled') ?? true;
    notifyListeners();
  }
}