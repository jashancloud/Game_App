import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:get/get.dart';


class MyKeyboard extends GetView<MainController> {
  const MyKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var letter in AppConstants.keyboardList.$1)
                KeyboardKey(letter: letter, letterStatus: LetterStatus.unknown,)
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var letter in AppConstants.keyboardList.$2)
                KeyboardKey(letter: letter, letterStatus: LetterStatus.unknown,)
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const EnterKey(),
              for (var letter in AppConstants.keyboardList.$3)
                KeyboardKey(letter: letter, letterStatus: LetterStatus.unknown,),
              const DeleteKey()
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

class EnterKey extends GetView<MainController> {
  const EnterKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      var themeMode = controller.themeMode.value;
      return Padding(
        padding: const EdgeInsets.only(right: 3),
        child: SizedBox(
          height: 58,
          width: AppConstants.customWidth(context) * 1.65,
          child: Material(
            color: LetterStatus.unknown.cellColor(themeMode,context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: InkWell(
              onTap: () {
                controller.pressEnter();
              },
              child:   Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: FittedBox(
                  child: Icon(
                    Icons.send,
                    color: LetterStatus.unknown.textColor(themeMode,context),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DeleteKey extends GetView<MainController> {
  const DeleteKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      var themeMode = controller.themeMode.value;
      return Padding(
        padding: const EdgeInsets.only(right: 3),
        child: SizedBox(
          height: 58,
          width: AppConstants.customWidth(context) * 1.65,
          child: Material(
            color: LetterStatus.unknown.cellColor(themeMode,context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: InkWell(
              onTap: () {
                controller.pressDelete();
              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: FittedBox(
                  child: Icon(
                    Icons.backspace_outlined,
                    color: LetterStatus.unknown.textColor(themeMode,context),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class KeyboardKey extends GetView<MainController> {
  const KeyboardKey({
    required this.letter,
    required this.letterStatus,
    super.key,
  });

  final String letter;
  final LetterStatus letterStatus;

  @override
  Widget build(BuildContext context) {
   return Obx((){
     var themeMode = controller.themeMode.value;
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 3),
       child: SizedBox(
         height: 58,
         width: AppConstants.customWidth(context),
         child: Material(
           color: LetterStatus.unknown.cellColor(themeMode,context),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
           child: InkWell(
             onTap: () {
               controller.enterWordInGame(letter);
             },
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
               child: FittedBox(
                 child: Text(
                   letter.toUpperCase(),
                   style: TextStyle(color: letterStatus.textColor(themeMode,context)),
                 ),
               ),
             ),
           ),
         ),
       ),
     );
   });
  }
}
