import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class ChangeMethodDialog extends StatelessWidget {
  final String orderID;
  final Function callback;
  const ChangeMethodDialog({Key? key, required this.orderID, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Image.asset(Images.wallet, color: Theme.of(context).primaryColor, width: 100, height: 100),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  getTranslated('do_you_want_to_switch', context)!, textAlign: TextAlign.justify,
                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                !order.isLoading ? Row(children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(1, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                      ),
                      child: Text(getTranslated('no', context)!),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: CustomButton(btnTxt: getTranslated('yes', context), onTap: () async {
                    await order.updatePaymentMethod(orderID, callback);
                    Navigator.pop(Get.context!);
                  })),
                ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

              ]),
            ),
          ),
        );
      },
    );
  }
}
