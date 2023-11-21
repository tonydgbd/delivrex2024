import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/home/widget/marque_text.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const CartProductWidget({Key? key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Variation>? variationList;
    if(cart?.product!.branchProduct != null && cart!.product!.branchProduct!.isAvailable!) {
      variationList = cart?.product!.branchProduct!.variations;
    }else{
      variationList = cart!.product!.variations;
    }

    String variationText = '';
    if(variationList != null && cart!.variations!.isNotEmpty) {
      for(int index=0; index<cart!.variations!.length; index++) {
        if(cart!.variations![index].contains(true)) {
          variationText += '${variationText.isNotEmpty ? ', ' : ''}${cart!.product!.variations![index].name} (';
          for(int i=0; i<cart!.variations![index].length; i++) {
            if(cart!.variations![index][i]!) {
              variationText += '${variationText.endsWith('(') ? '' : ', '}${variationList[index].variationValues![i].level} - ${
                  PriceConverter.convertPrice(variationList[index].variationValues![i].optionPrice)
              }';
            }
          }
          variationText += ')';
        }
      }
    }
    return InkWell(
      onTap: () {
        ResponsiveHelper.isMobile()? showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => CartBottomSheet(
            product: cart!.product,
            cartIndex: cartIndex,
            cart: cart,
            fromCart: true,
            callback: (CartModel cartModel) {
              showCustomSnackBar(getTranslated('updated_in_cart', context), isError: false);
            },
          ),
        ) :
        showDialog(context: context, builder: (con) => Dialog(
          backgroundColor: Colors.transparent,
          child: CartBottomSheet(
            product: cart!.product,
            cartIndex: cartIndex,
            cart: cart,
            fromCart: true,
            callback: (CartModel cartModel) {
              showCustomSnackBar(getTranslated('updated_in_cart', context), isError: false);
            },
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          const Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 5, spreadRadius: 1,
                )],
              ),
              child: Column(
                children: [

                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholderImage, height: 70, width: 85, fit: BoxFit.cover,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart!.product!.image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 70, width: 85, fit: BoxFit.cover),
                          ),
                        ),
                        isAvailable ? const SizedBox() : Positioned(
                          top: 0, left: 0, bottom: 0, right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                            child: Text(getTranslated('not_available_now_break', context)!, textAlign: TextAlign.center, style: rubikRegular.copyWith(
                              color: Colors.white, fontSize: 8,
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(cart!.product!.name!, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    RatingBar(rating: cart!.product!.rating!.isNotEmpty ? double.parse(cart!.product!.rating![0].average!) : 0.0, size: 12),
                    const SizedBox(height: 5),
                    Row(children: [
                      Flexible(child: CustomDirectionality(child: Text(
                        PriceConverter.convertPrice(cart!.discountedPrice),
                        style: rubikBold,
                      ))),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      cart!.discountAmount! > 0 ? Flexible(
                        child: CustomDirectionality(
                          child: Text(PriceConverter.convertPrice((cart!.product!.price!)), style: rubikBold.copyWith(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            fontSize: Dimensions.fontSizeSmall,
                            decoration: TextDecoration.lineThrough,
                          )),
                        ),
                      ) : const SizedBox(),

                    ]),

                    cart!.product!.variations!.isNotEmpty ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: Row(mainAxisSize: MainAxisSize.min,children: [
                        Flexible(child: MarqueeWidget(
                          backDuration: const Duration(microseconds: 500),
                          animationDuration: const Duration(microseconds: 500),
                          direction: Axis.horizontal,
                          child: Row(children: [
                            Text(
                              '${getTranslated('variation', context)}: ',
                              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),

                            CustomDirectionality(child: Text(variationText, style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                            )))
                          ],),
                        ),),
                      ]),
                    ) : const SizedBox(),
                  ]),
                ),

                Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                        if (cart!.quantity! > 1) {
                          Provider.of<CartProvider>(context, listen: false).setQuantity(isIncrement: false, fromProductView: false, cart: cart, productIndex: null);
                        }else {
                          Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.remove, size: 20),
                      ),
                    ),
                    Text(cart!.quantity.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                    InkWell(
                      onTap: () {
                        Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                        Provider.of<CartProvider>(context, listen: false).setQuantity(isIncrement: true, fromProductView: false, cart: cart, productIndex: null);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ]),
                ),

                !ResponsiveHelper.isMobile() ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: IconButton(
                    onPressed: () {
                      Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                      Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ) : const SizedBox(),

              ]),

              addOns.isNotEmpty ? SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  itemCount: addOns.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false).removeAddOn(cartIndex, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                          ),
                        ),
                        Text(addOns[index].name!, style: rubikRegular),
                        const SizedBox(width: 2),
                        CustomDirectionality(child: Text(PriceConverter.convertPrice(addOns[index].price), style: rubikMedium)),
                        const SizedBox(width: 2),
                        Text('(${cart!.addOnIds![index].quantity})', style: rubikRegular),
                      ]),
                    );
                  },
                ),
              ) : const SizedBox(),
            ])),
          ),
        ]),
      ),
    );
  }
}
