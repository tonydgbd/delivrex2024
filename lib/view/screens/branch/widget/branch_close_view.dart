import 'package:flutter/material.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/images.dart';
import 'package:delivrex/utill/styles.dart';

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