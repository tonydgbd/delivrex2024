import 'package:flutter/material.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/main.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/styles.dart';

void showCustomSnackBar(String? message, {bool isError = true, bool isToast = false}) {
  final width = MediaQuery.of(Get.context!).size.width;
  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    content: Text(message!, style: rubikRegular.copyWith(
      color: Colors.white,
    )),
    margin: ResponsiveHelper.isDesktop(Get.context!)
        ?  EdgeInsets.only(right: width * 0.7, bottom: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall)
        : EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.green,
  ));

}