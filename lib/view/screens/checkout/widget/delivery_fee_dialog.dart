import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialog extends StatelessWidget {
  final double? amount;
  final double distance;
  const DeliveryFeeDialog({Key? key, required this.amount, required this.distance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deliveryCharge = distance
        * Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryManagement!.shippingPerKm!;
    if(deliveryCharge < Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryManagement!.minShippingCharge!) {
      deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryManagement!.minShippingCharge!;
    }

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  300 : 0),
      child: Consumer<OrderProvider>(builder: (context, order, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column( mainAxisSize: MainAxisSize.min, children: [

              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delivery_dining,
                  color: Theme.of(context).primaryColor, size: 50,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Column(children: [
                Text(
                  '${getTranslated('delivery_fee_from_your_selected_address_to_branch', context)!}:',
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                CustomDirectionality(child: Text(
                  PriceConverter.convertPrice(deliveryCharge),
                  style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                )),

                const SizedBox(height: 20),

                ItemView(
                  title: getTranslated('subtotal', context)!,
                  subTitle: PriceConverter.convertPrice(amount),
                ),
                const SizedBox(height: 10),

                ItemView(
                  title: getTranslated('delivery_fee', context)!,
                  subTitle:  '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: CustomDivider(),
                ),

                ItemView(
                  title: getTranslated('total_amount', context)!,
                  subTitle:   PriceConverter.convertPrice(amount! + deliveryCharge),
                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
                ),

              ]),
              const SizedBox(height: 30),

              CustomButton(btnTxt: getTranslated('ok', context), onTap: () {
                Navigator.pop(context);
              }),

            ]),
          ),
        );
      }),
    );
  }
}
