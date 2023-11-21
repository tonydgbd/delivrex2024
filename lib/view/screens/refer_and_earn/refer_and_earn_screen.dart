import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/refer_and_earn/widget/refer_hint_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String> shareItem = ['messenger', 'whatsapp', 'gmail', 'viber', 'share' ];
  final List<String?> hintList = [
    getTranslated('invite_your_friends', Get.context!),
    '${getTranslated('they_register', Get.context!)} ${AppConstants.appName} ${getTranslated('with_special_offer', Get.context!)}',
    getTranslated('you_made_your_earning', Get.context!),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('refer_and_earn', context))) as PreferredSizeWidget?,

      body: _isLoggedIn ? configModel.referEarnStatus! ? Center(child: ExpandableBottomSheet(
        background: SingleChildScrollView(
          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: Column(
            children: [
              SizedBox(
                width: ResponsiveHelper.isDesktop(context) ?  750 : double.maxFinite,
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    return profileProvider.userInfoModel != null ? Column(
                      children: [
                        Image.asset(Images.referBanner, height: size.height * 0.3),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        Text(
                          getTranslated('invite_friend_and_businesses', context)!,
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.fontSizeOverLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall,),

                        Text(
                          getTranslated('copy_your_code', context)!,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        Text(
                          getTranslated('your_personal_code', context)!,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge,),

                        DottedBorder(
                          padding: const EdgeInsets.all(4),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          dashPattern: const [5, 5],
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          strokeWidth: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  child: Text(profileProvider.userInfoModel!.referCode ?? '',
                                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ),

                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {

                                    if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode  != ''){
                                      Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                                      showCustomSnackBar(getTranslated('referral_code_copied', context), isError: false);
                                    }
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(getTranslated('copy', context)!,style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withOpacity(0.9),
                                    )),
                                  ),
                                ),

                              ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

                        Text(
                          getTranslated('or_share', context)!,
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: shareItem.map((item) => InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Share.share(profileProvider.userInfoModel!.referCode!, subject: profileProvider.userInfoModel!.referCode!),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Image.asset(
                                  Images.getShareIcon(item), height: 50, width: 50,
                                ),
                              ),
                            )).toList(),),
                        ),

                        if(ResponsiveHelper.isDesktop(context))
                         Column(children: [
                           const SizedBox(height: Dimensions.paddingSizeDefault),
                           ReferHintView(hintList: hintList),
                           const SizedBox(height: Dimensions.paddingSizeDefault),
                         ]),


                      ],
                    ) : const SizedBox();
                  }
                ),
              ),

              if(ResponsiveHelper.isDesktop(context)) const FooterView(),
            ],
          ),
        ),
        persistentContentHeight: MediaQuery.of(context).size.height * 0.2,
        expandableContent: ResponsiveHelper.isDesktop(context) ? const SizedBox() : ReferHintView(hintList: hintList),
      )) : const NoDataScreen() : const NotLoggedInScreen(),
    );
  }
}
