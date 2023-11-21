import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SetMenuView extends StatelessWidget {
  const SetMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SetMenuProvider>(
      builder: (context, setMenu, child) {
        return Column(
          children: [
           Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TitleWidget(title: getTranslated('set_menu', context), onTap: () {
                Navigator.pushNamed(context, Routes.getSetMenuRoute());
              }),
            ),

            SizedBox(
              height: 220,
              child: setMenu.setMenuList != null ? setMenu.setMenuList!.isNotEmpty ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                itemCount: setMenu.setMenuList!.length > 5 ? 5 : setMenu.setMenuList!.length,
                itemBuilder: (context, index){
                  double? startingPrice = setMenu.setMenuList![index].price;

                  double discount = setMenu.setMenuList![index].price! - PriceConverter.convertWithDiscount(
                      setMenu.setMenuList![index].price, setMenu.setMenuList![index].discount, setMenu.setMenuList![index].discountType)!;

                  bool isAvailable = DateConverter.isAvailable(setMenu.setMenuList![index].availableTimeStarts!, setMenu.setMenuList![index].availableTimeEnds!, context);

                  return Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            ResponsiveHelper.isMobile() ?
                            showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(
                              product: setMenu.setMenuList![index], fromSetMenu: true,
                              callback: (CartModel cartModel) {
                                showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                              },
                            )):
                            showDialog(context: context, builder: (con) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: CartBottomSheet(
                                product: setMenu.setMenuList![index], fromSetMenu: true,
                                callback: (CartModel cartModel) {
                                  showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                                },
                              ),
                            ));
                          },
                          child: Container(
                            height: 220,
                            width: 170,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5, spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                )]
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderRectangle, height: 110, width: 170, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: 110, width: 170, fit: BoxFit.cover),
                                    ),
                                  ),
                                  isAvailable ? const SizedBox() : Positioned(
                                    top: 0, left: 0, bottom: 0, right: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Text(getTranslated('not_available_now', context)!, textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                        color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                                      )),
                                    ),
                                  ),
                                ],
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(
                                      setMenu.setMenuList![index].name!,
                                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 2, overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    RatingBar(
                                      rating: setMenu.setMenuList![index].rating!.isNotEmpty ? double.parse(setMenu.setMenuList![index].rating![0].average!) : 0.0,
                                      size: 12,
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: CustomDirectionality(child: Text(
                                          PriceConverter.convertPrice(startingPrice, discount: setMenu.setMenuList![index].discount,
                                              discountType: setMenu.setMenuList![index].discountType),
                                          style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        ))),
                                        discount > 0 ? const SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      ],
                                    ),
                                    discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Flexible(child: CustomDirectionality(child: Text(
                                        PriceConverter.convertPrice( startingPrice),
                                        style: rubikBold.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context).hintColor.withOpacity(0.7),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ))),

                                      Icon(Icons.add, color: Theme.of(context).textTheme.bodyLarge!.color),
                                    ]) : const SizedBox(),
                                  ]),
                                ),
                              ),

                            ]),
                          ),
                        ),
                      );
                    }
                  );
                },
              ) : Center(child: Text(getTranslated('no_set_menu_available', context)!)) : const SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  const SetMenuShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
        return Container(
          height: 200,
          width: 150,
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: const Duration(seconds: 1),
            interval: const Duration(seconds: 1),
            enabled: Provider.of<SetMenuProvider>(context).setMenuList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 110, width: 150,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    color: Theme.of(context).shadowColor
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 130, color: Theme.of(context).shadowColor),

                    const Align(alignment: Alignment.centerRight, child: RatingBar(rating: 0.0, size: 12)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 10, width: 50, color: Theme.of(context).shadowColor),
                      const Icon(Icons.add, color: Colors.black),
                    ]),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

