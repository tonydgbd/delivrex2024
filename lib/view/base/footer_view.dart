import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/news_letter_controller.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatelessWidget {
  const FooterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController newsLetterController = TextEditingController();
    return Container(
      color: ColorResources.getFooterColor(context),
      width: double.maxFinite,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: Dimensions.webScreenWidth,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge ),
                          FittedBox(
                            child: Text(Provider.of<SplashProvider>(context).configModel!.restaurantName ?? AppConstants.appName, maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.w800,fontSize: 48,color: Theme.of(context).primaryColor),),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(getTranslated('news_letter', context)!, style: robotoRegular.copyWith(fontWeight: FontWeight.w600, color: ColorResources.getGreyBunkerColor(context))),

                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(getTranslated('subscribe_to_our', context)!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getGreyBunkerColor(context))),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                  )
                                ]
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                Expanded(child: TextField(
                                  controller: newsLetterController,
                                  style: rubikMedium.copyWith(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: getTranslated('your_email_address', context),
                                    hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7),fontSize: Dimensions.fontSizeLarge),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,

                                )),
                                InkWell(
                                  onTap: (){
                                    String email = newsLetterController.text.trim().toString();
                                    if (email.isEmpty) {
                                      showCustomSnackBar(getTranslated('enter_email_address', context));
                                    }else if (EmailChecker.isNotValid(email)) {
                                      showCustomSnackBar(getTranslated('enter_valid_email', context));
                                    }else{
                                      Provider.of<NewsLetterProvider>(context, listen: false).addToNewsLetter(email).then((value) {
                                        newsLetterController.clear();
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                    child: Text(getTranslated('subscribe', context)!, style: rubikRegular.copyWith(color: Colors.white,fontSize: Dimensions.fontSizeDefault)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          // const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Consumer<SplashProvider>(
                              builder: (context, splashProvider, child) {
                                final isLtr = Provider.of<LocalizationProvider>(context, listen: false).isLtr;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(splashProvider.configModel!.socialMediaLink!.isNotEmpty)  Text(getTranslated('follow_us_on', context)!, style: rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)),
                                    SizedBox(height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: splashProvider.configModel!.socialMediaLink!.length,
                                        itemBuilder: (BuildContext context, index){
                                          String? name = splashProvider.configModel!.socialMediaLink![index].name;
                                          late String icon;
                                          if(name=='facebook'){

                                            icon = Images.facebookIcon;
                                          }else if(name=='linkedin'){
                                            icon = Images.linkedInIcon;
                                          } else if(name=='youtube'){
                                            icon = Images.youtubeIcon;
                                          }else if(name=='twitter'){
                                            icon = Images.twitterIcon;
                                          }else if(name=='instagram'){
                                            icon = Images.inStaGramIcon;
                                          }else if(name=='pinterest'){
                                            icon = Images.pinterest;
                                          }
                                          return  splashProvider.configModel!.socialMediaLink!.isNotEmpty ?
                                          InkWell(
                                            onTap: (){
                                              _launchURL(splashProvider.configModel!.socialMediaLink![index].link!);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only( left: isLtr && index  == 0 ? 0 : 4, right: !isLtr && index == 0 ? 0 : 4),
                                              child: Image.asset(icon,height: Dimensions.paddingSizeExtraLarge,width: Dimensions.paddingSizeExtraLarge,fit: BoxFit.contain),
                                            ),
                                          ):const SizedBox();

                                        },),
                                    ),
                                  ],
                                );
                              }
                          ),

                        ],
                      )),
                  Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.status! || Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.status!?
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeLarge * 2),
                        Text( Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.status! && Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.status!
                            ? getTranslated('download_our_apps', context)! : getTranslated('download_our_app', context)!, style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeLarge)),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.status!?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel!.playStoreConfig!.link!);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.playStore,height: 50,fit: BoxFit.contain),
                            )):const SizedBox(),
                            Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.status!?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel!.appStoreConfig!.link!);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.appStore,height: 50,fit: BoxFit.contain),
                            )):const SizedBox(),
                          ],)
                      ],
                    ),
                  ) : const SizedBox(),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge * 2),
                      Text(getTranslated('my_account', context)!, style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeExtraLarge)),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getProfileRoute());
                                },
                                child: Text(getTranslated('profile', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getAddressRoute());
                                },
                                child: Text(getTranslated('address', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                                },
                                child: Text(getTranslated('live_chat', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.getDashboardRoute('order'));
                                },
                                child: Text(getTranslated('my_order', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),

                    ],)),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge * 2),
                      Text(getTranslated('quick_links', context)!, style: rubikBold.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeExtraLarge)),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () =>  Navigator.pushNamed(context, Routes.getSupportRoute()),
                                child: Text(getTranslated('contact_us', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                                child: Text(getTranslated('privacy_policy', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                                child: Text(getTranslated('terms_and_condition', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      OnHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                                child: Text(getTranslated('about_us', context)!, style: hovered? rubikMedium.copyWith(color: Theme.of(context).primaryColor) : rubikRegular.copyWith(color: ColorResources.getGreyBunkerColor(context),fontSize: Dimensions.fontSizeDefault)));
                          }
                      ),

                    ],)),
                ],
              ),
            ),
            const Divider(thickness: .5),
            SizedBox(
              width: 500.0,
              child: Text(Provider.of<SplashProvider>(context,listen: false).configModel!.footerCopyright ??
                  '${getTranslated('copyright', context)} ${Provider.of<SplashProvider>(context,listen: false).configModel!.restaurantName}',
                  overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.center),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault)
          ],
        ),
      ),
    );
  }
}
_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}