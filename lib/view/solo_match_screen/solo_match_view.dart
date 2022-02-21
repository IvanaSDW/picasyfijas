import 'package:blinking_text/blinking_text.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/guest_avatar.dart';
import 'package:bulls_n_cows_reloaded/view/solo_match_screen/solo_mode_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/constants.dart';
import '../../shared/text_styles.dart';
import '../../shared/widgets/congrats_message.dart';
import '../../shared/widgets/continue_button.dart';
import '../../shared/widgets/guess_display.dart';
import '../../shared/widgets/intercom_box/intercom_box_view.dart';
import '../../shared/widgets/numeric_keyboard/numeric_keyboard_logic.dart';
import '../../shared/widgets/numeric_keyboard/numeric_keyboard_view.dart';
import '../../shared/widgets/system_status_widget.dart';
import 'solo_match_logic.dart';

class SoloMatchPage extends StatelessWidget {
  final logic = Get.put(SoloMatchLogic());
  final NumericKeyboardLogic keyboardLogic = Get.put(NumericKeyboardLogic());

  SoloMatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => logic.onBackPressed(),
      child: Material(
        color: Colors.black,
        child: SizedBox(
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 8, // Header
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 17,
                        child: Hero(
                            tag: 'avatar',
                            child: GuestAvatar()
                        )
                    ),
                    Expanded(flex: 83,
                        child: Center(child: SoloMatchHeader())
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Expanded(flex: 51, //Playing body
                child: Container(
                  padding: const EdgeInsets.all(6),
                  width: Get.width * 0.7,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 0.5,
                    ),
                  ),
                  child: ListView.builder(
                    controller: logic.scrollController,
                    itemCount: logic.match.moves.length,
                    itemBuilder: (context, index) {
                      WidgetsBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        if (logic.needsScrollToLast) {
                          logic.scrollToLastItem();
                        }
                      });
                      var thisItem = logic.match.moves[index];
                      var lastIndex = logic.match.moves.length - 1;
                      if (index != lastIndex) {
                        return NormalGuessDisplay(
                          index: index,
                          textHeight: logic.textHeight,
                          item: thisItem,
                        );
                      } else {
                        return logic.numberFound
                            ? CorrectGuessDisplay(
                          index: index,
                          textHeight: logic.textHeight,
                          item: thisItem,
                        )
                            : PendingGuessDisplay(
                          index: index,
                          textHeight: logic.textHeight,
                          item: thisItem,
                          keyboard: keyboardLogic,
                        );
                      }
                    },
                  ),
                ),
              ),
              const Spacer(flex: 1,),
              Expanded(flex: 26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 1,),
                    Expanded(flex: 40, //Intercom box
                      child: IntercomBoxPage(textHeight: logic.textHeight),
                    ),
                    const Spacer(flex: 1),
                    Expanded(flex: 59, //Keyboard area
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: logic.matchState ==
                            TtmMatchState.created
                            ? InkWell(
                          onTap: () => logic.startSinglePlayerMatch(),
                          child: Center(
                              child: BlinkText(
                                'Tap here to start...',
                                style: defaultTextStyle,
                              )),
                        )
                            : logic.matchState ==
                            TtmMatchState.finished
                            ? Column(
                          children: [
                            Expanded(
                              flex: 65,
                              child: Center(
                                child: CongratsMessage(
                                    totalTime: logic.timer.convertToDisplayTime(logic
                                        .match.moves.last
                                        .timeStampMillis
                                    ),
                                    totalMoves: logic.match.moves.length
                                ),
                              ),
                            ),
                            Expanded(flex: 35,
                                child: Center(
                                    child: ContinueButton(
                                      onTapAction: () => logic.onContinuePressed(),
                                    )
                                )
                            ),
                          ],
                        )
                            : const NumericKeyboardWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 13,
                child: Hero(
                    tag: 'system_status',
                    child: SystemStatusView()
                ),
              ) //
            ],
          )),
        ),
      ),
    );
  }
}
