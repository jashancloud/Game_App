import 'package:flutter/material.dart';
import 'package:game_app/Constants/MyColors.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:game_app/Controllers/ThemeController.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:get/get.dart';

class LetterTile extends GetView<ThemeController> {
  const LetterTile({

    this.selected = false,
    this.onTap,
    this.color,
    super.key, required this.letter,
  });

  final LetterInfo letter;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Obx((){
          var mode = controller.themeMode.value;
          return Container(
            constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
            decoration: BoxDecoration(
              color: letter.status.cellColor(mode,context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FittedBox(
                child: Text(
                  letter.letter,
                  style: TextStyle(color: letter.status.textColor(mode,context), fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}