import 'package:flutter/material.dart';
import 'package:delivrex/helper/responsive_helper.dart';
import 'package:delivrex/localization/language_constrants.dart';
import 'package:delivrex/utill/color_resources.dart';
import 'package:delivrex/utill/dimensions.dart';
import 'package:delivrex/utill/images.dart';
import 'package:delivrex/utill/routes.dart';
import 'package:delivrex/view/base/custom_button.dart';
import 'package:delivrex/view/base/web_app_bar.dart';

class ThanksFeedbackScreen extends StatelessWidget {
  const ThanksFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: Center(
        child: SizedBox(
          width: 1170,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.doneWithFullBackground,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 60),
                Text(
                  getTranslated('thanks_for_your_order', context)!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                ),
                const SizedBox(height: 23),
                Text(
                  getTranslated('it_will_helps_to_improve', context)!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: ColorResources.getGreyBunkerColor(context).withOpacity(.75),
                      ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  btnTxt: getTranslated('back_home', context),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
