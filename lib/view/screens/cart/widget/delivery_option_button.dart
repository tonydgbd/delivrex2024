import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String? title;
  final bool kmWiseFee;
  const DeliveryOptionButton({Key? key, required this.value, required this.title, required this.kmWiseFee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value, notify: true),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) => order.setOrderType(value),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(title!, style: rubikRegular),
              const SizedBox(width: 5),

              kmWiseFee ? const SizedBox() : CustomDirectionality(
                child: Text('(${value == 'delivery' ? PriceConverter.convertPrice(Provider.of<SplashProvider>(context, listen: false)
                    .configModel!.deliveryCharge) : getTranslated('free', context)})', style: rubikMedium),
              ),

            ],
          ),
        );
      },
    );
  }
}
