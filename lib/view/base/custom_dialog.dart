import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/styles.dart';

import '../../utill/dimensions.dart';


class CustomDialog extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? description;
  final Function? onTapTrue;
  final Function? onTapFalse;
  final String? buttonTextTrue;
  final String? buttonTextFalse;
  const CustomDialog({
    Key? key,
    this.icon,
    this.title,
    this.description,
    this.buttonTextTrue,
    this.buttonTextFalse,
    this.onTapFalse,
    this.onTapTrue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(icon, size: 50),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(title!, style: rubikRegular, textAlign: TextAlign.center),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(description!, style: rubikRegular, textAlign: TextAlign.center),
          ),

          Container(height: 0.5, color: Theme.of(context).hintColor),

          Row(children: [

            Expanded(child: InkWell(
              onTap: onTapTrue as void Function()?,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(buttonTextTrue!, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
              ),
            )),

            Expanded(child: InkWell(
              onTap: onTapFalse as void Function()?,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(buttonTextFalse!, style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),

          ])
        ]),),
    );
  }
}
void openDialog(Widget child, {bool isDismissible = true, bool isDialog = false, bool willPop = true}) {
  ResponsiveHelper.isMobile() && isDialog ?
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    isScrollControlled: true,
    builder: (BuildContext context) => WillPopScope(child: child, onWillPop: ()async=> willPop),
    context: Get.context!,
  ) :
  showAnimatedDialog(
    Get.context!,
    Dialog(
      backgroundColor: Colors.transparent,
      child:   WillPopScope(child: child, onWillPop: ()async=> willPop),
    ),
    dismissible: isDismissible,
  );
}

void showAnimatedDialog(BuildContext context, Widget dialog, {
  bool isFlip = false, bool dismissible = true, Duration? duration,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: duration ?? const Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if(isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(CurvedAnimation(parent: a1, curve: const Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: a1, curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      }else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  })  : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}