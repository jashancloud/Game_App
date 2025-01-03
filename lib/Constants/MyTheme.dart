import 'package:flutter/material.dart';
import 'package:game_app/Constants/MyColors.dart';

class MyTheme {

  static Brightness systemTheme(BuildContext context){
    return MediaQuery.of(context).platformBrightness;
  }

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white
    ),
    useMaterial3: true
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
  );

  static Color correctColor() {
    return AppColors.green;
  }

  static Color wrongSpotColor() {
    return AppColors.yellow;
  }

  static Color notInWordColor(ThemeMode mode,BuildContext context) {

    if(mode == ThemeMode.system){
      return MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.tertiary : AppColors.grey;
    }
    return mode == ThemeMode.dark ? AppColors.tertiary : AppColors.grey;
  }

  static Color unknownColor(ThemeMode mode,BuildContext context){

    if(mode == ThemeMode.system){
      return MediaQuery.of(context).platformBrightness == Brightness.dark ? AppColors.grey : AppColors.tertiary;
    }
    return  mode == ThemeMode.dark ? AppColors.grey : AppColors.tertiary;
  }

}
