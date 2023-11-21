import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
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
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SetMenuPageView extends StatelessWidget {
  final SetMenuProvider setMenuProvider;
  final PageController pageController;
  const SetMenuPageView({Key? key, required this.setMenuProvider, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPage = (setMenuProvider.setMenuList!.length / 4).ceil();

    return PageView.builder(
      controller: pageController,
      itemCount: totalPage,
      onPageChanged: (index) {
        setMenuProvider.updateSetMenuCurrentIndex(index, totalPage);
      },
      itemBuilder: (context, index) {
        int initialLength = 4;
        int currentIndex = 4 * index;


        // ignore: unnecessary_statements
        (index + 1 == totalPage) ? initialLength = setMenuProvider.setMenuList!.length - (index * 4)  : 4;
        return ListView.builder(
            itemCount: initialLength, scrollDirection: Axis.horizontal, physics: const NeverScrollableScrollPhysics(), shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,vertical: Dimensions.paddingSizeExtraSmall),
            itemBuilder: (context, item) {
              int currentIndex0 = item  + currentIndex;
              String? name = '';
              setMenuProvider.setMenuList![currentIndex0].name!.length > 20 ? name = '${setMenuProvider.setMenuList![currentIndex0].name!.substring(0, 20)} ...' : name = setMenuProvider.setMenuList![currentIndex0].name;
              double? startingPrice;
              startingPrice = setMenuProvider.setMenuList![currentIndex0].price;

              double discount = setMenuProvider.setMenuList![currentIndex0].price! - PriceConverter.convertWithDiscount(
                  setMenuProvider.setMenuList![currentIndex0].price, setMenuProvider.setMenuList![currentIndex0].discount, setMenuProvider.setMenuList![currentIndex0].discountType)!;

              bool isAvailable = DateConverter.isAvailable(setMenuProvider.setMenuList![currentIndex0].availableTimeStarts!, setMenuProvider.setMenuList![currentIndex0].availableTimeEnds!, context);

              return OnHover(
                  builder: (isHover) {
                    return Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                        return InkWell(
                          hoverColor: Colors.transparent,
                          onTap: () {
                            showDialog(context: context, builder: (con) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: CartBottomSheet(
                                product: setMenuProvider.setMenuList![currentIndex0], fromSetMenu: true,
                                callback: (CartModel cartModel) {
                                  showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                                },
                              ),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                            child: Container(
                              width: 278,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                    spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                  )]
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholderRectangle, height: 225.0, width: 368, fit: BoxFit.cover,
                                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenuProvider.setMenuList![currentIndex0].image}',
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderRectangle, height: 225.0, width: 368, fit: BoxFit.cover),
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
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Text(name!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getCartTitleColor(context)), maxLines: 2, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                          RatingBar(rating: setMenuProvider.setMenuList![currentIndex0].rating!.isNotEmpty ? double.parse(setMenuProvider.setMenuList![currentIndex0].rating![0].average!) : 0.0, size: Dimensions.paddingSizeDefault),
                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                          FittedBox(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                                              children: [
                                                discount > 0 ? Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                  child: CustomDirectionality(child: Text(
                                                    PriceConverter.convertPrice(startingPrice),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:rubikBold.copyWith(
                                                      fontSize: Dimensions.fontSizeExtraSmall, decoration: TextDecoration.lineThrough,
                                                    ),
                                                  )),
                                                ) : const SizedBox(),

                                                CustomDirectionality(child: Text(
                                                  PriceConverter.convertPrice( startingPrice, discount: setMenuProvider.setMenuList![currentIndex0].discount,
                                                      discountType: setMenuProvider.setMenuList![currentIndex0].discountType),
                                                  style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor, overflow: TextOverflow.ellipsis),
                                                  maxLines: 1,
                                                )),

                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                          ElevatedButton(
                                              style : ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                                              onPressed: (){
                                                showDialog(context: context, builder: (con) => Dialog(
                                                  backgroundColor: Colors.transparent,
                                                  child: CartBottomSheet(
                                                    product: setMenuProvider.setMenuList![currentIndex0], fromSetMenu: true,
                                                    callback: (CartModel cartModel) {
                                                      showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                                                    },
                                                  ),
                                                ));
                                              }, child: Padding(
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Text(getTranslated('quick_view', context)!,style: robotoRegular), const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            ]),
                                          ))
                                        ]),
                                      ),
                                    ),

                                  ]),
                            ),
                          ),
                        );
                      }
                    );
                  }
              );
            }
        );
      },
    );
  }
}
