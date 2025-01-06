import 'package:flutter/material.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:game_app/Controllers/ThemeController.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:get/get.dart';

class MyGridView extends GetView<MainController> {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Obx((){
        var gridItems = controller.gridItems;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            var item = gridItems[index];
            return MyGridTile(letter: item,);
          },
          itemCount: gridItems.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      })
    );
  }
}

class MyGridTile extends GetView<ThemeController> {
  final LetterInfo? letter;
  const MyGridTile({super.key,required this.letter});

  @override
  Widget build(BuildContext context) {
   return Obx((){
     var themeMode = controller.themeMode.value;
     return Container(
       constraints:
       const BoxConstraints(maxHeight: 60, maxWidth: 60),
       decoration: BoxDecoration(
         color: (letter != null) ? letter!.status.cellColor(themeMode,context) : LetterStatus.unknown.cellColor(themeMode,context),
         borderRadius: BorderRadius.circular(12),
       ),
       child: Padding(
         padding: const EdgeInsets.all(12),
         child: FittedBox(
           child: (letter != null) ? Text(
             letter!.letter.toUpperCase(),
             style: TextStyle(fontWeight: FontWeight.w800,color: letter!.status.textColor(themeMode,context)),
           ) : const Text(
             "",
           ) ,
         ),
       ),
     );
   });
  }
}

