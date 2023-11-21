import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';

String? getTranslated(String? key, BuildContext context) {
  String? text = key;
  try{
    text = AppLocalization.of(context)!.translate(key);
  }catch (error){
    debugPrint('error --- $error');
  }
  return text;
}