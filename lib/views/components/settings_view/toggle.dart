import 'package:flutter/cupertino.dart';

import 'package:en_passant/views/components/shared/text_variable.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool? toggle;
  final Function(bool)? setFunc;

  const Toggle(this.label, {super.key, this.toggle, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          TextRegular(label),
          const Spacer(),
          CupertinoSwitch(
            value: toggle ?? false,
            onChanged: setFunc,
          ),
        ],
      ),
    );
  }
}
