import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:game_app/Controllers/ThemeController.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<ThemeController> {
  const SettingPage({super.key});

  static const themes=<String>[
    "System",
    "Light",
    "Dark",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          )
      ),
      body: Column(
        children: [
          Obx((){
            var value = controller.themeMode.value;
            return ListTile(
              onTap: ()async{
                await showModalBottomSheet(context: context, builder: (context)=>const MyBottomSheet(themes: themes),constraints: const BoxConstraints(maxWidth: 400),shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ));
              },
              title: const Text("Theme Mode",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: Text(
                  (value == ThemeMode.system)
                      ? "System"
                      : (value == ThemeMode.light)
                          ? "Light"
                          : "Dark"
                  ,style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            );
          })
        ],
      ),
    );
  }
}

class MyBottomSheet extends GetView<ThemeController> {
  final List<String> themes;
  const MyBottomSheet({super.key,required this.themes});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text("Theme Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ListView.builder(
            shrinkWrap: true,
            itemCount: themes.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index){
              return Obx((){
                var selectedTheme = controller.themeMode.value;
                return ListTile(
                    onTap: (){
                      var theme = themes[index];
                      if(theme == "System"){
                        controller.changeTheme(mode: ThemeMode.system);
                      }else if(theme == "Light"){
                        controller.changeTheme(mode: ThemeMode.light);
                      }else{
                        controller.changeTheme(mode: ThemeMode.dark);
                      }
                      Get.back();
                    },
                    title: Text(themes[index]),
                    trailing: (selectedTheme == ThemeMode.system && index == 0)
                        ? const Icon(Icons.check)
                        : (selectedTheme == ThemeMode.light  && index == 1)
                        ? const Icon(Icons.check)
                        : (selectedTheme == ThemeMode.dark  && index == 2)
                        ? const Icon(Icons.check)
                        : const SizedBox()
                );
              });
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

