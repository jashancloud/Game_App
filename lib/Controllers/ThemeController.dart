import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constants/AppConstants.dart';
import '../Repositories/SharedPrefRepository.dart';


class ThemeController extends GetxController{
  var sharedPrefRepository = SharedPrefRepository.instance;
  var themeMode=ThemeMode.system.obs;

  @override
  void onInit() {
    getTheme();
    super.onInit();
  }

  void changeTheme({required ThemeMode mode}){
    try{
      if(mode == ThemeMode.light){
        sharedPrefRepository.setTheme(theme: AppConstants.lightTheme);
      }else if(mode == ThemeMode.dark){
        sharedPrefRepository.setTheme(theme: AppConstants.darkTheme);
      }else{
        unawaited(sharedPrefRepository.removeTheme());
      }
      Get.changeThemeMode(mode);
      themeMode.value=mode;
    }catch(e){
      print("Error in ChangeTheme : $e");
      AppConstants.showSnackBar(message: "Error ChangeTheme");
    }
  }

  void getTheme(){
    var theme = sharedPrefRepository.getTheme();
    if(theme != null){
      if(theme == AppConstants.lightTheme){
        themeMode.value=ThemeMode.light;
      }else if(theme == AppConstants.darkTheme){
        themeMode.value=ThemeMode.dark;
      }
    }
  }
}