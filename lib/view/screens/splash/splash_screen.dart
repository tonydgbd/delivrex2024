import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/check_version.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/onboarding_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : _globalKey.currentState?.hideCurrentSnackBar();
        _globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_internet_connection', _globalKey.currentContext!)! : getTranslated('connected', _globalKey.currentContext!)!,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();

   _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initConfig().then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          final config = splashProvider.configModel!;
          double? minimumVersion;

          //
          if(defaultTargetPlatform == TargetPlatform.android  && config.playStoreConfig != null) {
            minimumVersion = config.playStoreConfig!.minVersion;

          }else if(defaultTargetPlatform == TargetPlatform.iOS  &&  config.appStoreConfig != null) {
            minimumVersion = config.appStoreConfig!.minVersion;
          }

          if(config.maintenanceMode!) {
            Navigator.pushNamedAndRemoveUntil(Get.context!, Routes.getMaintainRoute(), (route) => false);

          }else if(Version.parse('$minimumVersion') > Version.parse(AppConstants.appVersion)) {
            Navigator.pushNamedAndRemoveUntil(Get.context!, Routes.getUpdateRoute(), (route) => false);
          }else if (Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
            Navigator.pushNamedAndRemoveUntil(Get.context!, Routes.getMainRoute(), (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(Get.context!, ResponsiveHelper.isMobilePhone()
                && Provider.of<OnBoardingProvider>(Get.context!, listen: false).showOnBoardingStatus
                ? Routes.getLanguageRoute('splash')
                :  Provider.of<BranchProvider>(Get.context!, listen: false).getBranchId() != -1 ? Routes.getMainRoute() : Routes.getBranchListScreen(), (route) => false);
          }

        }

        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResponsiveHelper.isWeb() ? FadeInImage.assetNetwork(
                placeholder: Images.placeholderRectangle, height: 165,
                image: splash.baseUrls != null ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}' : '',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: 165),
              ) : Image.asset(Images.logo, height: 150),
              const SizedBox(height: 30),
              Text(
                ResponsiveHelper.isWeb() ? splash.configModel!.restaurantName! : AppConstants.appName,
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ],
          );
        }),
      ),
    );
  }
}
