import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_app/Bindings/AppBindings.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Constants/MyTheme.dart';
import 'package:game_app/Repositories/MainRepository.dart';
import 'package:game_app/Repositories/SharedPrefRepository.dart';
import 'package:game_app/Screens/HomePage.dart';
import 'package:game_app/Screens/LevelsPage.dart';
import 'package:game_app/Screens/SettingPage.dart';
import 'package:game_app/Screens/StatisticPage.dart';
import 'package:game_app/Screens/Tutorial.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:io';

void callBackDispatcher(){
  Workmanager().executeTask((task,inputData)async{
    if (task == AppConstants.setBackgroundTask) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      // Next midnight
      final durationUntilMidnight = midnight.difference(now);
      if (durationUntilMidnight.inMinutes < 5) {
        // Perform the task only if it's within 15 minutes of midnight
        await SharedPrefRepository.instance.init();
        await SharedPrefRepository.instance.clearBoard(mode: AppConstants.dailyGame);
        print("SharedPreferences cleared at approximately 12 AM");
        Workmanager().registerOneOffTask("1", AppConstants.setBackgroundTask, initialDelay: const Duration(days: 1, minutes: -5));
      } else {
        print("Task skipped, not close enough to 12 AM");
      } return Future.value(true);
    } else {
      print("Task failed"); return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SharedPrefRepository.instance.init();
  await MainRepository.instance.initDictionary();
  var theme = SharedPrefRepository.instance.getTheme();

  if(Platform.isAndroid || Platform.isIOS){
    var backgroundSharedPrefTask = SharedPrefRepository.instance.getBackgroundSharedPrefTask();
    if(backgroundSharedPrefTask == null){
      Workmanager().initialize(callBackDispatcher, isInDebugMode: true);
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      var durationUntilMidnight = midnight.difference(now);
      Workmanager().registerOneOffTask("1", AppConstants.setBackgroundTask,initialDelay: durationUntilMidnight - const Duration(minutes: 5));
      unawaited(SharedPrefRepository.instance.setBackgroundSharedPrefTask(value: true));
    }
  }

  var bool = SharedPrefRepository.instance.isFirstEnter();
  if (bool) {
    unawaited(SharedPrefRepository.instance.setFirstEnter());
  }

  runApp(MyApp(
    isFirstEnter: bool,
    theme: theme,
  ));
}

class MyApp extends StatelessWidget {
  final bool isFirstEnter;
  final String? theme;
  const MyApp({super.key, required this.isFirstEnter, required this.theme});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;

    if (theme != null) {
      if (theme == AppConstants.lightTheme) {
        themeMode = ThemeMode.light;
      } else if (theme == AppConstants.darkTheme) {
        themeMode = ThemeMode.dark;
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      darkTheme: MyTheme.darkTheme,
      theme: MyTheme.lightTheme,
      themeMode: themeMode,
      initialRoute:
          (isFirstEnter) ? AppConstants.tutorialPage : AppConstants.homePage,
      initialBinding: AppBindings(),
      getPages: [
        GetPage(name: AppConstants.homePage, page: () => const HomePage()),
        GetPage(name: AppConstants.tutorialPage, page: () => const Tutorial()),
        GetPage(name: AppConstants.levelsPage, page: () => const LevelsPage()),
        GetPage(
            name: AppConstants.statisticPage,
            page: () => const StatisticPage()),
        GetPage(
            name: AppConstants.settingPage, page: () => const SettingPage()),
      ],
    );
  }
}
