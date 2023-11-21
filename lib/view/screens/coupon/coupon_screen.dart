import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}
late bool _isLoggedIn;
class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
    }
  }
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : CustomAppBar(context: context, title: getTranslated('coupon', context))) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return coupon.couponList != null ? coupon.couponList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                        child: Container(
                          padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeLarge) : EdgeInsets.zero,
                          child: Container(
                            width: width > 700 ? 700 : width,
                            padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                            decoration: width > 700 ? BoxDecoration(
                              color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                            ) : null,
                            child: ListView.builder(
                              itemCount: coupon.couponList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                  child: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: coupon.couponList![index].code ?? ''));
                                      showCustomSnackBar(getTranslated('coupon_code_copied', context), isError:  false);
                                    },
                                    child: Stack(children: [

                                      Image.asset(Images.couponBg, height: 100, width: 1170, fit: BoxFit.fitWidth, color: Theme.of(context).primaryColor),

                                      Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: Row(children: [

                                          const SizedBox(width: 50),
                                          Image.asset(Images.percentage, height: 50, width: 50),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                                            child: Image.asset(Images.line, height: 100, width: 5),
                                          ),

                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                              SelectableText(
                                                coupon.couponList![index].code!,
                                                style: rubikRegular.copyWith(color: Colors.white),
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                              Text(
                                                '${coupon.couponList![index].discount}${coupon.couponList![index].discountType == 'percent' ? '%'
                                                    : Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} off',
                                                style: rubikMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraLarge),
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                              Text(
                                                '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList![index].expireDate!)}',
                                                style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                              ),
                                            ]),
                                          ),

                                            ]),
                                          ),

                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context))  const FooterView()
                  ],
                ),
              ),
            ),
          ) : const NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : const NotLoggedInScreen(),
    );
  }
}
