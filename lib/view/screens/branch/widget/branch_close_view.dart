import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class BranchCloseView extends StatelessWidget {
  const BranchCloseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,children: [
      Image.asset(Images.branchClose),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Text(
        getTranslated('all_our_branches', context)!,
        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
      )


    ],);
  }
}