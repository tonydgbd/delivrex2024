import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('help_and_support', context))) as PreferredSizeWidget?,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Container(
                      width: width > 700 ? 700 : width,
                      padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                      decoration: width > 700 ? BoxDecoration(
                        color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Align(alignment: Alignment.center, child: Image.asset(Images.support,height: 300,width: 300,)),
                        const SizedBox(height: 20),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                          Text(getTranslated('restaurant_address', context)!, style: rubikMedium),
                        ]),
                        const SizedBox(height: 10),

                        Text(
                          Provider.of<SplashProvider>(context, listen: false).configModel!.restaurantAddress!,
                          style: rubikRegular, textAlign: TextAlign.center,
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 50),

                        Padding(
                          padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.all(Dimensions.paddingSizeLarge) : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            Expanded(child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                                minimumSize: const Size(1, 50),
                              ),
                              onPressed: () {
                                launchUrl(Uri.parse('tel:${Provider.of<SplashProvider>(context, listen: false).configModel!.restaurantPhone}'));
                              },
                              child: Text(getTranslated('call_now', context)!, style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeLarge,
                              )),
                            )),
                            const SizedBox(width: 10),
                            Expanded(child: SizedBox(
                              height: 50,
                              child: CustomButton(
                                btnTxt: getTranslated('send_a_message', context),
                                onTap: () async {
                                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                                },
                              ),
                            )),
                          ]),
                        ),

                      ]),
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) const FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
