import 'package:en_passant/firebase_options.dart';
import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/game/chess_theme.dart';
import 'package:en_passant/views/main_menu_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: const EnPassantApp(),
    ),
  );
  _loadFlameAssets();
}

void _loadFlameAssets() async {
  List<String> pieceImages = [];
  for (var theme in PieceTheme.values) {
    for (var color in ['black', 'white']) {
      for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
        pieceImages.add(
          'pieces/${ChessTheme.formatPieceTheme(theme.name)}/${piece}_$color.png',
        );
      }
    }
  }
  await Flame.images.loadAll(pieceImages);
}

class EnPassantApp extends StatelessWidget {
  const EnPassantApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return const CupertinoApp(
      title: 'Chess',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Jura', fontSize: 16),
          pickerTextStyle: TextStyle(fontFamily: 'Jura'),
        ),
      ),
      home: MainMenuView(),
    );
  }
}
