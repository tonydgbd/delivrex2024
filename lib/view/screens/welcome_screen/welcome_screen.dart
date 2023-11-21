import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [
          const SizedBox(height: 50),

          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(30),
            child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
              builder:(context, splash, child) => FadeInImage.assetNetwork(
                placeholder: Images.placeholderRectangle,
                image: splash.baseUrls != null ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}' : '',
                height: 200,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: 200),
              ),
            ) : Image.asset(Images.logo, height: 200),
          ),
          const SizedBox(height: 30),

          Text(
            getTranslated('welcome', context)!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 32),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text(
              '${getTranslated('welcome_to', context)!} ${AppConstants.appName
              }, ${getTranslated('please_login_or', context)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CustomButton(
              btnTxt: getTranslated('login', context),
              onTap: () =>Navigator.pushReplacementNamed(context, Routes.getLoginRoute()),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeDefault,
                top: 12),
            child: CustomButton(
              btnTxt: getTranslated('signup', context),
              onTap: () =>Navigator.pushReplacementNamed(context, Routes.getSignUpRoute()),
              backgroundColor: Colors.black,
            ),
          ),

          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(1, 40),
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.getMainRoute()),
            child: RichText(text: TextSpan(children: [
              TextSpan(text: '${getTranslated('login_as_a', context)} ', style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7))),
              TextSpan(text: getTranslated('guest', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ])),
          ),
        ],
        ),
        )),
      ),
    );
  }
}
