import 'package:flutter/material.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;

  const TitleWidget({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!, style: rubikMedium),
      onTap != null && !ResponsiveHelper.isDesktop(context)? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            getTranslated('view_all', context)!,
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
