import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CookiesView extends StatelessWidget {
  const CookiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width  = MediaQuery.of(context).size.width;
    double padding = (width - Dimensions.webScreenWidth) / 2;
    return Consumer<SplashProvider>(
      builder: (context, splashProvide, _) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault),
              )),

             padding: EdgeInsets.symmetric(
               vertical: Dimensions.paddingSizeDefault,
               horizontal: ResponsiveHelper.isDesktop(context) ? padding : Dimensions.paddingSizeSmall,
             ),

              child: SizedBox(width: Dimensions.webScreenWidth, child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text(
                          getTranslated('your_privacy_matters', context)!,
                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.white),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(splashProvide.configModel!.cookiesManagement!.content ?? "",
                          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white70),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(80,40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: ()=>  splashProvide.cookiesStatusChange(null),
                          child:  Text(getTranslated('no_thanks', context)!, style: poppinsRegular.copyWith(
                          color: Colors.white70, fontSize: Dimensions.fontSizeSmall)),
                        ),
                        SizedBox(width: ResponsiveHelper.isDesktop(context)?Dimensions.paddingSizeExtraLarge:Dimensions.paddingSizeLarge,),


                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(80, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: (){
                            splashProvide.cookiesStatusChange(splashProvide.configModel!.cookiesManagement!.content);
                          },
                          child:  Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Center(child: Text(getTranslated('yes_accept', context)!, style: poppinsRegular.copyWith(
                                color: Colors.white70,fontSize: Dimensions.fontSizeSmall,
                              )),
                            )),
                        ),

                      ]),


                    ],
                  )),
            ),
          ),
        );
      }
    );
  }
}