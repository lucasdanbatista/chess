import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/settings_view/piece_preview.dart';
import 'package:en_passant/views/components/shared/text_variable.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PieceThemePicker extends StatelessWidget {
  const PieceThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const TextSmall('Piece Theme'),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 120,
              decoration: const BoxDecoration(color: Color(0x20000000)),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: appModel.pieceThemeIndex,
                      ),
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        background: Color(0x20000000),
                      ),
                      itemExtent: 50,
                      onSelectedItemChanged: appModel.setPieceTheme,
                      children: appModel.pieceThemes
                          .map(
                            (theme) => Container(
                              padding: const EdgeInsets.all(10),
                              child: TextRegular(theme),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    width: 80,
                    child: GameWidget(
                      game: PiecePreview(appModel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
