import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/map_widget.dart';
import 'package:provider/provider.dart';

import 'change_method_dialog.dart';
import 'product_type_view.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('${getTranslated('order_id', context)}:', style: rubikRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(order.trackModel!.id.toString(), style: rubikMedium),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    const Expanded(child: SizedBox()),

                    const Icon(Icons.watch_later, size: 17),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    order.trackModel!.deliveryTime != null ? Text(
                      DateConverter.deliveryDateAndTimeToDate(order.trackModel!.deliveryDate!, order.trackModel!.deliveryTime!, context),
                      style: rubikRegular,
                    ) : Text(
                      DateConverter.isoStringToLocalDateOnly(order.trackModel!.createdAt!),
                      style: rubikRegular,
                    ),

                  ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Text('${getTranslated('item', context)}:', style: rubikRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(order.orderDetails!.length.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                const Expanded(child: SizedBox()),

                order.trackModel!.orderType == 'delivery' ? TextButton.icon(
                  onPressed: () {
                    if(order.trackModel!.deliveryAddress != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MapWidget(address: order.trackModel!.deliveryAddress)));
                    }
                    else{
                      showCustomSnackBar(getTranslated('address_not_found', context));
                    }
                  },
                  icon: const Icon(Icons.map, size: 18),
                  label: Text(getTranslated('delivery_address', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(width: 1)),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      minimumSize: const Size(1, 30)
                  ),
                ) : order.trackModel!.orderType == 'pos'
                    ? Text(getTranslated('pos_order', context)!, style: poppinsRegular) :
                order.trackModel!.orderType == 'dine_in' ? Text(getTranslated('dine_in', context)!, style: poppinsRegular) :
                Text(getTranslated('${order.trackModel!.orderType}', context)!, style: rubikMedium),

              ]),
              const Divider(height: 20),

              // Payment info
              Align(
                alignment: Alignment.center,
                child: Text(
                  getTranslated('payment_info', context)!,
                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
              ),
              const SizedBox(height: 10),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('status', context)!, style: rubikRegular)),

                Expanded(flex: 8, child: Text(
                  getTranslated(order.trackModel!.paymentStatus, context)!,
                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                )),
              ]),
              const SizedBox(height: 5),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('method', context)!, style: rubikRegular)),

                Expanded(flex: 8, child: Row(children: [
                  Text(
                    (order.trackModel!.paymentMethod != null && order.trackModel!.paymentMethod!.isNotEmpty)
                        ? '${order.trackModel!.paymentMethod![0].toUpperCase()}${order.trackModel!.paymentMethod!.substring(1).replaceAll('_', ' ')}'
                        : getTranslated('digital_payment', context)!,
                    style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor),
                  ),

                  (order.trackModel!.paymentStatus != 'paid' && order.trackModel!.paymentMethod != 'cash_on_delivery'
                      && order.trackModel!.orderStatus != 'delivered') ? InkWell(
                    onTap: () {
                      if(Provider.of<SplashProvider>(context, listen: false).configModel!.cashOnDelivery != 'true'){
                        showCustomSnackBar(getTranslated('cash_on_delivery_is_not_activated', context), isError: true);
                      }else{
                        showDialog(context: context, barrierDismissible: false, builder: (context) => ChangeMethodDialog(
                            orderID: order.trackModel!.id.toString(),
                            // fromOrder: widget.orderModel !=null,
                            callback: (String message, bool isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(milliseconds: 600), backgroundColor: isSuccess ? Colors.green : Colors.red));
                            }),);
                      }

                    }, child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    child: Text(getTranslated('change', context)!, style: rubikRegular.copyWith(fontSize: 10, color: Colors.black)),
                  ),
                  ) : const SizedBox(),
                ])),
              ]),
              const Divider(height: 40),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.orderDetails!.length,
                itemBuilder: (context, index) {
                  List<AddOns> addOns = [];
                  List<AddOns>? addons = order.orderDetails![index].productDetails  == null
                      ? [] : order.orderDetails![index].productDetails!.addOns;

                  for (var id in order.orderDetails![index].addOnIds!) {
                    for (var addOn in addons!) {
                      if (addOn.id == id) {
                        addOns.add(addOn);
                      }
                    }

                  }

                  String variationText = '';
                  if(order.orderDetails![index].variations != null && order.orderDetails![index].variations!.isNotEmpty) {
                    for(Variation variation in order.orderDetails![index].variations!) {
                      variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                      for(VariationValue value in variation.variationValues!) {
                        variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level} - ${value.optionPrice}';
                      }
                      variationText += ')';
                    }
                  }else if(order.orderDetails![index].oldVariations != null && order.orderDetails![index].oldVariations!.isNotEmpty) {
                    variationText = order.orderDetails![index].oldVariations![0].type ?? '';
                  }


                  return order.orderDetails![index].productDetails != null ?
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                              '${order.orderDetails![index].productDetails!.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.orderDetails![index].productDetails!.name!,
                                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text('${getTranslated('quantity', context)}:', style: rubikRegular),
                              Text(order.orderDetails![index].quantity.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Row(children: [
                                CustomDirectionality(child: Text(
                                  PriceConverter.convertPrice( order.orderDetails![index].price! - order.orderDetails![index].discountOnProduct!),
                                  style: rubikBold,
                                )),
                                const SizedBox(width: 5),

                                order.orderDetails![index].discountOnProduct! > 0 ? Expanded(
                                  child: CustomDirectionality(child: Text(
                                    PriceConverter.convertPrice(order.orderDetails![index].price),
                                    style: rubikBold.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).hintColor.withOpacity(0.7),
                                    ),
                                  )),
                                ) : const SizedBox(),
                              ])),

                              Flexible(child: ProductTypeView(productType: order.orderDetails![index].productDetails!.productType,)),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          variationText != '' ? Row(children: [
                              Container(height: 10, width: 10, decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              )),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Flexible(
                              child: CustomDirectionality(
                                child: Text(variationText,
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall,),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ]):const SizedBox(),
                        ]),
                      ),
                    ]),

                    addOns.isNotEmpty ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        itemCount: addOns.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: Row(children: [
                              Text(addOns[i].name!, style: rubikRegular),
                              const SizedBox(width: 2),

                              CustomDirectionality(child: Text(PriceConverter.convertPrice(addOns[i].price), style: rubikMedium)),
                              const SizedBox(width: 2),

                              Text('(${order.orderDetails![index].addOnQtys![i]})', style: rubikRegular),
                            ]),
                          );
                        },
                      ),
                    )
                        : const SizedBox(),

                    const Divider(height: 40),
                  ]) : const SizedBox.shrink();
                },
              ),

              (order.trackModel!.orderNote != null && order.trackModel!.orderNote!.isNotEmpty) ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Theme.of(context).hintColor.withOpacity(0.7)),
                ),
                child: Text(order.trackModel!.orderNote!, style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7))),
              ) : const SizedBox(),



            ],
          );
        }
    );
  }
}
