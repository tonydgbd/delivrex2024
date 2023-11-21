import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  final int status;
  const OrderSuccessfulScreen({Key? key, required this.orderID, required this.status}) : super(key: key);

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  bool _isReload = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if(_isReload && widget.status == 0) {
      Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, null, false);
      _isReload = false;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: SafeArea(
        child: Consumer<OrderProvider>(
            builder: (context, orderProvider, _) {
              double total = 0;
              bool success = true;


              if(orderProvider.trackModel != null && Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointItemPurchasePoint != null) {
                total = ((orderProvider.trackModel!.orderAmount! / 100
                ) * Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointItemPurchasePoint!);
              }

            return orderProvider.isLoading ? const Center(child: CircularProgressIndicator()) :
            orderProvider.trackModel == null ? const NoDataScreen() : SingleChildScrollView(
              child: Column(
                children: [
                 Container(
                   decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                     color: Theme.of(context).cardColor,
                     borderRadius: BorderRadius.circular(10),
                     boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200]!,
                         spreadRadius: 2,blurRadius: 5,offset: const Offset(0, 5))],
                   ) : const BoxDecoration(),
                   child: Padding(
                     padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                     child: Center(
                       child: ConstrainedBox(
                         constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                         child: SizedBox(
                           width: 1170,
                           child: orderProvider.isLoading ? const Center(
                             child: CircularProgressIndicator(),
                           ) :  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                             Container(
                               height: 100, width: 100,
                               decoration: BoxDecoration(
                                 color: Theme.of(context).primaryColor.withOpacity(0.2),
                                 shape: BoxShape.circle,
                               ),
                               child: Icon(
                                 widget.status == 0 ? Icons.check_circle : widget.status == 1 ? Icons.sms_failed : widget.status == 2 ? Icons.question_mark : Icons.cancel,
                                 color: Theme.of(context).primaryColor, size: 80,
                               ),
                             ),
                             const SizedBox(height: Dimensions.paddingSizeLarge),


                             Text(
                               getTranslated(widget.status == 0 ? 'order_placed_successfully' : widget.status == 1 ? 'payment_failed' : widget.status == 2 ? 'order_failed' : 'payment_cancelled', context)!,
                               style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                             ),
                             const SizedBox(height: Dimensions.paddingSizeSmall),

                             if(widget.status == 0) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                               Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                               const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                               Text(widget.orderID!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                             ]),
                             const SizedBox(height: 30),

                             (widget.status == 0 && success && Provider.of<SplashProvider>(context).configModel!.loyaltyPointStatus!  && total.floor() > 0 )  ? Column(children: [

                               Image.asset(
                                 Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                     ? Images.gifBoxDark : Images.gifBox,
                                 width: 150, height: 150,
                               ),

                               Text(getTranslated('congratulations', context)! , style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                               const SizedBox(height: Dimensions.paddingSizeSmall),

                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                 child: Text(
                                   '${getTranslated('you_have_earned', context)!} ${total.floor().toString()} ${getTranslated('points_it_will_add_to', context)!}',
                                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                                   textAlign: TextAlign.center,
                                 ),
                               ),

                             ]) : const SizedBox.shrink() ,
                             const SizedBox(height: Dimensions.paddingSizeDefault),

                             SizedBox(width: ResponsiveHelper.isDesktop(context) ? 400:MediaQuery.of(context).size.width,
                               child: Padding(
                                 padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                 child: CustomButton(btnTxt: getTranslated(
                                   widget.status == 0 && (orderProvider.trackModel!.orderType !='take_away') ? 'track_order' : 'back_home', context,
                                 ), onTap: () {
                                   if(widget.status == 0 && orderProvider.trackModel!.orderType !='take_away') {
                                     Navigator.pushReplacementNamed(context, Routes.getOrderTrackingRoute(int.parse(widget.orderID!)));
                                   }else {
                                     Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                   }
                                 }),
                               ),
                             ),
                           ]),
                         ),
                       ),
                     ),
                   ),
                 ),
                  if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
