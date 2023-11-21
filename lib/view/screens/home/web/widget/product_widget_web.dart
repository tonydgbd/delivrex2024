import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';


class ProductWidgetWeb extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;

  const ProductWidgetWeb({Key? key, required this.product, this.fromPopularItem = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? startingPrice;
    startingPrice = product.price;


    double? priceDiscount = PriceConverter.convertDiscount(context, product.price, product.discount, product.discountType);

    bool isAvailable = product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverter.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!, context) : false;

    return ResponsiveHelper.isMobilePhone() ? _itemView(isAvailable, priceDiscount, startingPrice)
        : OnHover(builder: (isHover) {
          return _itemView(isAvailable, priceDiscount, startingPrice);
        });
  }

  void _addToCart(BuildContext context, int cartIndex, ) {
    ResponsiveHelper.isMobile() ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheet(
        product: product,
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ) : showDialog(context: context, builder: (con) => Dialog(
      backgroundColor: Colors.transparent,
      child: CartBottomSheet(
        product: product,
        fromSetMenu: true,
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ));
  }

  Consumer<CartProvider> _itemView(bool isAvailable, double? priceDiscount, double? startingPrice) {
    return Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          int cartIndex =   cartProvider.getCartIndex(product);
          String productImage = '';
          try{
            productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}';
          }catch(e) {
            debugPrint('error ===> $e');
          }

          return InkWell(
            onTap: () => _addToCart(context, cartIndex),
            child: Stack(
              children: [
                Container(
                  // height: 220,
                  // width: 170,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300]!,
                          blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                          spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholderRectangle, fit: BoxFit.cover, height: 105, width: 195,
                                image: productImage,
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle,  fit: BoxFit.cover,  height: 105, width: 195),
                              ),
                            ),
                            isAvailable ? const SizedBox() : Positioned(
                              top: 0, left: 0, bottom: 0, right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), color: Colors.black.withOpacity(0.6)),
                                child: Text(getTranslated('not_available_now', context)!, textAlign: TextAlign.center,
                                    style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)
                                ),
                              ),
                            ),
                          ],
                        ),

                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(product.name!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.getCartTitleColor(context)), maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              RatingBar(rating: product.rating!.isNotEmpty ? double.parse(product.rating![0].average!) : 0.0, size: Dimensions.paddingSizeDefault),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    priceDiscount! > 0 ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                        child: CustomDirectionality(child: Text(
                                          PriceConverter.convertPrice(startingPrice),
                                          style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, decoration: TextDecoration.lineThrough),
                                        ))) : const SizedBox(),

                                    CustomDirectionality(child: Text(
                                      PriceConverter.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
                                      style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                    ))
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 100,
                                  child: FittedBox(
                                      child: ElevatedButton(
                                          style : ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                          onPressed:() => _addToCart(context, cartIndex),
                                          child: Text(getTranslated('quick_view', context)!,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                                      )),
                                ),
                              ),
                            ]),
                          ),
                        ),

                      ]),
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WishButton(product: product),
                      ),
                    )
                )
              ],
            ),
          );
        }
    );
  }
}



