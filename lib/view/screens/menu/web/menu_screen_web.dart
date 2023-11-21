import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_item_web.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/menu_model.dart';
import '../../../../provider/auth_provider.dart';
import '../../../base/custom_dialog.dart';

class MenuScreenWeb extends StatelessWidget {
  const MenuScreenWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final splashProvider =  Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    final List<MenuModel> menuList = [
      MenuModel(icon: Images.order, title: getTranslated('my_order', context), route:  Routes.getDashboardRoute('order')),
      MenuModel(icon: Images.profile, title: getTranslated('profile', context), route: Routes.getProfileRoute()),
      MenuModel(icon: Images.location, title: getTranslated('address', context), route: Routes.getAddressRoute()),
      MenuModel(icon: Images.message, title: getTranslated('message', context), route: Routes.getChatRoute(orderModel: null)),
      MenuModel(icon: Images.coupon, title: getTranslated('coupon', context), route: Routes.getCouponRoute()),
      MenuModel(icon: Images.notification, title: getTranslated('notification', context), route: Routes.getNotificationRoute()),
      if(splashProvider.configModel!.referEarnStatus!)
        MenuModel(icon: Images.referralIcon, title: getTranslated('refer_and_earn', context), route: Routes.getReferAndEarnRoute()),
      if(splashProvider.configModel!.walletStatus!)
        MenuModel(icon: Images.wallet, title: getTranslated('wallet', context), route: Routes.getWalletRoute(true)),
      if(splashProvider.configModel!.loyaltyPointStatus!)
        MenuModel(icon: Images.loyaltyIcon, title: getTranslated('loyalty_point', context), route: Routes.getWalletRoute(false)),

      MenuModel(icon: Images.helpSupport, title: getTranslated('help_and_support', context), route: Routes.getSupportRoute()),
      MenuModel(icon: Images.privacyPolicy, title: getTranslated('privacy_policy', context), route: Routes.getPolicyRoute()),
      MenuModel(icon: Images.termsAndCondition, title: getTranslated('terms_and_condition', context), route:Routes.getTermsRoute()),

      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.refundPage != null
          && splashProvider.policyModel!.refundPage!.status!
      ) MenuModel(icon: Images.refundPolicy, title: getTranslated('refund_policy', context), route: Routes.getRefundPolicyRoute()),

      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.returnPage != null
          && splashProvider.policyModel!.returnPage!.status!
      ) MenuModel(icon: Images.returnPolicy, title: getTranslated('return_policy', context), route: Routes.getReturnPolicyRoute()),

      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.cancellationPage != null
          && splashProvider.policyModel!.cancellationPage!.status!
      ) MenuModel(icon: Images.cancellationPolicy, title: getTranslated('cancellation_policy', context), route: Routes.getCancellationPolicyRoute()),

      MenuModel(icon: Images.aboutUs, title: getTranslated('about_us', context), route: Routes.getAboutUsRoute()),

      MenuModel(
        icon: Images.version,
        title: "${getTranslated('version', context)} ${Provider.of<SplashProvider>(context, listen: false).configModel!.softwareVersion ?? ''}",
        route: 'version',
      ),

      MenuModel(icon: Images.login, title: getTranslated(isLoggedIn ? 'logout' : 'login', context), route: 'auth'),

    ];

    return SingleChildScrollView(
      child: Column(children: [
          Center(child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            return SizedBox(width: 1170, child: Stack(children: [

              Column(children: [
                Container(
                  height: 150,  color:  ColorResources.getProfileMenuHeaderColor(context),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 240.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!isLoggedIn) const SizedBox(height: 80),

                      isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                        '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ) : const SizedBox(height: Dimensions.paddingSizeDefault, width: 150) : Text(
                        getTranslated('guest', context)!,
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      if(isLoggedIn && profileProvider.userInfoModel != null) Text(
                        profileProvider.userInfoModel!.email ?? '',
                        style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),


                      isLoggedIn && splashProvider.configModel!.loyaltyPointStatus! &&  profileProvider.userInfoModel != null ? Text(
                        '${getTranslated('loyalty_point', context)}: ${profileProvider.userInfoModel!.point ?? ''}',
                        style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                      )  : const SizedBox(),

                      const SizedBox(height: Dimensions.paddingSizeSmall),


                    ],
                  ),

                ),

                const SizedBox(height: 100),

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
                    mainAxisSpacing: Dimensions.paddingSizeExtraLarge,
                  ),
                  itemCount: menuList.length,
                  itemBuilder: (context, index) => MenuItemWeb(menu: menuList[index]),
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),

              ],),


              Positioned(left: 30, top: 45, child: Builder(builder: (context) {
                return Container(
                  height: 180, width: 180,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: const Offset(0, 8.8) )]),
                  child: ClipOval(
                    child: isLoggedIn ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholderUser, height: 170, width: 170, fit: BoxFit.cover,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                      // imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderUser, height: 170, width: 170, fit: BoxFit.cover),
                    ) : Image.asset(Images.placeholderUser, height: 170, width: 170, fit: BoxFit.cover),
                  ),
                );
              }),),

              Positioned(right: 0, top: 140, child: isLoggedIn ? Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: InkWell(
                  onTap: (){
                    showAnimatedDialog(context, Consumer<AuthProvider>(builder: (context, authProvider, _) {
                      return authProvider.isLoading ? const Center(child: CircularProgressIndicator()) : CustomDialog(
                        icon: Icons.question_mark_sharp,
                        title: getTranslated('are_you_sure_to_delete_account', context),
                        description: getTranslated('it_will_remove_your_all_information', context),
                        buttonTextTrue: getTranslated('yes', context),
                        buttonTextFalse: getTranslated('no', context),
                        onTapTrue: () => Provider.of<AuthProvider>(context, listen: false).deleteUser(),
                        onTapFalse: () => Navigator.of(context).pop(),
                      );
                    }),
                    dismissible: false,
                    isFlip: true,
                  );},
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: 16),
                    ),

                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text(getTranslated('delete_account', context)!),
                    ),
                  ],),
                ),
              ) : const SizedBox(),),
            ],),
            );
          }),
          ),

          const FooterView(),
        ],
      ),
    );
  }
}
