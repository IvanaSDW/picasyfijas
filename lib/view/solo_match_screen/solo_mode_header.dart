import 'package:flutter/cupertino.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/stop_watch_widget/stop_watch_widget_view.dart';

class SoloMatchHeader extends StatelessWidget {
  const SoloMatchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/instructions_header.png"),
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(flex:65,
            child: Text("TIME TRIAL MODE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Mainframe',
                color: originalColors.reverseTextColor,
              ),
            ),
          ),
          Expanded(flex: 35,
              child: StopWatchWidget()
          ),
        ],
      ),
    );
  }
}