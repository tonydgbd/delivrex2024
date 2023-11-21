import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../order_details_screen.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderItem;
  final bool isRunning;
  final OrderProvider orderProvider;
  const OrderItem({Key? key, required this.orderProvider, required this.isRunning, required this.orderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          color: Theme.of(context).shadowColor,
          spreadRadius: 1, blurRadius: 5,
        )],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [

        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              Images.placeholderImage,
              height: 70, width: 80, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(orderItem.id.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(child: orderItem.orderType == 'take_away' || orderItem.orderType == 'dine_in' ? Text(
                  '(${getTranslated(orderItem.orderType, context)})',
                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                ) : const SizedBox()),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(
                '${orderItem.detailsCount} ${getTranslated(orderItem.detailsCount! > 1 ? 'items' : 'item', context)}',
                style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7)),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 15),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('${getTranslated('${orderItem.orderStatus}', context)}', style: rubikRegular.copyWith(color: Theme.of(context).primaryColor)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        SizedBox(
          height: 50,
          child: Row(children: [
            Expanded(child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
                ),
                minimumSize: const Size(1, 50),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.getOrderDetailsRoute(orderItem.id),
                  arguments: OrderDetailsScreen(orderModel: orderItem, orderId: orderItem.id),
                );
              },
              child: Text(getTranslated('details', context)!, style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).disabledColor,
                fontSize: Dimensions.fontSizeLarge,
              )),
            )),
            const SizedBox(width: 20),

            Expanded(child:
            orderItem.orderType != 'pos' && orderItem.orderType != 'dine_in' && orderItem.orderType != 'take_away' ?
            CustomButton(
              btnTxt: getTranslated(isRunning ? 'track_order' : 'reorder', context),
              onTap: () async {
                if(isRunning) {
                  Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderItem.id));
                }
                else {
                  List<OrderDetailsModel> orderDetails = (await orderProvider.getOrderDetails(orderItem.id.toString()))!;
                  List<CartModel> cartList = [];
                  List<bool> availableList = [];
                  for (var orderDetail in orderDetails) {
                    List<AddOn> addOnList = [];
                    List<List<bool?>> selectedVariations = [];



                    for(int i = 0; i < orderDetail.addOnIds!.length; i++) {
                      addOnList.add(AddOn(id: orderDetail.addOnIds![i], quantity: orderDetail.addOnQtys![i]));
                    }

                    if(orderDetail.productDetails != null && orderDetail.productDetails!.id != null) {
                      Product? product = await bannerProvider.getProductDetails('${orderDetail.productDetails!.id}');
                      if(product != null && product.variations != null && orderDetail.variations != null ) {

                        for(int j = 0; j < product.variations!.length; j++){
                          selectedVariations.add([]);

                          for(int index = 0; index < product.variations![j].variationValues!.length; index ++){
                            for(int i= 0; i < orderDetail.variations![j].variationValues!.length; i++){
                              selectedVariations[j].add(
                                  product.variations![j].variationValues![index].level == orderDetail.variations![j].variationValues![i].level
                              );
                            }
                          }
                        }

                        cartList.add(CartModel(
                          orderDetail.price, PriceConverter.convertWithDiscount( orderDetail.price, orderDetail.discountOnProduct, 'amount'),
                          product.variations ?? [], orderDetail.discountOnProduct, orderDetail.quantity,
                          orderDetail.taxAmount, addOnList, orderDetail.productDetails,
                          selectedVariations,
                        ));


                      }

                    }






                  }

                  if(availableList.contains(false)) {
                    showCustomSnackBar(getTranslated('one_or_more_product_unavailable', Get.context!));
                  }else {

                    if(orderItem.isProductAvailable!) {
                      Navigator.pushNamed(
                        Get.context!,
                        Routes.getCheckoutRoute(
                          orderItem.orderAmount, 'reorder',
                          orderItem.orderType,orderItem.couponDiscountTitle ?? '',
                        ),
                        arguments: CheckoutScreen(
                          cartList: cartList,
                          fromCart: false,
                          amount: orderItem.orderAmount,
                          orderType: orderItem.orderType,
                          couponCode: orderItem.couponDiscountTitle ?? '',
                        ),
                      );
                    }else{
                      showCustomSnackBar(getTranslated('one_or_more_product_unavailable', Get.context!));

                    }
                  }
                }

              },
            ) : const SizedBox.shrink()),
          ]),
        ),

      ]),
    );
  }
}