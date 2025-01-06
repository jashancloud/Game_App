import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:game_app/Controllers/ThemeController.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:game_app/Widgets/MyDrawer.dart';
import 'package:game_app/Widgets/MyGridView.dart';
import 'package:game_app/Widgets/MyKeyboard.dart';
import 'package:get/get.dart';

class HomePage extends GetView<MainController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          var value = controller.gameState.value;
          var level = controller.level.value;
          String text;
          if (value == AppConstants.dailyGame) {
            text = "Daily";
          } else {
            text = "LEVEL $level";
          }
          return Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          );
        }),
        centerTitle: true,
        actions: [
          Obx((){
            return (controller.gameState.value == AppConstants.dailyGame)
                ? IconButton(
                onPressed: () {
                  Get.toNamed(AppConstants.statisticPage);
                },
                icon: const Icon(Icons.leaderboard_outlined))
                : IconButton(
                onPressed: () {
                  Get.toNamed(AppConstants.levelsPage);
                },
                icon: const Icon(Icons.apps));
          })
        ],
      ),
      body: const GameBody(),
      drawer: const MyDrawer(),
    );
  }
}

class GameBody extends GetView<MainController> {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Obx((){
              var meaning = controller.currentWordMeaning.value;
              var themeMode = themeController.themeMode.value;
              var cellColor = LetterStatus.notInWord.cellColor(themeMode, context);
              var textColor = LetterStatus.notInWord.textColor(themeMode, context);
              return Container(
                constraints: const BoxConstraints(maxWidth: 350,minWidth: 350,minHeight: 50),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: Text("$meaning?",style: TextStyle(fontSize: 16,color: textColor,fontWeight: FontWeight.bold ),textAlign: TextAlign.center,)),
              );
              // return ;
            }),
            const SizedBox(height: 15,),
            const Center(child: MyGridView()),
            const SizedBox(
              height: 3,
            ),
            const Center(child: MyKeyboard())
          ],
        ),
      ),
    );
  }
}
