
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
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? startingPrice;

    startingPrice = product.price;

    double?  discountedPrice = PriceConverter.convertWithDiscount( product.price, product.discount, product.discountType);

    bool isAvailable = DateConverter.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!, context);




    return Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          String productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.productImageUrl ?? ''}/${product.image ?? ''}';
          
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: InkWell(
            onTap: () {
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
              ): showDialog(context: context, builder: (con) => Dialog(
               backgroundColor: Colors.transparent,
                 child: CartBottomSheet(
                   product: product,
                   callback: (CartModel cartModel) {
                     showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                   },
                 ),
             )) ;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )],
              ),
              child: Row(children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage, height: 70, width: 85, fit: BoxFit.cover,
                        image: productImage,
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
                    Text(product.name!, style: rubikMedium.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    product.rating != null ? RatingBar(
                      rating: product.rating!.isNotEmpty ? double.parse(product.rating![0].average!) : 0.0, size: 10,
                    ) : const SizedBox(),
                    const SizedBox(height: 5),

                    CustomDirectionality(
                      child: Text(
                        PriceConverter.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
                        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                    product.price! > discountedPrice! ? CustomDirectionality(
                      child: Text(PriceConverter.convertPrice(startingPrice), style: rubikMedium.copyWith(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        decoration: TextDecoration.lineThrough,
                        fontSize: Dimensions.fontSizeExtraSmall,
                      )),
                    ) : const SizedBox(),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                    WishButton(product: product, edgeInset: const EdgeInsets.all(5)),

                  const Expanded(child: SizedBox()),
                  const Icon(Icons.add),
                ]),
              ]),
            ),
          ));
      }
    );
  }
}
