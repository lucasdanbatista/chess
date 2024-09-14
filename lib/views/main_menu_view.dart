import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/main_menu_view/game_options.dart';
import 'package:en_passant/views/components/shared/bottom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:en_passant/views/components/main_menu_view/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: appModel.theme.background),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  10,
                  MediaQuery.of(context).padding.top + 10,
                  10,
                  0,
                ),
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 20),
              GameOptions(appModel),
              const SizedBox(height: 10),
              MainMenuButtons(appModel),
              const BottomPadding(),
            ],
          ),
        );
      },
    );
  }
}
