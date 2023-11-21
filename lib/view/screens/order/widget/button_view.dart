import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:provider/provider.dart';


class ButtonView extends StatelessWidget {
  const ButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<OrderProvider>(builder: (context, order, _) {
        return Column(children: [
          !order.showCancelled ? Center(
            child: SizedBox(
              width: width > 700 ? 700 : width,
              child: Row(children: [
                order.trackModel!.orderStatus == 'pending' ? Expanded(child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context, barrierDismissible: false,
                        builder: (context) => OrderCancelDialog(
                          orderID: order.trackModel!.id.toString(),
                          callback: (String message, bool isSuccess, String orderID) {
                            if (isSuccess) {
                              showCustomSnackBar('$message. Order ID: $orderID', isError: false);
                            } else {
                              showCustomSnackBar(message, isError: false);
                            }
                          },
                        ),
                      );
                    },

                    child: Text(
                      getTranslated('cancel_order', context)!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                )) : const SizedBox(),


              ]),
            ),
          ) : Center(
            child: Container(
              width: width > 700 ? 700 : width,
              height: 50,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getTranslated('order_cancelled', context)!,
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ),

          (order.trackModel!.orderStatus == 'confirmed'
              || order.trackModel!.orderStatus == 'processing'
              || order.trackModel!.orderStatus == 'out_for_delivery')
              && order.trackModel?.orderType != 'dine_in'
              ?
          Center(
            child: Container(
              width: width > 700 ? 700 : width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButton(
                btnTxt: getTranslated('track_order', context),
                onTap: () {
                  Navigator.pushNamed(context, Routes.getOrderTrackingRoute(order.trackModel!.id));
                },
              ),
            ),
          ) : const SizedBox(),

          order.trackModel!.orderStatus == 'delivered' && order.trackModel!.orderType != 'pos' ? Center(
            child: Container(
              width: width > 700 ? 700 : width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButton(
                btnTxt: getTranslated('review', context),
                onTap: () {
                  List<OrderDetailsModel> orderDetailsList = [];
                  List<int?> orderIdList = [];
                  for (var orderDetails in order.orderDetails!) {
                    if(!orderIdList.contains(orderDetails.productDetails!.id)) {
                      orderDetailsList.add(orderDetails);
                      orderIdList.add(orderDetails.productDetails!.id);
                    }
                  }
                  Navigator.pushNamed(context, Routes.getRateReviewRoute(), arguments: RateReviewScreen(
                    orderDetailsList: orderDetailsList,
                    deliveryMan: order.trackModel!.deliveryMan,
                  ));
                },
              ),
            ),
          ) : const SizedBox(),

          if(order.trackModel!.deliveryMan != null && (order.trackModel!.orderStatus != 'delivered'))
            Center(
              child: Container(
                width: width > 700 ? 700 : width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButton(btnTxt: getTranslated('chat_with_delivery_man', context), onTap: (){
                  Navigator.pushNamed(context, Routes.getChatRoute(orderModel: order.trackModel));
                }),
              ),
            ),
        ],);
      }
    );
  }
}
