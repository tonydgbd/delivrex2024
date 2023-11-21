import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveTopBar;
  final String? title;
  final Widget? child;
  final double height;
  const CustomStepper({Key? key, required this.title, required this.isActive, this.child, this.haveTopBar = true, this.height = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      haveTopBar ? Row(children: [
        Container(
          height: height,
          width: 2,
          margin: const EdgeInsets.only(left: 14),
          color: isActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.7),
        ),
        child == null ? const SizedBox() : child!,
      ]) : const SizedBox(),

      Row(children: [
        isActive ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 30) : Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.7), width: 2), shape: BoxShape.circle),
        ),
        SizedBox(width: isActive ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
        Text(title!, style: isActive ? rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)
            : rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      ]),

    ]);
  }
}
