import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_screen_web.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  const MenuScreen({Key? key,  this.onTap}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
bool _isLoggedIn = false;

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context,listen: false).getUserInfo(false, isUpdate: false);
    }
  }
  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: ResponsiveHelper.isDesktop(context) ? const MenuScreenWeb() : Column(children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Center(
            child: Container(
              width: 1170,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: ClipOval(
                    child: _isLoggedIn ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover,
                      image: '${Provider.of<SplashProvider>(context,).baseUrls!.customerImageUrl}/'
                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover),
                    ) : Image.asset(Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover),
                  ),
                ),
                Column(children: [
                  const SizedBox(height: 20),
                  _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                    '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white),
                  ) : Container(height: 15, width: 150, color: Colors.white) : Text(
                    getTranslated('guest', context)!,
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white),
                  ),
                  const SizedBox(height: 10),


                  if(_isLoggedIn && profileProvider.userInfoModel != null)  Text(
                    profileProvider.userInfoModel!.email ?? '',
                    style: rubikRegular.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  _isLoggedIn && splashProvider.configModel!.loyaltyPointStatus! && profileProvider.userInfoModel != null ? Text(
                    '${getTranslated('loyalty_point', context)}: ${profileProvider.userInfoModel?.point?.toInt() ?? ''}',
                    style: rubikRegular.copyWith(color: Colors.white),
                  ) : const SizedBox(),

                ]),
              ]),
            ),
          ),
        ),
        Expanded(child: OptionsView(onTap: widget.onTap)),
      ]),
    );
  }
}
