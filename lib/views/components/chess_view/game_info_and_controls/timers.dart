import 'package:en_passant/game/app_model.dart';
import 'package:en_passant/views/components/chess_view/game_info_and_controls/timer_widget.dart';
import 'package:flutter/material.dart';

class Timers extends StatelessWidget {
  final AppModel appModel;

  const Timers(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return appModel.timeLimit != 0
        ? Column(
            children: [
              Row(
                children: [
                  TimerWidget(
                    timeLeft: appModel.player1TimeLeft,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  TimerWidget(
                    timeLeft: appModel.player2TimeLeft,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          )
        : Container();
  }
}
