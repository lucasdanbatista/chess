import 'package:flutter/material.dart';

class AppTheme {
  String? name;
  LinearGradient? background;
  Color lightTile;
  Color darkTile;
  Color moveHint;
  Color checkHint;
  Color latestMove;
  Color border;

  AppTheme({
    this.name,
    this.background,
    this.lightTile = const Color(0xFFC9B28F),
    this.darkTile = const Color(0xFF69493b),
    this.moveHint = const Color(0xdd5c81c4),
    this.latestMove = const Color(0xccc47937),
    this.checkHint = const Color(0x88ff0000),
    this.border = const Color(0xffffffff),
  });
}

List<AppTheme> get themeList {
  var themeList = <AppTheme>[
    AppTheme(
      name: 'Bismuth',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff2560a5),
          Color(0xff2f6e72),
          Color(0xff4faa55),
          Color(0xffe6de50),
          Color(0xffdb70eb),
        ],
      ),
      lightTile: const Color(0xff4faa55),
      darkTile: const Color(0xff2560a5),
      moveHint: const Color(0xaaffff00),
      latestMove: const Color(0xaadb70eb),
      border: const Color(0xff184387),
    ),
    AppTheme(
      name: 'Candy',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff8934eb),
          Color(0xff004f80),
        ],
      ),
      lightTile: const Color(0xff0088ff),
      darkTile: const Color(0xff8934eb),
      moveHint: const Color(0xdddb70eb),
      checkHint: const Color(0x88ff0000),
      latestMove: const Color(0xcc2dba6f),
      border: const Color(0xffdb70eb),
    ),
    AppTheme(
      name: 'Blue',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff236e91),
          Color(0xff0f4964),
        ],
      ),
    ),
    AppTheme(
      name: 'Green',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff25804f),
          Color(0xff00584f),
        ],
      ),
    ),
    AppTheme(
      name: 'Red',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xfff54242),
          Color(0xff912323),
        ],
      ),
    ),
    AppTheme(
      name: 'Iridescent',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb2b2b2),
          Color(0xffb24d00),
          Color(0xffb2004d),
          Color(0xff004db2),
          Color(0xff4d4d4d),
        ],
      ),
      lightTile: const Color(0xffabc0d1),
      darkTile: const Color(0xff7991a6),
      moveHint: const Color(0xcc004db2),
      border: const Color(0xff4d5d6b),
    ),
    AppTheme(
      name: 'Black & White',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb2b2b2),
          Color(0xff4e4e4e),
        ],
      ),
      lightTile: const Color(0xffb2b2b2),
      darkTile: const Color(0xff808080),
      moveHint: const Color(0xdd555555),
      checkHint: const Color(0xff333333),
      latestMove: const Color(0xdddddddd),
    ),
    AppTheme(
      name: 'Opal',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb5b8c9),
          Color(0xffc7958a),
          Color(0xffdbd879),
          Color(0xff96cf8a),
          Color(0xff6a81df),
          Color(0xff507fc2),
        ],
      ),
      lightTile: const Color(0xffd1d7e0),
      darkTile: const Color(0xff6494d6),
      moveHint: const Color(0xcc8ad979),
      latestMove: const Color(0xddc7958a),
      border: const Color(0xff9cc5d9),
    ),
    AppTheme(
      name: 'Regal',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff2c0078),
          Color(0xff6d3ac7),
        ],
      ),
      lightTile: const Color(0xfff0c76e),
      darkTile: const Color(0xff942222),
      moveHint: const Color(0xcc5d27ba),
      checkHint: const Color(0xffff0000),
      border: const Color(0xff6b0707),
    ),
    AppTheme(
      name: 'Vaporwave',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffff78ed),
          Color(0xff602af5),
        ],
      ),
      lightTile: const Color(0xffff78ed),
      darkTile: const Color(0xff602af5),
      moveHint: const Color(0xddd1116b),
      checkHint: const Color(0x80ff0000),
      latestMove: const Color(0xaa00d0d4),
      border: const Color(0xff926bff),
    ),
    AppTheme(
      name: 'Dark',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff1e1e1e),
          Color(0xff2e2e2e),
        ],
      ),
      border: const Color(0xff888888),
    ),
    AppTheme(
      name: 'Light',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffaeaeae),
          Color(0xff8e8e8e),
        ],
      ),
    ),
    AppTheme(
      name: 'E2-E4',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xfff9f1c2),
          Color(0xff530b0e),
        ],
      ),
      lightTile: const Color(0xffd4cb97),
      darkTile: const Color(0xff73181c),
      checkHint: const Color(0xffff0000),
      moveHint: const Color(0xdd666666),
    ),
    AppTheme(
      name: 'Gold Ore',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff595959),
          Color(0xff807126),
        ],
      ),
      lightTile: const Color(0xfff0d656),
      darkTile: const Color(0xff807126),
      moveHint: const Color(0xdd444444),
      border: const Color(0xff5c563c),
    ),
    AppTheme(
      name: 'Aquamarine',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff03e8fc),
          Color(0xff0345fc),
        ],
      ),
      lightTile: const Color(0xff03e8fc),
      darkTile: const Color(0xff0345fc),
      moveHint: const Color(0xdd2aad46),
      latestMove: const Color(0xdd0683d6),
      border: const Color(0xffc2e3ff),
    ),
    AppTheme(
      name: 'Video Chess',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff382db5),
          Color(0xff382db5),
        ],
      ),
      lightTile: const Color(0xff584fdb),
      darkTile: const Color(0xff382db5),
      moveHint: const Color(0x88c4c6ff),
      latestMove: const Color(0x88c47937),
    ),
    AppTheme(
      name: 'AMOLED',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff000000),
          Color(0xff000000),
        ],
      ),
      lightTile: const Color(0xff444444),
      darkTile: const Color(0xff333333),
      border: const Color(0xff555555),
    ),
    AppTheme(
      name: 'Lewis',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff423428),
          Color(0xff423428),
        ],
      ),
      lightTile: const Color(0xffdbd1c1),
      darkTile: const Color(0xffab3848),
      moveHint: const Color(0xdd800b0b),
      latestMove: const Color(0xddcc9c6c),
      border: const Color(0xffbdaa8c),
    ),
    AppTheme(
      name: 'Neon',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffb734eb),
          Color(0xff34d3eb),
          Color(0xff34eb62),
        ],
      ),
      lightTile: const Color(0xff34d3eb),
      darkTile: const Color(0xffb734eb),
      moveHint: const Color(0xdd34eb62),
      latestMove: const Color(0xddd9eb34),
    ),
    AppTheme(
      name: 'Pink Marble',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff45a881),
          Color(0xff2782b0),
        ],
      ),
      lightTile: const Color(0xffebc0c0),
      darkTile: const Color(0xff472d22),
      moveHint: const Color(0xaa45a881),
      latestMove: const Color(0xaa2782b0),
      border: const Color(0xffebc0c0),
    ),
    AppTheme(
      name: 'Cherry-Coloured Funk',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff434783),
          Color(0xffdc3b39),
        ],
      ),
      lightTile: const Color(0xffdb5e5c),
      darkTile: const Color(0xff645183),
      moveHint: const Color(0xaabdacce),
      latestMove: const Color(0xaaf0b35d),
      border: const Color(0xff434783),
    ),
  ];
  themeList.sort((a, b) => a.name?.compareTo(b.name ?? '') ?? 0);
  return themeList;
}
