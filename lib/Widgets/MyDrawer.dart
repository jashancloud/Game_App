import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:get/get.dart';

class MyDrawer extends GetView<MainController> {
  const MyDrawer({super.key});

  static const List<String> list=[
    "Daily",
    "Levels",
    "How To Play",
    "Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(itemBuilder: (context,index){
        var text = list[index];
        return InkWell(
          onTap: (){
            if(index == 0){
              if(controller.gameState.value != AppConstants.dailyGame){
                controller.changeGameMode();
              }else{
                Get.back();
              }
            }
            else if(index == 1){
              if(controller.gameState.value != AppConstants.levelGame){
                controller.changeGameMode();
              }else{
                Get.back();
              }
            }
            else if(index == 2){
              Get.back();
              Get.toNamed(AppConstants.tutorialPage);
            }
            else{
              Get.back();
              Get.toNamed(AppConstants.settingPage);
            }

          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(text,style: const TextStyle(fontSize: 18),),
              ],
            ),
          ),
        );
      },itemCount: list.length,),
    );
  }
}
