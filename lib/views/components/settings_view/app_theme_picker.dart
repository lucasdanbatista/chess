import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/game/app_themes.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppThemePicker extends StatelessWidget {
  const AppThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const TextSmall('App Theme'),
          ),
          Container(
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0x20000000),
            ),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: appModel.themeIndex,
              ),
              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                background: Color(0x20000000),
              ),
              itemExtent: 50,
              onSelectedItemChanged: appModel.setTheme,
              children: themeList
                  .map(
                    (theme) => Container(
                      padding: const EdgeInsets.all(10),
                      child: TextRegular(theme.name ?? ''),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
